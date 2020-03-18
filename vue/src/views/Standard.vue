<template>
  <div class="page--standard">
    <div class="page--standard__sidebar--left" v-if="!loading">
      <div class="page--standard__sidebar--left__logo">
        <img :src="standard.organization.logoUrl" :alt="standard.organizationTitle" class="page--standard__sidebar--left__logo__logo" />
      </div>
      <div class="page--standard__sidebar--left__occupation-name">
        <!-- <Tour
          content="This left hand section is your Standard's Details."
          :skip="() => {}"
          :close="() => {}"
          v-if="editing"
        /> -->
        <span>{{ standard.title }}</span>
      </div>
      <div class="page--standard__sidebar--left__organization-name">{{ standard.organizationTitle }}</div>
      <div class="page--standard__sidebar--left__actions">
        <button role="button" class="button button--square page--standard__sidebar--left__actions__action" @click="duplicateStandard" :disabled="!sessionActive">
          Duplicate
        </button>
        <div class="page--standard__sidebar--left__actions__action page--standard__sidebar--left__actions__action--dropdown">
          <button role="button" class="button button--square" @click="toggleDownloadOpen" :disabled="!standard.pdfUrl && !standard.excelUrl">
            Download
          </button>
          <div class="page--standard__sidebar--left__actions__action--dropdown__list" v-if="downloadOpen">
            <a class="page--standard__sidebar--left__actions__action--dropdown__list__item" :href="standard.pdfUrl" @click="toggleDownloadOpen" target="_blank" v-if="standard.pdfUrl">
              Download as PDF
            </a>
            <a class="page--standard__sidebar--left__actions__action--dropdown__list__item" :href="standard.excelUrl" @click="toggleDownloadOpen" target="_blank" v-if="standard.excelUrl">
              Download as CSV
            </a>
          </div>
        </div>
      </div>
      <div class="page--standard__sidebar--left__divider--stats" />
      <div class="page--standard__sidebar--left__work-process-data">
        <div class="page--standard__sidebar--left__work-process-data__stat">
          <div class="page--standard__sidebar--left__work-process-data__stat__number">{{ standard.workProcesses.length }}</div>
          <div class="page--standard__sidebar--left__work-process-data__stat__text">Work</div>
          <div class="page--standard__sidebar--left__work-process-data__stat__text">Processes</div>
        </div>
        <div class="page--standard__sidebar--left__work-process-data__stat">
          <div class="page--standard__sidebar--left__work-process-data__stat__number">{{ standard.totalNumberOfSkills }}</div>
          <div class="page--standard__sidebar--left__work-process-data__stat__text">Total</div>
          <div class="page--standard__sidebar--left__work-process-data__stat__text">Skills</div>
        </div>
        <div class="page--standard__sidebar--left__work-process-data__stat">
          <div class="page--standard__sidebar--left__work-process-data__stat__number">{{ standard.totalNumberOfHours }}</div>
          <div class="page--standard__sidebar--left__work-process-data__stat__text">Total</div>
          <div class="page--standard__sidebar--left__work-process-data__stat__text">Hours</div>
        </div>
      </div>
      <div class="page--standard__sidebar--left__about">
        <div class="page--standard__sidebar--left__about__title">
          About this standard
        </div>
        <div class="input input--subtle page--standard__sidebar--left__about__input" :class="{ 'input--error': standard.propertyInvalid('title') }">
          <label class="input__label page--standard__sidebar--left__about__input__label" for="standard-title">Title</label>
          <TextArea class="input__input page--standard__sidebar--left__about__input__input" id="standard-title" v-model="standard.title" placeholder="Standard Title" v-if="editing" @input="saveStandard" />
          <div class="page--standard__sidebar--left__about__input__text" v-html="standard.title" v-if="!editing" />
        </div>
        <div class="input input--subtle page--standard__sidebar--left__about__input">
          <label class="input__label page--standard__sidebar--left__about__input__label">Developed by</label>
          <div class="page--standard__sidebar--left__about__input__text" v-html="standard.organizationTitle" />
        </div>
        <div class="input input--subtle page--standard__sidebar--left__about__input" v-if="standard.parentOccupationStandard">
          <label class="input__label page--standard__sidebar--left__about__input__label">Duplicated from</label>
          <div class="page--standard__sidebar--left__about__input__text" v-html="standard.parentOccupationStandard.title" />
        </div>
        <div class="input input--subtle page--standard__sidebar--left__about__input">
          <label class="input__label page--standard__sidebar--left__about__input__label">Estimated hours</label>
          <div class="page--standard__sidebar--left__about__input__text">
            <span v-html="standard.occupation.termLengthMin" />
            <span v-if="standard.occupation.termLengthMin !== standard.occupation.termLengthMax"> — </span>
            <span v-if="standard.occupation.termLengthMin !== standard.occupation.termLengthMax" v-html="standard.occupation.termLengthMax" />
          </div>
        </div>
        <div class="input input--subtle page--standard__sidebar--left__about__input">
          <label class="input__label page--standard__sidebar--left__about__input__label">Type</label>
          <div class="page--standard__sidebar--left__about__input__text" v-html="standard.occupation.kind" />
        </div>
        <div class="input input--subtle page--standard__sidebar--left__about__input">
          <label class="input__label page--standard__sidebar--left__about__input__label">Occupation</label>
          <div class="page--standard__sidebar--left__about__input__text" v-html="standard.occupation.title" />
        </div>
        <div class="input input--subtle page--standard__sidebar--left__about__input" v-if="standard.occupation.onetCode">
          <label class="input__label page--standard__sidebar--left__about__input__label">O*NET – SOC Code</label>
          <div class="page--standard__sidebar--left__about__input__text" v-html="standard.occupation.onetCode" />
        </div>
        <div class="input input--subtle page--standard__sidebar--left__about__input" v-if="standard.occupation.rapidsCode">
          <label class="input__label page--standard__sidebar--left__about__input__label">Rapids Code</label>
          <div class="page--standard__sidebar--left__about__input__text" v-html="standard.occupation.rapidsCode" />
        </div>
      </div>
    </div>
    <div class="page--standard__body">
      <Loading v-if="loading" />
      <div class="page--standard__body__actions" v-if="editing">
        <div class="page--standard__body__actions__action">
          <button role="button" class="button button--square button--alternative" @click="addNewWorkProcess" :disabled="addNewWorkProcessDisabled">
            <img :src="ICON_PLUS_BLUE" alt="New Work Process plus icon" class="page--standard__body__actions__action__icon" />
            <span>
              New Work Process
            </span>
          </button>
          <!-- <Tour
            content='Click the "+ New Work Process" button to add a new work process to your standard.'
            :skip="() => {}"
            :close="() => {}"
            v-if="editing"
          /> -->
        </div>
        <button role="button" class="button button--square button--alternative page--standard__body__actions__action" @click="addSkill" :disabled="addNewSkillDisabled">
          <img :src="ICON_PLUS_BLUE" alt="New Skill plus icon" class="page--standard__body__actions__action__icon" />
          <span>New Skill</span>
        </button>
      </div>
      <!-- Work Processes -->
      <StandardWorkProcess
        v-for="(workProcess, workProcessIndex) in standard.workProcesses"
        :key="`work-process-${workProcess.synced ? `id-${workProcess.id}` : workProcessIndex}`"
        :workProcessIndex="workProcessIndex"
        :editing="editing"
      />
      <StandardSkill
        v-for="(skill, skillIndex) in standard.skills"
        :key="`skill-${skill.synced ? `id-${skill.id}` : skillIndex}`"
        :skillIndex="skillIndex"
        :editing="editing"
        :onSkillInput="onSkillInput"
      />
    </div>
  </div>
