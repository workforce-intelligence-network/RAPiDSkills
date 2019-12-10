<template>
  <div class="page page--dashboard">
    <div class="page--dashboard__cards">
      <Standard v-for="standard in standards" :standard="standard" :key="standard.id" label="Standard" />
    </div>
  </div>
</template>

<script>
import _times from 'lodash/times';

import Standard from '@/components/Standard.vue';

import LOGO_WIN from '@/assets/win.png';

export default {
  name: 'dashboard',
  components: {
    Standard,
  },
  data() {
    return {
      standards: _times(32, key => ({
        key,
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
      })),
    };
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
</style>
