<template>
  <div class="page--standard">
    <div class="page--standard__sidebar--left" v-if="!loading">
      <div class="page--standard__sidebar--left__logo">
        <img :src="standard.organization.logoUrl" :alt="standard.organizationTitle" class="page--standard__sidebar--left__logo__logo" />
      </div>
      <div class="page--standard__sidebar--left__occupation-name">{{ standard.title }}</div>
      <div class="page--standard__sidebar--left__organization-name">{{ standard.organizationTitle }}</div>
      <div class="page--standard__sidebar--left__actions">
        <button role="button" class="button button--square page--standard__sidebar--left__actions__action" :disabled="true">
          Share
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
          <TextArea class="input__input page--standard__sidebar--left__about__input__input" id="standard-title" v-model="standard.title" placeholder="Standard Title" v-if="editing" />
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
        <button role="button" class="button button--square button--alternative page--standard__body__actions__action" @click="addNewWorkSkill()" :disabled="addNewSkillDisabled">
          <img :src="ICON_PLUS_BLUE" alt="New Work Process plus icon" class="page--standard__body__actions__action__icon" />
          <span>New Skill</span>
        </button>
      </div>
      <div
        class="page--standard__body__work-process"
        v-for="(workProcess, workProcessIndex) in standard.workProcesses"
        :key="`work-process-${workProcessIndex}`"
        :class="{
          'page--standard__body__work-process--error': workProcess.invalid,
          'page--standard__body__work-process--expanded': workProcessExpanded(workProcess),
          'page--standard__body__work-process--editing': editing
        }"
      >
        <div class="page--standard__body__work-process__wrapper" @click="toggleWorkProcess(workProcess)">
          <div class="page--standard__body__work-process__wrapper__icon--folder">
            <img :src="ICON_FOLDER" alt="Work Process icon" v-if="workProcessExpanded(workProcess)" />
            <img :src="ICON_FOLDER_CLOSED" alt="Work Process icon" v-if="!workProcessExpanded(workProcess)" />
          </div>
          <div class="page--standard__body__work-process__wrapper__vertical-group">
            <div class="page--standard__body__work-process__wrapper__vertical-group__label">
              Work Process
            </div>
            <div class="page--standard__body__work-process__wrapper__vertical-group__title" v-if="!editing">
              {{ workProcess.title }}
            </div>
            <div class="input input--subtle page--standard__body__work-process__wrapper__vertical-group__input" @click.stop="" v-if="editing" :class="{ 'input--error': workProcess.propertyInvalid('title') }">
              <TextArea v-model="workProcess.title" class="input__input page--standard__body__work-process__wrapper__vertical-group__input__input" ref="workProcessTitle" />
            </div>
          </div>
          <button class="button button--link page--standard__body__work-process__wrapper__icon--delete" v-if="editing" @click.stop="deleteWorkProcess(workProcess)">
            <FontAwesomeIcon :icon="['fas', 'trash-alt']" class="page--standard__body__work-process__wrapper__icon--delete__icon" />
          </button>
          <div class="page--standard__body__work-process__wrapper__icon--caret">
            <FontAwesomeIcon :icon="['fas', 'caret-down']" class="page--standard__body__work-process__wrapper__icon--caret__icon" v-if="workProcess.expanded" />
            <FontAwesomeIcon :icon="['fas', 'caret-right']" class="page--standard__body__work-process__wrapper__icon--caret__icon" v-if="!workProcess.expanded" />
          </div>
        </div>
        <div class="page--standard__body__work-process__skills" v-if="workProcess.expanded">
          <div class="page--standard__body__work-process__skills__actions" v-if="editing">
            <button role="button" class="button button--square button--alternative page--standard__body__work-process__skills__actions__action" @click="addNewWorkSkill(workProcess)" :disabled="addNewWorkProcessSkillDisabled(workProcess)">
              <img :src="ICON_PLUS_BLUE" alt="New Work Process plus icon" class="page--standard__body__work-process__skills__actions__action__icon" />
              <span>New Skill</span>
            </button>
          </div>
          <div class="page--standard__body__work-process__skills__skill" v-for="(skill, skillIndex) in workProcess.skills" :key="`work-process-${workProcessIndex}-skill-${skillIndex}`">
            <div class="page--standard__body__work-process__skills__skill__vertical-group">
              <div class="page--standard__body__work-process__skills__skill__vertical-group__label">
                Skill
              </div>
              <div class="page--standard__body__work-process__skills__skill__vertical-group__description" v-if="!editing">
                {{ skill.description }}
              </div>
              <div class="input input--subtle page--standard__body__work-process__skills__skill__vertical-group__input" :class="{ 'input--error': skill.invalid }" v-if="editing">
                <TextArea class="input__input page--standard__body__work-process__skills__skill__vertical-group__input__input" v-model="skill.description" ref="workProcessSkillDescription" />
              </div>
            </div>
            <button class="button button--link page--standard__body__work-process__skills__skill__icon--delete" v-if="editing" @click.stop="deleteWorkProcessSkill(workProcess, skill)">
              <FontAwesomeIcon :icon="['fas', 'trash-alt']" class="page--standard__body__work-process__skills__skill__icon--delete__icon" />
            </button>
          </div>
        </div>
      </div>
      <div
        class="page--standard__body__skill"
        v-for="(skill, skillIndex) in standard.skills"
        :key="`skill-${skillIndex}`"
        :class="{
          'page--standard__body__skill--error': skill.invalid,
          'page--standard__body__skill--editing': editing
        }"
      >
        <div class="page--standard__body__skill__wrapper">
          <div class="page--standard__body__skill__wrapper__vertical-group">
            <div class="page--standard__body__skill__wrapper__vertical-group__label">
              Skill
            </div>
            <div class="page--standard__body__skill__wrapper__vertical-group__description" v-if="!editing">
              {{ skill.description }}
            </div>
            <div class="input input--subtle page--standard__body__skill__wrapper__vertical-group__input" :class="{ 'input--error': skill.invalid }" v-if="editing">
              <TextArea class="input__input page--standard__body__skill__wrapper__vertical-group__input__input" v-model="skill.description" ref="skillDescription" />
            </div>
          </div>
          <button class="button button--link page--standard__body__skill__wrapper__icon--delete" v-if="editing" @click.stop="deleteSkill(skill)">
            <FontAwesomeIcon :icon="['fas', 'trash-alt']" class="page--standard__body__skill__wrapper__icon--delete__icon" />
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import _flatten from 'lodash/flatten';
import _times from 'lodash/times';
import _some from 'lodash/some';
import _get from 'lodash/get';

