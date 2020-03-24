<template>
  <div class="tour-wrapper">
    <div class="tour" :class="{ [`tour--position-${position}`]: true, 'tour--shown': tourStepVisible }" @click.stop.prevent="() => {}" ref="tour" :style="tourTranslationStyle">
      <div class="tour__triangle" :style="tourTriangleTranslationStyle" />
      <div class="tour__title" v-html="title" />
      <div class="tour__content" v-html="content" />
      <div class="tour__actions">
        <button class="button button--link tour__actions__action tour__actions__action--skip" v-html="skipText" @click.stop.prevent="skip" />
        <button class="button button--square tour__actions__action tour__actions__action--close" @click.stop.prevent="next">
          <span v-html="closeText" class="tour__actions__action--close__text" />
          <FontAwesomeIcon :icon="['fas', 'caret-right']" />
        </button>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import _debounce from 'lodash/debounce';

import Vue from 'vue';
import {
  Component, Prop,
} from 'vue-property-decorator';

const LEFT_BOUND = 80;

@Component
export default class tour extends Vue {
  @Prop(String) readonly id!: string

  xTranslation: number = 0

  created() {
    this.onMountOrUpdate = _debounce(this.onMountOrUpdate, 500, { leading: true }).bind(this);
  }

  mounted() {
    this.$nextTick(this.onMountOrUpdate);
  }

  updated() {
    this.$nextTick(this.onMountOrUpdate);
  }

  onMountOrUpdate() {
    if (!this.tourStepVisible || !this.$refs.tour) {
      return;
    }

    this.adjustXPositioning();
    this.scrollIntoView();
  }

  adjustXPositioning() {
    if (this.topOrBottom) {
      return;
    }

    const rect = (this.$refs.tour as HTMLElement).getBoundingClientRect();
    if (rect.left < LEFT_BOUND) {
      this.xTranslation = LEFT_BOUND - rect.left;
    }

    const RIGHT_BOUND = document.body.clientWidth - 16;
    if (rect.right > RIGHT_BOUND) {
      this.xTranslation = RIGHT_BOUND - rect.right;
    }
  }

  scrollIntoView() {
    this.$scrollTo((this.$refs.tour as HTMLElement), 500, {
      container: '#body',
      offset: -20,
    });
  }

  async next() {
    await this.$store.dispatch('tours/nextTourStep', this.id);
  }

  async skip() {
    await this.$store.dispatch('tours/skipTour', this.configuration.tourId);
  }

  protected get topOrBottom() {
    return this.position === 'top' || this.position === 'bottom';
  }

  protected get tourTranslationStyle() {
    if (this.topOrBottom) {
      return '';
    }
    return `transform: translateX(${this.xTranslation}px);`;
  }

  protected get tourTriangleTranslationStyle() {
    if (this.topOrBottom) {
      return '';
    }
    return `transform: translateX(${-this.xTranslation}px);`;
  }

  protected get configuration() {
    return this.$store.getters['tours/tourStepConfiguration'](this.id) || {};
  }

  protected get title() {
    return this.configuration.title || 'Tip:';
  }

  protected get content() {
    return this.configuration.content || 'No content';
  }

  protected get skipText() {
    return this.configuration.skipText || 'Skip tips';
  }

  protected get closeText() {
    return this.configuration.closeText || 'Got it';
  }

  protected get position() {
    return this.configuration.position || 'left-top';
  }

  protected get tourStepVisible() {
    return this.$store.getters['tours/tourStepVisible'](this.id);
  }
}
</script>

<style scoped lang="scss">
@import '@/scss/colors';

$triangle-size: 20px;

.tour-wrapper {
  position: absolute;
  top: 0;
  bottom: 0;
  right: 0;
  left: 0;
  pointer-events: none;
}