</template>

<script lang="ts">
import _debounce from 'lodash/debounce';
import _flatten from 'lodash/flatten';
import _times from 'lodash/times';
import _some from 'lodash/some';
import _get from 'lodash/get';

import Vue from 'vue';

import {
  Component, Provide,
} from 'vue-property-decorator';

import { mapState, mapGetters } from 'vuex';

import ICON_PLUS_BLUE from '@/assets/icon-plus-blue.svg';

import Loading from '@/components/Loading.vue';
import StandardWorkProcess from '@/components/StandardWorkProcess.vue';
import StandardSkill from '@/components/StandardSkill.vue';
import Tour from '@/components/Tour.vue';

import OccupationStandard from '@/models/OccupationStandard';
import WorkProcess from '@/models/WorkProcess';
import Skill from '@/models/Skill';

import TextArea from '@/components/TextArea.vue';

@Component({
  components: {
    Loading,
    TextArea,
    StandardWorkProcess,
    StandardSkill,
    Tour,
  },
})
export default class Standard extends Vue {
  @Provide('ICON_PLUS_BLUE') ICON_PLUS_BLUE: string = ICON_PLUS_BLUE

  downloadOpen: boolean = false

  toggleDownloadOpen() {
    this.downloadOpen = !this.downloadOpen;
  }

  created() {
    this.saveStandard = _debounce(this.saveStandard, 500).bind(this);
  }

  beforeRouteUpdate(to, from, next) {
    this.$store.dispatch('standards/getStandard', to.params.id);
    next();
  }

  onSkillInput() {
    this.$forceUpdate();
  }

  async saveStandard() {
    try {
      await this.standard.save();
    } catch (e) {
      (Vue as any).rollbar.error(e);
    }

    this.$store.dispatch('standards/refreshSelectedStandard');
  }

  async addSkill() {
    await this.$store.dispatch('standards/addNewSkillToSelectedStandard');
  }

  async addNewWorkProcess() {
    await this.$store.dispatch('standards/addNewWorkProcessToSelectedStandard');
  }

  duplicateStandard() {
    this.$store.dispatch('standards/updateStandardToDuplicate', this.standard);

    this.$router.push({
      name: 'standardDuplicate',
      params: {
        id: String(this.standard.id),
      },
    });
  }

  protected get editing() {
    return this.standard && this.standard.loggedInUserIsCreator;
  }