import Vue from 'vue';

import { mapState } from 'vuex';

import ICON_PLUS_BLUE from '@/assets/icon-plus-blue.svg';
import ICON_FOLDER from '@/assets/folder.svg';
import ICON_FOLDER_CLOSED from '@/assets/folder-closed.svg';

import Loading from '@/components/Loading.vue';
import OccupationStandard from '@/models/OccupationStandard';
import WorkProcess from '@/models/WorkProcess';
import Skill from '@/models/Skill';

import TextArea from '@/components/TextArea.vue';

const NEW_WORK_PROCESS_TITLE = 'New Work Process';
const NEW_SKILL_TITLE = 'New Skill';

export default {
  name: 'standard',
  components: {
    Loading,
    TextArea,
  },
  methods: {
    toggleWorkProcess(workProcess: any) {
      Vue.set(workProcess, 'expanded', !workProcess.expanded);
    },
    workProcessExpanded(workProcess) {
      return (workProcess && !!workProcess.expanded);
    },
    addNewWorkSkill(workProcess?: WorkProcess) {
      const freshSkill: Skill = new Skill({ description: NEW_SKILL_TITLE });
      (workProcess || this.standard).skills.unshift(freshSkill); // TODO: move to action?

      setTimeout(() => {
        _some(_flatten([workProcess
          ? this.$refs.workProcessSkillDescription
          : this.$refs.skillDescription,
        ]), (ref) => {
          if (ref.$el.value === NEW_SKILL_TITLE) {
            Vue.set(freshSkill, 'description', '');
            ref.$el.focus();
            if (!workProcess) {
              ref.$el.scrollIntoView();
            }
            return true;
          }

          return false;
        });
      });
    },
    addNewWorkProcess() {
      const freshWorkProcess: WorkProcess = new WorkProcess({ title: NEW_WORK_PROCESS_TITLE });
      this.standard.workProcesses.unshift(freshWorkProcess); // TODO: move to action?

      setTimeout(() => {
        _some(_flatten([this.$refs.workProcessTitle]), (ref) => {
          if (ref.$el.value === NEW_WORK_PROCESS_TITLE) {
            Vue.set(freshWorkProcess, 'title', '');
            ref.$el.focus();
            return true;
          }

          return false;
        });
      });
    },
    addNewWorkProcessSkillDisabled(workProcess: WorkProcess) {
      return _get(workProcess, 'skills[0].invalid');
    },
    deleteWorkProcess(workProcess) {
      this.standard.workProcesses.splice(this.standard.workProcesses.indexOf(workProcess), 1); // TODO: move to action
    },
    deleteWorkProcessSkill(workProcess, skill) {
      workProcess.skills.splice(workProcess.skills.indexOf(skill), 1); // TODO: move to action
    },
    deleteSkill(skill) {
      this.standard.skills.splice(this.standard.skills.indexOf(skill), 1); // TODO: move to action
    },
  },
  beforeDestroy() {
    this.standard.workProcesses.forEach((workProcess, key) => {
      delete this.standard.workProcesses[key].expanded;
    });
  },
  beforeRouteLeave(to, from, next) {
    this.$store.dispatch('standards/editSelectedStandard', false);
    next();
  },
  data() {
    return {
      ICON_PLUS_BLUE,
      ICON_FOLDER,
      ICON_FOLDER_CLOSED,
    };
  },
  computed: {
    ...mapState({
      standard: (state: any): OccupationStandard => state.standards.selectedStandard || {},
      loading: (state: any) => state.standards.selectedStandardLoading,
      editing: (state: any) => state.standards.selectedStandardEditing,
    }),
    addNewWorkProcessDisabled() {
      const workProcess: WorkProcess | undefined = _get(this.standard, 'workProcesses[0]');
      return workProcess && workProcess.propertyInvalid('title');
    },
    addNewSkillDisabled() {
      return _get(this.standard, 'skills[0].invalid');
    },
  },
};
</script>

