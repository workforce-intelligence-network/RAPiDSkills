<template>
  <div
    class="standard__work-process"
    :class="{
      'standard__work-process--error': workProcess.invalid,
      'standard__work-process--expanded': expanded,
      'standard__work-process--editing': editing
    }"
  >
    <Tour :id="TOUR_STEP_ID_STANDARD_WORK_PROCESS" v-if="firstInList" />
    <div class="standard__work-process__wrapper" @click="toggleWorkProcess(workProcess)">
      <div class="standard__work-process__wrapper__icon--folder">
        <img :src="ICON_FOLDER" alt="Work Process icon" v-if="expanded" />
        <img :src="ICON_FOLDER_CLOSED" alt="Work Process icon" v-if="!expanded" />
      </div>
      <div class="standard__work-process__wrapper__vertical-group">
        <div class="standard__work-process__wrapper__vertical-group__label">
          Category
        </div>
        <div class="standard__work-process__wrapper__vertical-group__title" v-if="!editing">
          {{ workProcess.title }}
        </div>
        <div class="input input--subtle standard__work-process__wrapper__vertical-group__input" @click.stop="" v-if="editing" :class="{ 'input--error': workProcess.propertyInvalid('title') }">
          <TextArea v-model="workProcess.title" class="input__input standard__work-process__wrapper__vertical-group__input__input" ref="title" @input="onInput" />
        </div>
      </div>
      <div class="standard__work-process__wrapper__info standard__work-process__wrapper__info--skills" v-if="!editing && !!workProcess.skills.length">
        <img :src="ICON_SKILL" alt="Number of skills" class="standard__work-process__wrapper__info__icon" />
        <span class="standard__work-process__wrapper__info__number">{{ workProcess.skills.length }}</span>
      </div>
      <div class="standard__work-process__wrapper__info standard__work-process__wrapper__info--hours" v-if="!editing && !!workProcess.hours">
        <img :src="ICON_HOURS" alt="Number of hours" class="standard__work-process__wrapper__info__icon" />
        <span class="standard__work-process__wrapper__info__number">{{ workProcess.hours }}</span>
      </div>
      <button class="button button--link standard__work-process__wrapper__icon--delete" v-if="editing && !workProcess.skills.length" @click.stop="deleteWorkProcess">
        <FontAwesomeIcon :icon="['fas', 'trash-alt']" class="standard__work-process__wrapper__icon--delete__icon" />
      </button>
      <div class="standard__work-process__wrapper__icon--caret">
        <FontAwesomeIcon :icon="['fas', 'caret-down']" class="standard__work-process__wrapper__icon--caret__icon" v-if="expanded" />
        <FontAwesomeIcon :icon="['fas', 'caret-right']" class="standard__work-process__wrapper__icon--caret__icon" v-if="!expanded" />
      </div>
    </div>
    <div class="standard__work-process__skills" v-if="expanded">
      <div class="standard__work-process__skills__actions" v-if="editing">
        <button role="button" class="button button--square button--alternative standard__work-process__skills__actions__action" @click="addSkill" :disabled="addNewWorkProcessSkillDisabled">
          <img :src="ICON_PLUS_BLUE" alt="New Skill plus icon" class="standard__work-process__skills__actions__action__icon" />
          <span>New Skill</span>
        </button>
      </div>
      <StandardWorkProcessSkill
        v-for="(skill, skillIndex) in workProcess.skills"
        :key="`skill-${skill.synced ? `id-${skill.id}` : skillIndex}`"
        :skillIndex="skillIndex"
        :editing="editing"
        :workProcessIndex="workProcessIndex"
        :onSkillInput="onSkillInput"
      />
    </div>
  </div>
</template>

<script lang="ts">
import _some from 'lodash/some';
import _flatten from 'lodash/flatten';
import _debounce from 'lodash/debounce';

import Vue from 'vue';

import {
  Component, Prop, Provide, Watch,
} from 'vue-property-decorator';

import Skill from '@/models/Skill';
import WorkProcess from '@/models/WorkProcess';
import OccupationStandard from '@/models/OccupationStandard';

import Tour from '@/components/Tour.vue';
import TextArea from '@/components/TextArea.vue';
import StandardWorkProcessSkill from '@/components/StandardWorkProcessSkill.vue';

import {
  TOUR_STEP_ID_STANDARD_WORK_PROCESS,
} from '@/store/tours';

import ICON_PLUS_BLUE from '@/assets/icon-plus-blue.svg';
import ICON_FOLDER from '@/assets/folder.svg';
import ICON_FOLDER_CLOSED from '@/assets/folder-closed.svg';
import ICON_SKILL from '@/assets/icon-skill.svg';
import ICON_HOURS from '@/assets/icon-hours.svg';

@Component({
  components: {
    Tour,
    TextArea,
    StandardWorkProcessSkill,
  },
})
export default class StandardWorkProcess extends Vue {
  @Prop(Number) workProcessIndex!: number

  @Prop(Boolean) editing!: boolean

  @Prop(Boolean) firstInList!: boolean

  @Provide('ICON_FOLDER') ICON_FOLDER = ICON_FOLDER

