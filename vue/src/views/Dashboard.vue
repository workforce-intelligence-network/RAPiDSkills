<template>
  <div class="page page--dashboard">
    <div class="page--dashboard__cards">
      <Standard v-for="standard in standards" :standard="standard" :key="standard.id" label="Standard" />
      <div class="page--dashboard__cards__empty-state" v-if="showEmptyState">
        <div class="page--dashboard__cards__empty-state__description">
          <span>No standards found </span>
          <span v-if="selectedOccupation">for occupation {{ selectedOccupation.title }}</span>
        </div>
        <div class="page--dashboard__cards__empty-state__action">
          Please try searching for a different occupation
        </div>
        <div class="page--dashboard__cards__empty-state__button button button--link" @click="clearSelectedOccupation">
          Clear selected occupation
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import _times from 'lodash/times';

import { mapGetters, mapState } from 'vuex';

import Standard from '@/components/Standard.vue';

import LOGO_WIN from '@/assets/win.png';

export default {
  name: 'dashboard',
  components: {
    Standard,
  },
  methods: {
    clearSelectedOccupation() {
      (this as any).$store.dispatch('occupations/setSelectedOccupation');
    },
  },
  computed: {
    ...mapGetters({
      showEmptyState: 'standards/standardsListEmptyAndNotLoading',
    }),
    ...mapState({
      selectedOccupation: (state: any) => state.occupations.selectedOccupation,
    }),
    standards() {
      // TODO: remove fake data
      (this as any).$store.state.standards.list.forEach((standard) => {
        Object.assign(standard, {
          organization: {
            logo: LOGO_WIN,
            name: 'WIN',
          },
          occupation: {
            name: 'Mechatronics Technician',
            type: 'Hybrid',
            onet: '51-4012.00',
            cb: '1100CB',
          },
          workProcesses: _times(18, () => ({
            skills: _times(8, () => ({})),
            hoursTotal: 334,
          })),
        });
      });
      return (this as any).$store.state.standards.list;
    },
  },
};
</script>

<style scoped lang="scss">
@import '@/scss/page';
@import '@/scss/mixins';
@import '@/scss/standards';
@import '@/scss/navbars';

$card-column-gap: 2rem;

.page--dashboard__cards {
  display: grid;
  flex-direction: row;
  flex-wrap: wrap;
  justify-content: center;
  row-gap: 2rem;
  column-gap: $card-column-gap;
  grid-template-columns: auto auto auto auto;

  @for $i from 2 through 12 {
    @media (max-width: ($standard-width * ($i + 1) + $card-column-gap * $i + $nav-left-width)) and
      (min-width: ($standard-width * $i + $card-column-gap * ($i - 1) + $nav-left-width))
    {
      grid-template-columns: repeat($i, auto);
    }
  }

  @media (max-width: ($standard-width * 2 + $card-column-gap * 1 + $nav-left-width)) {
    grid-template-columns: auto;
  }
}

.page--dashboard__cards__empty-state__description {
  font-weight: 600;
  font-size: 1.25rem;
  padding: 2rem 0;
}

.page--dashboard__cards__empty-state__action {
  margin-bottom: 1rem;
}
</style>