<style scoped lang="scss">
@import "@/scss/colors";
@import "@/scss/navbars";
@import "@/scss/mixins";

$sidebar-left-width: 20rem;

$work-process-height: 6rem;
$skill-height: 5rem;

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
  height: 6rem;
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

.page--standard__body__work-process {
  min-height: $work-process-height;
  overflow: hidden;
  width: 100%;
  margin-bottom: 1rem;
  box-shadow: 0 2px 4px 0 rgba(12, 0, 51, 0.1);
  border-radius: 4px;
  border-left: 3px solid $color-blue;

  &.page--standard__body__work-process--error {
    border-color: $color-salmon;
  }
}

.page--standard__body__work-process--editing .page--standard__body__work-process__skills__skill {
  padding-right: 0;
}

.page--standard__body__work-process:not(.page--standard__body__work-process--expanded) {
  .page--standard__body__work-process__wrapper__vertical-group__title {
    max-height: 3rem;
  }
}

.page--standard__body__work-process__wrapper {
  display: flex;
  flex-direction: row;
  // justify-content: space-between;
  min-height: $work-process-height;
  background: $color-white;
  cursor: pointer;
  border-bottom: 1px solid $color-gray-light;
  overflow: hidden;
}

.page--standard__body__work-process__wrapper__vertical-group {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  padding: 0.5rem 0;
  flex-grow: 1;
}

.page--standard__body__work-process__wrapper__vertical-group__label {
  font-size: 0.9rem;
  color: gray;
  margin-bottom: 0.25rem;
  margin-top: 0.5rem;
}

.page--standard__body__work-process__wrapper__vertical-group__input__input,
.page--standard__body__work-process__wrapper__vertical-group__title {
  font-size: 1.25rem;
  line-height: 1.5rem;
  overflow: hidden;
  font-weight: 500;
}

.page--standard__body__work-process__wrapper__icon--folder {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  width: 3.5rem;
}

.page--standard__body__work-process__wrapper__icon--caret {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  margin-left: auto;
  width: 3.5rem;
  color: $color-blue;
}

