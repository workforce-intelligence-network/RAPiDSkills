<template>
  <div class="page page--dashboard">
    <div class="page__header">
      <div class="page__header__title">
        Home
      </div>
      <div class="page__header__subtitle">
        Search for work schedules that suit your organization's needs. From there, you can make a copy to customize or save it to revisit later.
      </div>
    </div>
    <div class="page--dashboard__cards" v-if="!showLoadingState && !showEmptyState">
      <div v-for="(standard, standardIndex) in standards" :key="standard.id">
        <Standard
          :standard="standard"
          :label="standard.occupationKind"
          :firstInList="standardIndex === 0"
        />
      </div>
    </div>
    <button v-if="showLoadMoreButton" class="page--dashboard__button--load-more button button--link" @click="loadMoreStandards">
      Load more work schedules
    </button>
    <div class="page--dashboard__state--loading" v-if="showLoadingState || showLoadingMoreState">
      <Loading />
    </div>
    <div class="page--dashboard__state--empty" v-if="showEmptyState && !showLoadingState">
      <div class="page--dashboard__state--empty__description">
        <span>No work schedules found </span>
        <span v-if="selectedOccupation">for occupation:</span>
        <div v-if="selectedOccupation" class="page--dashboard__state--empty__description__occupation">{{ selectedOccupation.title }}</div>
      </div>
      <div class="page--dashboard__state--empty__action">
        Please try searching for a different occupation
      </div>
      <div class="page--dashboard__state--empty__button button button--link" @click="clearSelectedOccupation" v-if="selectedOccupation">
        Clear selected occupation
      </div>
    </div>
    <router-view />
  </div>
</template>

<script lang="ts">
import _times from 'lodash/times';

import { mapGetters, mapState } from 'vuex';

import Standard from '@/components/Standard.vue';
import Loading from '@/components/Loading.vue';

export default {
  name: 'dashboard',
  components: {
    Standard,
    Loading,
  },
  methods: {
    clearSelectedOccupation() {
      (this as any).$store.dispatch('occupations/setSelectedOccupation');
    },
    loadMoreStandards() {
      (this as any).$store.dispatch('standards/fetchStandards');
    },
  },
  computed: {
    ...mapGetters({
      showEmptyState: 'standards/standardsListEmptyAndNotLoading',
    }),
    ...mapState({
      selectedOccupation: (state: any) => state.occupations.selectedOccupation,
      showLoadingState: (state: any) => state.standards.loading && state.standards.page <= 1,
      showLoadingMoreState: (state: any) => state.standards.loading && state.standards.page > 1,
      showLoadMoreButton: (state: any) => !state.standards.loading && state.standards.moreAvailable,
      standards: (state: any) => state.standards.list,
    }),
  },
};
</script>

<style scoped lang="scss">
@import "@/scss/page";
@import "@/scss/mixins";
@import "@/scss/standards";
@import "@/scss/navbars";

.page--dashboard__cards {
  @extend .standard-cards;
}

.page--dashboard__state--empty__description {
  font-weight: 600;
  font-size: 1.25rem;
  padding: 2rem 0;
}

.page--dashboard__state--empty__action {
  margin-bottom: 1rem;
}

.page--dashboard__state--empty__button {
  padding: 1rem;
  margin-bottom: 2rem;
}

.page--dashboard__state--empty__description__occupation {
  font-size: 1.5rem;
  padding-top: .5rem;
}

.page--dashboard__button--load-more {
  display: flex;
  flex-grow: 1;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 8em;
  font-size: 1.125rem;
}

.page--dashboard__state--loading {
  display: flex;
  flex-grow: 1;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 8em;
}
</style>
