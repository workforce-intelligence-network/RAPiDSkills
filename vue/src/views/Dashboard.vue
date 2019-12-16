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
      standards: _times(16, key => ({
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

.page--dashboard__cards {
  display: grid;
  flex-direction: row;
  flex-wrap: wrap;
  grid-template-columns: auto auto auto auto;
  justify-content: center;
  row-gap: 2rem;
  column-gap: 2rem;
}
</style>