.page--standard__body__skill__wrapper__icon--delete,
.page--standard__body__work-process__skills__skill__icon--delete,
.page--standard__body__work-process__wrapper__icon--delete {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  margin-left: auto;
  width: 3.5rem;
  color: $color-salmon;
  font-size: 1.125rem;
}

.page--standard__body__work-process__skills {
  display: flex;
  flex-direction: column;
  padding: 0 0.5rem;
}

.page--standard__body__work-process__skills__skill {
  display: flex;
  flex-direction: row;
  // justify-content: space-between;
  background: $color-white;
  width: 100%;
  border: 1px solid $color-gray-light;
  margin-bottom: 0.5rem;
  &:first-child {
    margin-top: .5rem;
  }
  box-shadow: 0 2px 4px 0 rgba(12, 0, 51, 0.1);
  min-height: $work-process-height;
  border-radius: 4px;
  cursor: pointer;
  padding: 0 2rem;
}

.page--standard__body__work-process__skills__skill__vertical-group {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  padding: 1rem 0;
  align-items: stretch;
  text-align: left;
  flex-grow: 1;
}

.page--standard__body__skill__wrapper__vertical-group__input__input,
.page--standard__body__skill__wrapper__vertical-group__input {
  width: 100%;
}

.page--standard__body__work-process__skills__skill__vertical-group__input__input,
.page--standard__body__work-process__skills__skill__vertical-group__input {
  width: 100%;
}

.page--standard__body__work-process__skills__skill__vertical-group__label {
  font-size: 0.9rem;
  color: gray;
  margin-bottom: 0.25rem;
}

.page--standard__body__work-process__wrapper__vertical-group__title,
.page--standard__body__work-process__skills__skill__vertical-group__description {
  text-align: left;
}

.page--standard__body__work-process__skills__skill__vertical-group__description {
  font-size: 1rem;
}

.page--standard__body__work-process__wrapper__vertical-group__input,
.page--standard__body__work-process__wrapper__vertical-group__input__input {
  width: 100%;
}

.page--standard__body__skill {
  min-height: $skill-height;
  overflow: hidden;
  width: 100%;
  margin-bottom: 1rem;
  box-shadow: 0 2px 4px 0 rgba(12, 0, 51, 0.1);
  border-radius: 4px;
  border-left: 3px solid $color-blue;

  &.page--standard__body__skill--error {
    border-color: $color-salmon;
  }
}

.page--standard__body__skill__wrapper {
  display: flex;
  flex-direction: row;
  min-height: $skill-height;
  background: $color-white;
  cursor: pointer;
  border-bottom: 1px solid $color-gray-light;
  overflow: hidden;
  padding: 0 2rem;
}

.page--standard__body__skill--editing .page--standard__body__skill__wrapper {
  padding-right: 0;
}

.page--standard__body__skill__wrapper__vertical-group {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  padding: 0.5rem 0;
  flex-grow: 1;
}

.page--standard__body__skill__wrapper__vertical-group__label {
  font-size: 0.9rem;
  color: gray;
  margin-bottom: 0.25rem;
  margin-top: 0.5rem;
}

.page--standard__body__skill__wrapper__vertical-group__input__input,
.page--standard__body__skill__wrapper__vertical-group__description {
  font-size: 1.125rem;
  line-height: 1.5rem;
  overflow: hidden;
  // font-weight: 500;
  text-align: left;
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

.page--standard__body__work-process__skills__actions,
.page--standard__body__actions {
  display: flex;
  flex-direction: row;
}

.page--standard__body__actions__action {
  margin-bottom: 1.5rem;
}

.page--standard__body__work-process__skills__actions__action {
  margin-bottom: .5rem;
}

.page--standard__body__work-process__skills__actions__action,
.page--standard__body__actions__action {
  display: flex;
  justify-content: center;
  align-items: center;

  &:not(:last-child) {
    margin-right: 1rem;
  }
}

.page--standard__body__work-process__skills__actions__action__icon,
.page--standard__body__actions__action__icon {
  height: .9rem;
  margin-right: .5rem;
}

.page--standard__body__work-process__skills__actions {
  padding: 1rem .5rem;
}
</style>
