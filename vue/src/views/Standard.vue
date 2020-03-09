<template>
  <div class="page--standard">
    <div class="page--standard__sidebar--left" v-if="!loading">
      <div class="page--standard__sidebar--left__logo">
        <img :src="standard.organization.logoUrl" :alt="standard.organizationTitle" class="page--standard__sidebar--left__logo__logo" />
      </div>
      <div class="page--standard__sidebar--left__occupation-name">{{ standard.title }}</div>
      <div class="page--standard__sidebar--left__organization-name">{{ standard.organizationTitle }}</div>
      <div class="page--standard__sidebar--left__actions">
        <button role="button" class="button button--square page--standard__sidebar--left__actions__action" @click="duplicateStandard" :disabled="!sessionActive">
          Duplicate
        </button>
        <button role="button" class="button button--square page--standard__sidebar--left__actions__action" :disabled="true">
          Download
        </button>
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
          <label class="input__label page--standard__sidebar--left__about__input__label" for="standard-title">Standard Title</label>
          <TextArea class="input__input page--standard__sidebar--left__about__input__input" id="standard-title" v-model="standard.title" placeholder="Standard Title" v-if="editing" @input="saveStandard" />
          <div class="page--standard__sidebar--left__about__input__text" v-html="standard.title" v-if="!editing" />
        </div>
      </div>
    </div>
    <div class="page--standard__body">
      <Loading v-if="loading" />
      <div class="page--standard__body__actions" v-if="editing">
        <button role="button" class="button button--square button--alternative page--standard__body__actions__action" @click="addNewWorkProcess" :disabled="addNewWorkProcessDisabled">
          <img :src="ICON_PLUS_BLUE" alt="New Work Process plus icon" class="page--standard__body__actions__action__icon" />
          <span>New Work Process</span>
        </button>
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

import { mapState, mapGetters } from 'vuex';

import ICON_PLUS_BLUE from '@/assets/icon-plus-blue.svg';

import Loading from '@/components/Loading.vue';
import StandardWorkProcess from '@/components/StandardWorkProcess.vue';
import StandardSkill from '@/components/StandardSkill.vue';

import OccupationStandard from '@/models/OccupationStandard';
import WorkProcess from '@/models/WorkProcess';
import Skill from '@/models/Skill';

import TextArea from '@/components/TextArea.vue';

export default {
  name: 'standard',
  components: {
    Loading,
    TextArea,
    StandardWorkProcess,
    StandardSkill,
  },
  created() {
    (this as any).saveStandard = _debounce((this as any).saveStandard, 500).bind(this);
  },
  beforeRouteUpdate(to, from, next) {
    (this as any).$store.dispatch('standards/getStandard', to.params.id);
    next();
  },
  methods: {
    onSkillInput() {
      (this as any).$forceUpdate();
    },
    async saveStandard() {
      try {
        await (this as any).standard.save();
      } catch (e) {
        console.log('Failed to save standard', e);
      }

      (this as any).$store.dispatch('standards/refreshSelectedStandard');
    },
    async addSkill() {
      await (this as any).$store.dispatch('standards/addNewSkillToSelectedStandard');
    },
    async addNewWorkProcess() {
      await (this as any).$store.dispatch('standards/addNewWorkProcessToSelectedStandard');
    },
    duplicateStandard() {
      (this as any).$store.dispatch('standards/updateStandardToDuplicate', (this as any).standard);

      (this as any).$router.push({
        name: 'standardDuplicate',
        params: {
          id: (this as any).standard.id,
        },
      });
    },
  },
  data() {
    return {
      ICON_PLUS_BLUE,
    };
  },
  computed: {
    ...mapState({
      standard: (state: any): OccupationStandard => state.standards.selectedStandard || {},
      loading: (state: any) => state.standards.selectedStandardLoading,
    }),
    ...mapGetters({
      sessionActive: 'session/isActive',
    }),
    editing() {
      return (this as any).standard && (this as any).standard.loggedInUserIsCreator;
    },
    addNewWorkProcessDisabled() {
      const workProcess: WorkProcess | undefined = _get((this as any).standard, 'workProcesses[0]');
      return workProcess && workProcess.propertyInvalid('title');
    },
    addNewSkillDisabled() {
      return _get((this as any).standard, 'skills[0].invalid');
    },
  },
};
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
  margin-bottom: 1.5rem;
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
</style>
