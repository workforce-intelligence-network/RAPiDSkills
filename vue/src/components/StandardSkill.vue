<template>
  <div
    class="standard__skill"
    :class="{
      'standard__skill--error': skill.invalid,
      'standard__skill--editing': editing
    }"
  >
    <div class="standard__skill__wrapper">
      <div class="standard__skill__wrapper__vertical-group">
        <div class="standard__skill__wrapper__vertical-group__label">
          Skill
        </div>
        <div class="standard__skill__wrapper__vertical-group__description" v-if="!editing">
          {{ skill.description }}
        </div>
        <div class="input input--subtle standard__skill__wrapper__vertical-group__input" :class="{ 'input--error': skill.invalid }" v-if="editing">
          <TextArea class="input__input standard__skill__wrapper__vertical-group__input__input" v-model="skill.description" ref="description" @input="onInput" />
        </div>
      </div>
      <button class="button button--link standard__skill__wrapper__icon--delete" v-if="editing" @click.stop="deleteSkill">
        <FontAwesomeIcon :icon="['fas', 'trash-alt']" class="standard__skill__wrapper__icon--delete__icon" />
      </button>
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

import TextArea from '@/components/TextArea.vue';

@Component({
  components: {
    TextArea,
  },
})
export default class StandardSkill extends Vue {
  @Prop(Number) skillIndex!: number

  @Prop(Boolean) editing!: boolean

  @Prop(Function) onSkillInput!: Function

  onInput() {
    this.onSkillInput();
    this.$forceUpdate();
    this.saveSkill();
  }

  async saveSkill() {
    try {
      await this.skill.save();
    } catch (e) {
      console.log('Failed to save standard skill', e);
    }

    this.$store.dispatch('standards/refreshSelectedStandard');
  }

  async deleteSkill() {
    await this.$store.dispatch('standards/deleteSkillFromSelectedStandard', {
      skill: this.skill,
    });
  }

  created() {
    (this as any).saveSkill = _debounce((this as any).saveSkill, 500).bind(this);
  }

  focusInput() {
    this.$nextTick(() => {
      const ref: Vue | undefined = _flatten([this.$refs.description])[0];
      if (ref && !this.skill.synced) {
        (ref.$el as HTMLElement).focus();
      }
    });
  }

  mounted() {
    this.focusInput();
  }

  protected get skill(): Skill {
    return ((this.$store.state.standards.selectedStandard || {} as OccupationStandard).skills || [])[this.skillIndex];
  }
}
</script>

<style scoped lang="scss">
@import "@/scss/colors";
@import "@/scss/navbars";
@import "@/scss/mixins";
@import "@/scss/standards";

.standard__skill__wrapper__icon--delete {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  margin-left: auto;
  width: 3.5rem;
  color: $color-salmon;
  font-size: 1.125rem;
}

.standard__skill__wrapper__vertical-group__input__input,
.standard__skill__wrapper__vertical-group__input {
  width: 100%;
}

.standard__skill {
  min-height: $skill-height;
  overflow: hidden;
  width: 100%;
  margin-bottom: 1rem;
  box-shadow: 0 2px 4px 0 rgba(12, 0, 51, 0.1);
  border-radius: 4px;
  border-left: 3px solid $color-blue;

  &.standard__skill--error {
    border-color: $color-salmon;
  }
}

.standard__skill__wrapper {
  display: flex;
  flex-direction: row;
  min-height: $skill-height;
  background: $color-white;
  cursor: pointer;
  border-bottom: 1px solid $color-gray-light;
  overflow: hidden;
  padding: 0 2rem;
}

.standard__skill--editing .standard__skill__wrapper {
  padding-right: 0;
}

.standard__skill__wrapper__vertical-group {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  padding: 0.5rem 0;
  flex-grow: 1;
}

.standard__skill__wrapper__vertical-group__label {
  font-size: 0.9rem;
  color: gray;
  margin-bottom: 0.25rem;
  margin-top: 0.5rem;
}

.standard__skill__wrapper__vertical-group__input__input,
.standard__skill__wrapper__vertical-group__description {
  font-size: 1.125rem;
  line-height: 1.5rem;
  overflow: hidden;
  // font-weight: 500;
  text-align: left;
}

</style>
