<template>
  <div class="page--duplicate">
    <div class="page--duplicate__loading" v-if="loading">
      <Loading />
    </div>
    <div class="page--duplicate__body" v-if="!loading">
      <img class="page--duplicate__body__icon" :src="ICON_EDIT_CUSTOMIZE" alt="Edit icon" />
      <div class="page--duplicate__body__text page--duplicate__body__text--below-icon" v-html="textBelowIcon" />
      <div class="page--duplicate__body__text page--duplicate__body__text--question" v-html="textQuestion" />
      <div class="page--duplicate__body__text page--duplicate__body__text--explanation" v-html="textExplanation" />
      <div class="input page--duplicate__body__input" :class="{ 'input--error': validating && standard.propertyInvalid('title') }">
        <input class="input__input page--duplicate__body__input__input" :placeholder="textStandardNamePlaceholder" type="text" name="title" v-model="standard.title" ref="standardTitleInput" />
      </div>
      <button class="button button--square button--tall page--duplicate__body__button" role="button" @click="createDuplicateStandardAndEdit" v-html="textButtonDuplicate" />
    </div>
  </div>
</template>

<script lang="tsx">
import Vue from 'vue';
import { Component, Prop, Provide } from 'vue-property-decorator';

import Loading from '@/components/Loading.vue';

import ICON_EDIT_CUSTOMIZE from '@/assets/edit-customize.svg';
import OccupationStandard from '../models/OccupationStandard';

@Component({
  components: {
    Loading,
  },
})
export default class Duplicate extends Vue {
  @Provide('ICON_EDIT_CUSTOMIZE') ICON_EDIT_CUSTOMIZE = ICON_EDIT_CUSTOMIZE

  textBelowIcon: string = 'Woo Hoo! You\'re about to get busy.'

  textQuestion: string = 'What would you like to name your new standard?'

  textExplanation: string = 'A copy of the original unedited version of this standard will be saved to "Saved Standards" along with this new standard draft.'

  textStandardNamePlaceholder: string = 'Example: Hotel Bar Back for Acme Hotel Enterprises'

  textButtonDuplicate: string = 'Edit my Standard'

  validating: boolean = false

  protected get standard(): OccupationStandard {
    return this.$store.state.standards.selectedStandard || {};
  }

  protected get loading() {
    return this.$store.state.standards.selectedStandardLoading;
  }

  focusInput() {
    if (this.$refs.standardTitleInput) {
      (this.$refs.standardTitleInput as HTMLElement).focus();
    }
  }

  mounted() {
    this.focusInput();
  }

  updated() {
    this.focusInput();
  }

  beforeDestroy() {
    this.$router.push({ name: 'standards' });
  }

  createDuplicateStandardAndEdit() {
    this.validating = true;

    if (this.standard.propertyInvalid('title')) {
      return;
    }

    this.validating = false;

    this.$store.dispatch('standards/duplicateSelectedStandard');
  }
}
</script>

<style lang="scss" scoped>
@import '@/scss/colors';
@import '@/scss/mixins';

.page--duplicate {
  padding: 2rem 1rem;
  @include breakpoint--above-sm {
    padding: 2rem 5rem;
  }
}

.page--duplicate__body__icon {
  height: 4rem;
  margin-bottom: 1.5rem;
}

.page--duplicate__body__text {
  padding: 0;
  @include breakpoint--above-sm {
    padding: 0 2.5rem;
  }
}

.page--duplicate__body__text--below-icon {
  color: $color-blue;
  font-weight: 500;
  font-size: 1.125rem;
  margin-bottom: 2rem;
}

.page--duplicate__body__text--question {
  font-size: 2.125rem;
  font-weight: 500;
  margin-bottom: 1.25rem;
}

.page--duplicate__body__text--explanation {
  color: $color-text-light;
  line-height: 2rem;
  margin-bottom: 2rem;
  font-size: 1.125rem;
}

.page--duplicate__body__input {
  margin-bottom: 2.5rem;
}

.page--duplicate__body__input__input {
  width: 100%;
  height: 4.5rem;
}

.page--duplicate__body__button {
  margin-bottom: 1rem;
}
</style>
