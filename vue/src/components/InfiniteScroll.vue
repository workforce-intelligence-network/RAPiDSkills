<template>
  <div class="infinite-scroll" @scroll="onScroll">
    <slot />
  </div>
</template>

<script lang="ts">
import Vue from 'vue';

import {
  Component, Prop,
} from 'vue-property-decorator';

@Component
export default class StandardSkill extends Vue {
  @Prop(Function) bottomReached!: Function

  @Prop(Boolean) loading!: boolean

  onScroll() {
    if (this.loading) {
      // return;
    }

    // if (this.$el.scrollTop + window.innerHeight === this.$el.offsetHeight) {
    // this.bottomReached();
    // }
  }
}
</script>

<style scoped lang="scss">
.infinite-scroll {
  height: 100%;
  overflow: auto;
}
</style>
