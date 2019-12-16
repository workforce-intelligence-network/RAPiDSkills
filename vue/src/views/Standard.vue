<template>
  <div class="page--standard">
    <div class="page--standard__sidebar--left" v-if="!loading">
      <div class="page--standard__sidebar--left__logo">
        <img :src="standard.organization.logo" :alt="standard.organizationTitle" class="page--standard__sidebar--left__logo__logo" />
      </div>
      <div class="page--standard__sidebar--left__occupation-name">{{ standard.title }}</div>
      <div class="page--standard__sidebar--left__divider--stats" />
      <div class="page--standard__sidebar--left__work-process-data">
        <div class="page--standard__sidebar--left__work-process-data__stat">
          <div class="page--standard__sidebar--left__work-process-data__stat__number">{{ standard.workProcesses.length }}</div>
          <div class="page--standard__sidebar--left__work-process-data__stat__text">Work</div>
          <div class="page--standard__sidebar--left__work-process-data__stat__text">Processes</div>
        </div>
        <div class="page--standard__sidebar--left__work-process-data__stat">
          <div class="page--standard__sidebar--left__work-process-data__stat__number">{{ totalNumberOfCompetencies }}</div>
          <div class="page--standard__sidebar--left__work-process-data__stat__text">Total</div>
          <div class="page--standard__sidebar--left__work-process-data__stat__text">Competencies</div>
        </div>
        <div class="page--standard__sidebar--left__work-process-data__stat">
          <div class="page--standard__sidebar--left__work-process-data__stat__number">{{ totalNumberOfHours }}</div>
          <div class="page--standard__sidebar--left__work-process-data__stat__text">Total</div>
          <div class="page--standard__sidebar--left__work-process-data__stat__text">Hours</div>
        </div>
      </div>
    </div>
    <div class="page--standard__body">
      <Loading v-if="loading" />
      <div class="page--standard__body__work-process" v-for="workProcess in standard.workProcesses" :key="workProcess.id" :class="{ 'page--standard__body__work-process--expanded': workProcess.expanded }">
        <div class="page--standard__body__work-process__wrapper" @click="toggleWorkProcess(workProcess)">
          <div class="page--standard__body__work-process__wrapper__icon--folder">
            <img :src="ICON_FOLDER" alt="Work Process icon" v-if="workProcess.expanded" />
            <img :src="ICON_FOLDER_CLOSED" alt="Work Process icon" v-if="!workProcess.expanded" />
          </div>
          <div class="page--standard__body__work-process__wrapper__vertical-group">
            <div class="page--standard__body__work-process__wrapper__vertical-group__label">
              Work Process
            </div>
            <div class="page--standard__body__work-process__wrapper__vertical-group__title">
              {{ workProcess.title }}
            </div>
          </div>
          <div class="page--standard__body__work-process__wrapper__icon--caret">
            <FontAwesomeIcon :icon="['fas', 'caret-down']" class="page--standard__body__work-process__wrapper__icon--caret__icon" v-if="workProcess.expanded" />
            <FontAwesomeIcon :icon="['fas', 'caret-right']" class="page--standard__body__work-process__wrapper__icon--caret__icon" v-if="!workProcess.expanded" />
          </div>
        </div>
        <div class="page--standard__body__work-process__skills">
          <div class="page--standard__body__work-process__skills__skill" v-for="skill in workProcess.skills" :key="`${workProcess.id}-${skill.id}`">
            <div class="page--standard__body__work-process__skills__skill__vertical-group">
              <div class="page--standard__body__work-process__skills__skill__vertical-group__label">
                Skill Description
              </div>
              <div class="page--standard__body__work-process__skills__skill__vertical-group__description">
                {{ skill.description }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import _times from 'lodash/times';

import Vue from 'vue';

import { mapState } from 'vuex';

import LOGO_WIN from '@/assets/win.png';
import ICON_FOLDER from '@/assets/folder.svg';
import ICON_FOLDER_CLOSED from '@/assets/folder-closed.svg';

import Loading from '@/components/Loading.vue';

export default {
  name: 'standard',
  components: {
    Loading,
  },
  methods: {
    toggleWorkProcess(workProcess: any) {
      Vue.set(workProcess, 'expanded', !workProcess.expanded);
    },
  },
  data() {
    return {
      ICON_FOLDER,
      ICON_FOLDER_CLOSED,
    };
  },
  computed: {
    ...mapState({
      standard: (state: any) => Object.assign({}, state.standards.selectedStandard, {
        organization: {
          logo: LOGO_WIN,
          name: 'WIN',
        },
        occupation: {
          name: 'Mechatronics Technician',
          type: 'Hybrid',
          onet: '51-4012.00',
          cb: '1100CB',
        },
      }),
      loading: (state: any) => state.standards.selectedStandardLoading,
    }),
    totalNumberOfCompetencies() {
      return (((this as any).standard as any).skills || []).length;
    },
    totalNumberOfHours() {
      return ((this as any).standard as any).workProcesses
        .reduce((total, workProcess) => total + workProcess.hoursTotal || 0, 0);
    },
  },
};
</script>

<style scoped lang="scss">
@import "@/scss/colors";
@import "@/scss/navbars";

$sidebar-left-width: 20rem;

$work-process-height: 5rem;

.page--standard {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  min-height: 100%;
}

.page--standard__sidebar--left {
  width: $sidebar-left-width;
  background: $color-white;
  min-height: calc(100vh - #{$nav-top-height});
  height: 100%;
  padding: 1rem 1.5rem;
  box-shadow: 0 2px 4px 0 rgba(12, 0, 51, 0.1);
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
  margin-bottom: 1.5rem;
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
}

.page--standard__body__work-process {
  min-height: $work-process-height;
  &:not(.page--standard__body__work-process--expanded) {
    max-height: $work-process-height;
  }
  overflow: hidden;
  width: 100%;
  margin-bottom: 1rem;
  box-shadow: 0 2px 4px 0 rgba(12, 0, 51, 0.1);
  border-radius: 4px;
  border-left: 3px solid $color-blue;
}

.page--standard__body__work-process__wrapper {
  display: flex;
  flex-direction: row;
  // justify-content: space-between;
  height: $work-process-height;
  background: $color-white;
  cursor: pointer;
  border-bottom: 1px solid $color-gray-light;
}

.page--standard__body__work-process__wrapper__vertical-group {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
}

.page--standard__body__work-process__wrapper__vertical-group__label {
  font-size: 0.9rem;
  color: gray;
  margin-bottom: 0.25rem;
}

.page--standard__body__work-process__wrapper__vertical-group__title {
  font-size: 1.25rem;
  font-weight: 500;
}

.page--standard__body__work-process__wrapper__icon--folder {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 3.5rem;
}

.page--standard__body__work-process__wrapper__icon--caret {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-left: auto;
  width: 3.5rem;
  color: $color-blue;
}

.page--standard__body__work-process__skills {
  display: flex;
  flex-direction: column;
  padding: 0.5rem;
}

.page--standard__body__work-process__skills__skill {
  display: flex;
  flex-direction: row;
  // justify-content: space-between;
  background: $color-white;
  width: 100%;
  border: 1px solid $color-gray-light;
  &:not(:last-of-type) {
    margin-bottom: 0.5rem;
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
}

.page--standard__body__work-process__skills__skill__vertical-group__label {
  font-size: 0.9rem;
  color: gray;
  margin-bottom: 0.25rem;
}

.page--standard__body__work-process__skills__skill__vertical-group__description {
  font-size: 1rem;
}
</style>
