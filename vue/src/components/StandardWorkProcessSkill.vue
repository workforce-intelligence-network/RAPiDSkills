<template>
  <div
    class="standard__work-process__skill"
    :class="{
      'standard__work-process__skill--error': skill.invalid || errors.length,
      'standard__work-process__skill--editing': editing,
      'standard__work-process__skill--loading': skill.loading
    }"
  >
    <div class="standard__work-process__skill__vertical-group">
      <div class="standard__work-process__skill__vertical-group__label">
        Skill
      </div>
      <div class="standard__work-process__skill__vertical-group__description" v-if="!editing">
        {{ skill.description }}
      </div>
      <div class="input input--subtle standard__work-process__skill__vertical-group__input" :class="{ 'input--error': skill.invalid }" v-if="editing">
        <TextArea class="input__input standard__work-process__skill__vertical-group__input__input" v-model="skill.description" ref="description" @input="onInput" />
      </div>
    </div>
    <!-- <button class="button button--link standard__work-process__skill__icon standard__work-process__skill__icon--save" v-if="editing" @click.stop="">
      <FontAwesomeIcon :icon="['fas', 'save']" class="standard__work-process__skill__icon__icon" />
    </button> -->
    <button class="button button--link standard__work-process__skill__icon standard__work-process__skill__icon--edit" v-if="editing" @click.stop="focusInputManually">
      <FontAwesomeIcon :icon="['fas', 'pencil-alt']" class="standard__work-process__skill__icon__icon" />
    </button>
    <button class="button button--link standard__work-process__skill__icon standard__work-process__skill__icon--delete" v-if="editing" @click.stop="deleteSkill">
      <FontAwesomeIcon :icon="['fas', 'trash-alt']" class="standard__work-process__skill__icon__icon" />
    </button>
  </div>
</template>

<script lang="ts">
import _some from 'lodash/some';
import _flatten from 'lodash/flatten';

import Vue from 'vue';

import {
  Component, Prop, Provide,
} from 'vue-property-decorator';

import Skill from '@/models/Skill';
import WorkProcess from '@/models/WorkProcess';
import OccupationStandard from '@/models/OccupationStandard';

import TextArea from '@/components/TextArea.vue';
import StandardSkill from '@/components/StandardSkill.vue';

@Component({
  components: {
    TextArea,
  },
})
export default class StandardWorkProcessSkill extends StandardSkill {
  @Prop(Number) workProcessIndex!: number

  async deleteSkill() {
    await this.$store.dispatch('standards/deleteSkillFromSelectedStandard', {
      skill: this.skill,
      workProcess: this.workProcess,
    });
  }

  protected get workProcess(): WorkProcess {
    return ((this.$store.state.standards.selectedStandard || {} as OccupationStandard).workProcesses || [])[this.workProcessIndex] || {};
  }

  protected get skill(): Skill {
    return (this.workProcess.skills || [])[this.skillIndex] || {};
  }
}
</script>

<style scoped lang="scss">
@import "@/scss/colors";
@import "@/scss/navbars";
@import "@/scss/mixins";
@import "@/scss/standards";

.standard__work-process__skill.standard__work-process__skill--editing {
  padding-right: 0;
}

.standard__work-process__skill__icon {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  margin-left: auto;
  width: 3.5rem;
  font-size: 1.125rem;
}

.standard__work-process__skill__icon--delete {
  color: $color-salmon;
  &:hover {
    color: darken($color-salmon, 40%);
  }
}

.standard__work-process__skill {
  display: flex;
  flex-direction: row;
  align-items: stretch;
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
  border-left: 3px solid $color-blue;

  &.standard__work-process__skill--loading {
    border-left-color: $color-text-light;
  }

  &.standard__work-process__skill--error {
    border-left-color: $color-salmon;
  }
}

.standard__work-process__skill__vertical-group {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  padding: 1rem 0;
  align-items: stretch;
  text-align: left;
  flex-grow: 1;
}

.standard__work-process__skill__vertical-group__input__input,
.standard__work-process__skill__vertical-group__input {
  width: 100%;
}

.standard__work-process__skill__vertical-group__label {
  font-size: 0.9rem;
  color: gray;
  margin-bottom: 0.25rem;
}

.standard__work-process__skill__vertical-group__description {
  text-align: left;
}

.standard__work-process__skill__vertical-group__description {
  font-size: 1rem;
}
</style>
