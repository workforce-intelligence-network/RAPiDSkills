<template>
  <div class="page page--dashboard">
    <div class="page--dashboard__cards" v-if="!showLoadingState && !showEmptyState">
      <Standard v-for="standard in standards" :standard="standard" :key="standard.id" label="Standard" />
    </div>
    <button v-if="showLoadMoreButton" class="page--dashboard__button--load-more button button--link" @click="loadMoreStandards">
      Load more standards
    </button>
    <div class="page--dashboard__state--loading" v-if="showLoadingState || showLoadingMoreState">
      <Loading />
    </div>
    <div class="page--dashboard__state--empty" v-if="showEmptyState && !showLoadingState">
      <div class="page--dashboard__state--empty__description">
        <span>No standards found </span>
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

$card-column-gap: 2rem;
$card-column-padding: 2rem;

.page--dashboard__cards {
  display: grid;
  flex-direction: row;
  flex-wrap: wrap;
  justify-content: center;
  row-gap: 2rem;
  column-gap: $card-column-gap;
  grid-template-columns: auto auto auto auto;

  @for $i from 2 through 12 {
    @media (max-width: ($standard-width * ($i + 1) + $card-column-gap * $i + $nav-left-width + $card-column-padding)) and (min-width: ($standard-width * $i + $card-column-gap * ($i - 1) + $nav-left-width + $card-column-padding)) {
      grid-template-columns: repeat($i, auto);
    }
  }

  @media (max-width: ($standard-width * 2 + $card-column-gap * 1 + $nav-left-width + $card-column-padding)) {
    grid-template-columns: auto;
  }
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
</style>