  protected get addNewWorkProcessDisabled() {
    const workProcess: WorkProcess | undefined = _get(this.standard, 'workProcesses[0]');
    return workProcess && workProcess.propertyInvalid('title');
  }

  protected get addNewSkillDisabled() {
    return _get(this.standard, 'skills[0].invalid');
  }

  protected get standard(): OccupationStandard {
    return this.$store.state.standards.selectedStandard || {};
  }

  protected get loading() {
    return this.$store.state.standards.selectedStandardLoading;
  }

  protected get sessionActive() {
    return this.$store.getters['session/isActive'];
  }
}
</script>

<style scoped lang="scss">
@import "@/scss/colors";
@import "@/scss/navbars";
@import "@/scss/mixins";
@import "@/scss/standards";

$sidebar-left-width: 20rem;

.page--standard {
  @include breakpoint--above-sm {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: stretch;
  }
  min-height: 100%;
}

.page--standard__sidebar--left {
  width: $sidebar-left-width;
  background: $color-white;
  padding: 1rem 1.5rem;
  box-shadow: 0 2px 4px 0 rgba(12, 0, 51, 0.1);
  flex-shrink: 0;
  @include breakpoint--above-sm {
    min-height: calc(100vh - #{$nav-top-height});
  }
  @include breakpoint--sm {
    // display: none;
    width: 100%;
  }
}

.page--standard__sidebar--left__logo {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 8rem;
  padding: 1rem;
}

.page--standard__sidebar--left__logo__logo {
  max-width: 100%;
  height: 100%;
}

.page--standard__sidebar--left__occupation-name {
  font-size: 1.5rem;
  line-height: 2rem;
  margin-bottom: 1rem;
  padding: 0 1.5rem;
  word-break: break-word;
}

.page--standard__sidebar--left__organization-name {
  color: $color-text-light;
  word-break: break-word;
  margin-bottom: 1.5rem;
}

.page--standard__sidebar--left__actions {
  display: flex;
  justify-content: center;
}

.page--standard__sidebar--left__actions__action {
  &:not(:last-child) {
    margin-right: .75rem;
  }
}

.page--standard__sidebar--left__divider--stats {
  height: 1px;
  border-bottom: 1px solid $color-gray-light;
  margin-top: 2rem;
  margin-bottom: 2rem;
}

.page--standard__sidebar--left__work-process-data {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  justify-content: space-between;
  margin-bottom: 2rem;
}

.page--standard__sidebar--left__work-process-data__stat__number {
  font-weight: 700;
  margin-bottom: 0.5rem;
  color: $color-blue;
}

.page--standard__sidebar--left__work-process-data__stat__text {
  opacity: 0.6;
  font-size: 0.9rem;
}

.page--standard__body {
  flex-grow: 1;
  padding: 2rem;
  @include breakpoint--sm {
    padding: 1rem;
  }
}

.page--standard__sidebar--left__about {
  padding-top: 1rem;
  border-top: 1px solid $color-gray-light;
  text-align: left;
}

.page--standard__sidebar--left__about__title {
  font-size: 1rem;
  font-weight: 500;
  margin-bottom: 1.25rem;
}

.page--standard__sidebar--left__about__input__label {
  font-size: .9rem;
  color: $color-text-light;
  margin-bottom: 0.25rem;
}

.page--standard__sidebar--left__about__input__input {
  font-size: 1rem;
  width: 100%;
}

.page--standard__sidebar--left__about__input__text {
  font-size: 1rem;
  padding-top: .25rem;
  line-height: 1.25rem;
  word-break: break-word;
}

.page--standard__body__actions {
  display: flex;
  flex-direction: row;
}

.page--standard__body__actions__action {
  margin-bottom: 1.5rem;
}

.page--standard__body__actions__action {
  display: flex;
  justify-content: center;
  align-items: center;

  &:not(:last-child) {
    margin-right: 1rem;
  }
}

.page--standard__body__actions__action__icon {
  height: .9rem;
  margin-right: .5rem;
}

.page--standard__sidebar--left__about__input {
  &:not(:last-child) {
    margin-bottom: 1rem;
  }
}

.page--standard__sidebar--left__actions__action--dropdown {
  position: relative;
}

.page--standard__sidebar--left__actions__action--dropdown__list__item {
  display: block;
  cursor: pointer;
  padding: 0.6rem 1rem;
  text-align: left;
  color: $color-black;

  &:not(:last-child) {
    border-bottom: 1px solid $color-gray-border;
  }

  &:hover {
    background: darken($color: $color-white, $amount: 10);
  }
}

.page--standard__sidebar--left__actions__action--dropdown__list {
  position: absolute;
  top: 100%;
  left: 0;
  min-width: 100%;
  background: $color-white;
  overflow: auto;
  border: 1px solid $color-gray-border;
  box-shadow: 0 10px 20px 0 transparentize($color-link-blue, 0.9);
  white-space: nowrap;
  border-radius: 4px;
  border-top-left-radius: 0;
}
</style>
