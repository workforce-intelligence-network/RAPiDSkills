<template>
  <div class="modal--welcome">
    <div class="modal--welcome__title">
      Welcome!
    </div>
    <div class="modal--welcome__explanation">
      By joining, you have agreed to the following:
    </div>
    <div class="modal--welcome__scrollable">
      <Terms />
    </div>
    <div class="modal--welcome__scrollable">
      <Privacy />
    </div>
    <button class="button modal--welcome__start" @click="close">
      Let's get started!
    </button>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';

import {
  Component,
} from 'vue-property-decorator';

import Terms from '@/views/Terms.vue';
import Privacy from '@/views/Privacy.vue';


@Component({
  components: {
    Terms,
    Privacy,
  },
})
export default class Welcome extends Vue {
  close() {
    this.$store.dispatch('modal/close');
  }
}
</script>

<style scoped lang="scss">
@import "@/scss/colors";

.modal--welcome {
  max-width: 50rem;
  margin: 0 auto;
  padding-bottom: 3rem;
}

.modal--welcome__title {
  color: $color-black;
  font-weight: 600;
  font-size: 2rem;
  margin: 2rem 0;
}

.modal--welcome__explanation {
  font-size: 1.125rem;
}

.modal--welcome__scrollable {
  max-height: 15rem;
  overflow: auto;
  padding: 0 2rem;
  border-radius: 4px;
  border: 1px solid $color-gray-border;
  margin: 2rem;
  background: $color-body-background;
}

.modal--welcome__start {
  margin-top: 2rem;
}
</style>
