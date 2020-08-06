<template>
  <div class="sidebar-section--faq">
    <div class="sidebar-section--faq__icon-rectangle" />
    <img class="sidebar-section--faq__icon" :src="ICON_FAQ_SIDEBAR" alt="FAQ" />
    <div class="sidebar-section--faq__title">
      Need some help finding your way around?
    </div>
    <div class="sidebar-section--faq__divider" />
    <div class="sidebar-section--faq__contact">
      Try these resources or email us at <a href="mailto:info@rapidskillsgenerator.org">info@rapidskillsgenerator.org</a>
    </div>
    <button class="sidebar-section--faq__button button button--alternative" v-if="tourId" @click="resetTour">
      Show me around
    </button>
    <a class="sidebar-section--faq__button button button--alternative" target="_blank" href="https://rapidskillsgenerator.zendesk.com/hc/en-us">
      Help
    </a>
    <div class="sidebar-section--faq__button">
      <a class="button button--alternative" target="_blank" href="https://rapidskillsgenerator.zendesk.com/hc/en-us/sections/360009797231-Work-process-schedules-explained">
        How to
      </a>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import {
  Component, Provide,
} from 'vue-property-decorator';

import ICON_FAQ_SIDEBAR from '@/assets/icon-faq-sidebar.svg';

@Component
export default class SidebarSectionFAQ extends Vue {
  @Provide('ICON_FAQ_SIDEBAR') ICON_FAQ_SIDEBAR = ICON_FAQ_SIDEBAR

  resetTour() {
    this.$store.dispatch('tours/resetTour', this.tourId);
    this.$store.dispatch('tours/continueTour', this.tourId);
  }

  protected get tourId() {
    return this.$route.meta.tourId;
  }
}
</script>

<style scoped lang="scss">
@import '@/scss/colors';

.sidebar-section--faq {
  display: flex;
  flex-direction: column;
  position: relative;
  padding: 2rem 1rem;
  padding-top: 1rem;
}

.sidebar-section--faq__icon-rectangle {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 8rem;
  background: transparentize($color-blue, .95);
}

.sidebar-section--faq__icon {
  margin-bottom: 1rem;
}

.sidebar-section--faq__title {
  font-size: 1.25rem;
  font-weight: 500;
}

.sidebar-section--faq__divider {
  margin: 1.25rem auto;
  background: $color-blue;
  height: 3px;
  width: 3rem;
}

.sidebar-section--faq__contact {
  font-size: 1rem;
  color: $color-text-light;
  margin-bottom: 2rem;
}

.sidebar-section--faq__button {
  display: block;
  width: auto;
  flex-grow: 0;
  margin: 0 auto;

  &:not(:last-child) {
    margin-bottom: 1rem;
  }
}
</style>
