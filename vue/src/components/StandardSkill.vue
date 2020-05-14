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
          <div class="search__dropdown" v-if="showList">
            <div class="search__dropdown__empty" v-if="!listLoading && !list.length">
              No occupations found.
            </div>
            <div class="search__dropdown__loading" v-if="listLoading">
              <Loading />
            </div>
            <div class="search__dropdown__list" v-if="!listLoading">
              <a class="search__dropdown__list__item" v-for="item in list" :key="item.id" @click.stop.prevent="onSkillSelected(item)" href="javascript:void(0);">
                {{ item.description }}
              </a>
            </div>
          </div>
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
import Loading from '@/components/Loading.vue';

@Component({
  components: {
    TextArea,
    Loading,
  },
})
export default class StandardSkill extends Vue {
  @Prop(Number) skillIndex!: number

  @Prop(Boolean) editing!: boolean

  @Prop(Function) onSkillInput!: Function

  searchForSkills() {
    this.$store.dispatch('skills/searchForSkills', this.skill.description);
  }

  async onSkillSelected(skill: Skill) {
    this.$store.dispatch('skills/hideSkillsSearch');
    await this.$store.dispatch('standards/deleteSkillFromSelectedStandard', {
      skill: this.skill,
      replacement: skill,
    });
  }

  onInput() {
    this.searchForSkills();
    this.onSkillInput();
    this.$forceUpdate();
    this.saveSkill();
  }

  async saveSkill() {
    try {
      await this.skill.save();
    } catch (e) {
      (Vue as any).rollbar.error(e);
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

  protected get showList(): boolean {
    return this.$store.getters['skills/showSkillsSearchList'];
  }

  protected get listLoading(): boolean {
    return this.$store.state.skills.loading;
  }

  protected get list(): Skill[] {
    return this.$store.state.skills.list || [] as Skill[];
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

.search__dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  min-width: 100%;
  min-height: 5rem;
  max-height: 20rem;
  background: $color-white;
  overflow: auto;
  border: 1px solid $color-gray-border;
  box-shadow: 0 10px 20px 0 transparentize($color-link-blue, 0.9);
}

.search__dropdown__list__item {
  display: block;
  color: $color-black;
  cursor: pointer;
  border-bottom: 1px solid $color-gray-border;

  &:hover {
    background: darken($color: $color-white, $amount: 10);
  }
}

.search__dropdown__empty,
.search__dropdown__loading {
  line-height: 5rem;
}

</style>
