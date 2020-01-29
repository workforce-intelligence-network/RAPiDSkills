<template>
  <div class="modal" @click="onBackdropClick">
    <div class="modal__backdrop" />
    <div class="modal__content" v-if="component" @click.stop="" @mousedown="onMouseDownInsideContent">
      <div class="button button--link modal__content__button--close" @click="close">
        <img :src="ICON_CLOSE" alt="Close" class="modal__content__button--close__icon" />
      </div>
      <component :is="component" />
    </div>
  </div>
</template>

<script lang="tsx">
import Vue from 'vue';
import {
  Component, Prop, Provide,
} from 'vue-property-decorator';

import ICON_CLOSE from '@/assets/icon-close.svg';

@Component
export default class Modal extends Vue {
  @Prop(String) readonly component?: string

  @Provide('ICON_CLOSE') ICON_CLOSE = ICON_CLOSE

  mouseDownInsideContent: boolean = false

  onMouseDownInsideContent() {
    this.mouseDownInsideContent = true;
  }

  onBackdropClick() {
    if (this.mouseDownInsideContent) {
      this.mouseDownInsideContent = false;
      return;
    }

    this.close();
  }

  close() {
    this.$store.dispatch('modal/close');
  }
}
</script>

<style scoped lang="scss">
@import '@/scss/colors';
@import "@/scss/modal";

$modal-content-desktop-width: 50rem;

.modal {
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  flex-direction: column;
  // z-index: 3;
  opacity: 0;
  overflow: auto;
  transition: $modal-transition-time opacity ease;
  pointer-events: none;
  padding: 6rem 0;
  @media (max-width: $modal-content-desktop-width) {
    padding: 0;
  }
}

.modal--visible {
  opacity: 1;
  pointer-events: all;
}

.modal__backdrop {
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  background: $color-modal-background;
  opacity: .23;
  z-index: -1;
  pointer-events: none;
}

.modal__content {
  position: relative;
  width: $modal-content-desktop-width;
  background: $color-white;
  border-radius: 8px;
  pointer-events: all;
  border-top: 11px solid $color-blue;
  @media (max-width: $modal-content-desktop-width) {
    width: 100vw;
    border-radius: 0;
    flex-grow: 1;
  }
}

.modal__content__button--close {
  position: absolute;
  top: 0;
  right: 0;
  height: 3.5rem;
  padding: .75rem;
}

.modal__content__button--close__icon {
  height: 100%;
}
</style>
