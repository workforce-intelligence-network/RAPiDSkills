<template>
  <div class="page page--saved">
    <div class="page__header">
      <div class="page__header__title">
        My Work Schedules
      </div>
      <div class="page__header__subtitle">
        My Work Schedules stores all of your customized versions of work schedules. When you choose to use a work schedule, it'll show up in this list.
      </div>
    </div>
    <div class="page--saved__cards" v-if="standards.length">
      <Standard v-for="standard in standards" :standard="standard" :key="standard.id" :label="standard.occupationKind" saved />
    </div>
    <div class="page--saved__state--loading" v-if="showLoadingState">
      <Loading />
    </div>
    <div class="page--saved__state--empty" v-if="showEmptyState">
      No saved work schedules found.
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import {
  Component,
} from 'vue-property-decorator';

import Standard from '@/components/Standard.vue';
import Loading from '@/components/Loading.vue';

@Component({
  components: {
    Standard,
    Loading,
  },
})
export default class SavedStandards extends Vue {
  protected get showEmptyState() {
    return !this.showLoadingState && !this.standards.length;
  }

  protected get showLoadingState() {
    return this.$store.state.user.savedStandardsLoading;
  }

  protected get standards() {
    return this.$store.state.user.savedStandards || [];
  }
}
</script>

<style scoped lang="scss">
@import "@/scss/page";
@import "@/scss/mixins";
@import "@/scss/standards";
@import "@/scss/navbars";

.page--saved__cards {
  @extend .standard-cards;
}

.page--saved__state--empty {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 5rem;
}
</style>