.tour {
  position: absolute;
  background: $color-white;
  box-shadow: 0px 2px 36px $color-tip-box-shadow;
  width: 20rem;
  max-width: calc(100vw - 6rem);
  z-index: 1;
  padding: 1rem 2rem;
  text-align: left;
  border-radius: 4px;
  text-decoration: none;
  text-transform: none;
  letter-spacing: initial;
  opacity: 0;
  transition: .25s opacity ease;
  pointer-events: none;

  &,
  &:hover {
    cursor: default;
  }
}

.tour--shown {
  opacity: 1;
  pointer-events: all;
}

.tour--position-left-top {
  left: calc(100% + .5rem);
  top: -10px;

  .tour__triangle {
    left: -10px;
    top: 10px;

    &:before {
      border-right: #{$triangle-size + 3px} solid $color-white;
      border-bottom: $triangle-size solid transparent;
      border-top: $triangle-size solid transparent;
    }
  }
}

.tour--position-right-top {
  right: calc(100% + .5rem);
  top: -10px;

  .tour__triangle {
    right: -10px;
    top: 10px;

    &:before {
      border-left: #{$triangle-size + 3px} solid $color-white;
      border-bottom: $triangle-size solid transparent;
      border-top: $triangle-size solid transparent;
    }
  }
}

.tour--position-top-left {
  left: -10px;
  top: calc(100% + 10px);

  .tour__triangle {
    left: 10px;
    top: -10px;

    &:before {
      border-bottom: #{$triangle-size + 3px} solid $color-white;
      border-right: $triangle-size solid transparent;
      border-left: $triangle-size solid transparent;
    }
  }
}

.tour--position-top-right {
  right: -10px;
  top: calc(100% + 10px);

  .tour__triangle {
    right: 10px;
    top: -10px;

    &:before {
      border-bottom: #{$triangle-size + 3px} solid $color-white;
      border-right: $triangle-size solid transparent;
      border-left: $triangle-size solid transparent;
    }
  }
}

.tour--position-top {
  left: 50%;
  transform: translateX(-50%);
  top: calc(100% + 10px);

  .tour__triangle {
    left: 50%;
    transform: translateX(-50%);
    top: -10px;

    &:before {
      border-bottom: #{$triangle-size + 3px} solid $color-white;
      border-right: $triangle-size solid transparent;
      border-left: $triangle-size solid transparent;
    }
  }
}

.tour--position-bottom {
  left: 50%;
  transform: translateX(-50%);
  bottom: calc(100% + 10px);

  .tour__triangle {
    left: 50%;
    transform: translateX(-50%);
    bottom: -10px;

    &:before {
      border-top: #{$triangle-size + 3px} solid $color-white;
      border-right: $triangle-size solid transparent;
      border-left: $triangle-size solid transparent;
    }
  }
}

.tour--position-bottom-left {
  left: -10px;
  bottom: calc(100% + 10px);

  .tour__triangle {
    bottom: -10px;
    left: 10px;

    &:before {
      border-top: #{$triangle-size + 3px} solid $color-white;
      border-right: $triangle-size solid transparent;
      border-left: $triangle-size solid transparent;
    }
  }
}

.tour--position-bottom-right {
  right: -10px;
  bottom: calc(100% + 10px);

  .tour__triangle {
    bottom: -10px;
    right: 10px;

    &:before {
      border-top: #{$triangle-size + 3px} solid $color-white;
      border-right: $triangle-size solid transparent;
      border-left: $triangle-size solid transparent;
    }
  }
}

.tour__actions__action--close__text {
  margin-right: .75rem;
}

.tour__title {
  font-size: 1.125rem;
  font-weight: 600;
  margin-bottom: .5rem;
  color: $color-black;
  line-height: 1.125rem;
}

.tour__content {
  font-size: 1.125rem;
  line-height: 1.625rem;
  color: $color-text-light;
  margin-bottom: 1.5rem;
  font-weight: 400;
  white-space: normal;
}

.tour__actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.tour__triangle {
  position: absolute;

  &:before {
    content: '';
    display: block;
    width: 0;
    height: 0;
  }
}
</style>