  @Provide('ICON_FOLDER_CLOSED') ICON_FOLDER_CLOSED = ICON_FOLDER_CLOSED

  @Provide('ICON_PLUS_BLUE') ICON_PLUS_BLUE = ICON_PLUS_BLUE

  @Provide('ICON_SKILL') ICON_SKILL = ICON_SKILL

  @Provide('ICON_HOURS') ICON_HOURS = ICON_HOURS

  @Provide('TOUR_STEP_ID_STANDARD_WORK_PROCESS') TOUR_STEP_ID_STANDARD_WORK_PROCESS = TOUR_STEP_ID_STANDARD_WORK_PROCESS

  expanded: boolean = false

  created() {
    this.saveWorkProcess = _debounce(this.saveWorkProcess, 500).bind(this);
    this.expanded = this.workProcessIndex === 0;
  }

  mounted() {
    this.focusInput();
  }

  focusInput() {
    this.$nextTick(() => {
      const ref: Vue | undefined = _flatten([this.$refs.title])[0];
      if (ref && !this.workProcess.synced) {
        (ref.$el as HTMLElement).focus();
      }
    });
  }

  toggleWorkProcess() {
    this.expanded = !this.expanded;
  }

  onSkillInput() {
    this.$forceUpdate();
  }

  onInput() {
    this.$forceUpdate();
    this.saveWorkProcess();
  }

  async saveWorkProcess() {
    try {
      await this.workProcess.save();
    } catch (e) {
      (Vue as any).rollbar.error(e);
    }

    this.$store.dispatch('standards/refreshSelectedStandard');
  }

  async deleteWorkProcess() {
    await this.$store.dispatch('standards/deleteWorkProcessFromSelectedStandard', this.workProcess);
  }

  async addSkill() {
    await this.$store.dispatch('standards/addNewSkillToSelectedStandard', this.workProcess);
  }

  protected get addNewWorkProcessSkillDisabled() {
    return !this.workProcess.synced || (this.workProcess.skills[0] && this.workProcess.skills[0].invalid);
  }

  protected get workProcess(): WorkProcess {
    return ((this.$store.state.standards.selectedStandard || {} as OccupationStandard).workProcesses || [])[this.workProcessIndex] || {};
  }
}
</script>

<style scoped lang="scss">
@import "@/scss/colors";
@import "@/scss/navbars";
@import "@/scss/mixins";
@import "@/scss/standards";

.standard__work-process {
  position: relative;
  min-height: $work-process-height;
  width: 100%;
  margin-bottom: 1rem;
  box-shadow: 0 2px 4px 0 rgba(12, 0, 51, 0.1);
  border-radius: 4px;
  border-left: 3px solid $color-blue;

  &.standard__work-process--error {
    border-color: $color-salmon;
  }
}

.standard__work-process:not(.standard__work-process--expanded) {
  .standard__work-process__wrapper__vertical-group__title {
    max-height: 3rem;
  }
}

.standard__work-process__wrapper {
  display: flex;
  flex-direction: row;
  align-items: center;
  min-height: $work-process-height;
  background: $color-white;
  cursor: pointer;
  border-bottom: 1px solid $color-gray-light;
  overflow: hidden;
}

.standard__work-process__wrapper__vertical-group {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  padding: 0.5rem 0;
  flex-grow: 1;
}

.standard__work-process__wrapper__vertical-group__label {
  font-size: 0.9rem;
  color: gray;
  margin-bottom: 0.25rem;
  margin-top: 0.5rem;
}

.standard__work-process__wrapper__vertical-group__input__input,
.standard__work-process__wrapper__vertical-group__title {
  font-size: 1.25rem;
  line-height: 1.5rem;
  overflow: hidden;
  font-weight: 500;
}

.standard__work-process__wrapper__icon--folder {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  width: 3.5rem;
}

.standard__work-process__wrapper__icon--caret {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  margin-left: auto;
  width: 3.5rem;
  color: $color-blue;
}

.standard__work-process__wrapper__icon--delete {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  margin-left: auto;
  width: 3.5rem;
  color: $color-salmon;
  font-size: 1.125rem;
}

.standard__work-process__skills {
  display: flex;
  flex-direction: column;
  padding: 0 0.5rem;
}

.standard__work-process__wrapper__vertical-group__title {
  text-align: left;
}

.standard__work-process__wrapper__vertical-group__input,
.standard__work-process__wrapper__vertical-group__input__input {
  width: 100%;
}

.standard__work-process__skills__actions {
  display: flex;
  flex-direction: row;
}

.standard__work-process__skills__actions__action {
  margin-bottom: .5rem;
}

.standard__work-process__skills__actions__action {
  display: flex;
  justify-content: center;
  align-items: center;

  &:not(:last-child) {
    margin-right: 1rem;
  }
}

.standard__work-process__skills__actions__action__icon {
  height: .9rem;
  margin-right: .5rem;
}

.standard__work-process__skills__actions {
  padding: 1rem .5rem;
}

.standard__work-process__wrapper__info {
  display: flex;
  align-items: center;
  color: $color-text-light;
  padding: 0 .5rem;
}

.standard__work-process__wrapper__info__icon {
  margin-right: .25rem;
}
</style>
