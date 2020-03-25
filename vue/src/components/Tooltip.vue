<template>
  <div class="tooltip">
    <div class="tooltip__bubble">
      <div class="tooltip__bubble__text" v-html="tip" />
      <div class="tooltip__bubble__triangle" />
    </div>
    <slot />
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import {
  Component, Prop,
} from 'vue-property-decorator';

@Component
export default class Tooltip extends Vue {
  @Prop(String) readonly tip!: string
}
</script>

<style scoped lang="scss">
@import '@/scss/colors';

.tooltip {
  position: relative;
  &:hover .tooltip__bubble {
    display: block;
  }
}

.tooltip__bubble {
  display: none;
  position: absolute;
  bottom: calc(100% + 3px);
  left: 50%;
  transform: translateX(-50%);
  background: $color-black;
  color: $color-white;
  font-size: .85rem;
  font-weight: 500;
  padding: .35rem .75rem;
  border-radius: 4px;
}

$triangle-size: 8px;
.tooltip__bubble__triangle {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);

  &:before {
    content: '';
    display: block;
    width: 0;
    height: 0;

    border-right: $triangle-size solid transparent;
    border-left: $triangle-size solid transparent;

    border-top: #{$triangle-size + 3px} solid $color-black;
  }
}
</style>
