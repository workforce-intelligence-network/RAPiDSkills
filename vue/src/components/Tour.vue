<template>
  <div class="tour-wrapper">
    <div class="tour">
      <div class="tour__triangle" />
      <div class="tour__title" v-html="title" />
      <div class="tour__content" v-html="content" />
      <div class="tour__actions">
        <button class="button button--link tour__actions__action tour__actions__skip" v-html="skipText" @click.stop.prevent="skip" />
        <button class="button button--square tour__actions__action tour__actions__close" @click.stop.prevent="close">
          <span v-html="closeText" class="tour__actions__close__text" />
          <FontAwesomeIcon :icon="['fas', 'caret-right']" />
        </button>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import {
  Component, Prop,
} from 'vue-property-decorator';

@Component
export default class tour extends Vue {
  @Prop({ default: 'Tip:' }) readonly title?: string

  @Prop(String) readonly content!: string

  @Prop({ default: 'Skip tips' }) readonly skipText?: string

  @Prop(Function) readonly skip!: Function

  @Prop({ default: 'Got it' }) readonly closeText?: string

  @Prop(Function) readonly close!: Function

  @Prop({ default: 'left' }) readonly position?: string
}
</script>

<style scoped lang="scss">
@import '@/scss/colors';

.tour-wrapper {
  position: relative;
  pointer-events: none;
}

.tour {
  pointer-events: none;
  position: absolute;
  left: calc(100% + .5rem);
  top: -10px;
  background: $color-white;
  box-shadow: 0px 2px 36px $color-tip-box-shadow;
  width: 20rem;
  z-index: 1;
  padding: 1rem 2rem;
  text-align: left;
  border-radius: 4px;
  text-decoration: none;
  text-transform: none;
  letter-spacing: initial;
}

.tour__actions__close__text {
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

.tour__actions__action {
  pointer-events: all;
}

// .tour__actions__skip {
// }

$triangle-size: 20px;
.tour__triangle {
  position: absolute;
  left: -10px;
  top: 10px;

  &:before {
    content: '';
    display: block;
    width: 0;
    height: 0;

    border-right: #{$triangle-size + 3px} solid $color-white;
    border-bottom: $triangle-size solid transparent;
    border-top: $triangle-size solid transparent;
  }
}
</style>
