<template>
  <div class="standard__navbar-actions">
    <PageTitle />
    <div class="standard__navbar-actions__state">
      <div class="standard__navbar-actions__state__text" v-if="loading">Loading...</div>
      <div class="standard__navbar-actions__state__text" v-if="!loading">Up to date.</div>
    </div>
  </div>
</template>

<script lang="ts">

import Vue from 'vue';

import {
  Component,
} from 'vue-property-decorator';

import PageTitle from '@/components/PageTitle.vue';

import Loading from '@/components/Loading.vue';

@Component({
  components: {
    Loading,
    PageTitle,
  },
})
export default class StandardNavBarActions extends Vue {
  protected get loading() {
    return this.$store.getters['standards/selectedStandardLoading'];
  }
}
</script>

<style scoped lang="scss">
@import '@/scss/colors';

.standard__navbar-actions {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  text-align: left;
}

.standard__navbar-actions__state__text {
  white-space: nowrap;
  color: $color-text-light;
  padding: 0 1rem;
}
</style>
