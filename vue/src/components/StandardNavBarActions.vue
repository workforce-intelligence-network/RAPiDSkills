<template>
  <div class="standard__navbar-actions">
    <PageTitle />
    <div class="standard__navbar-actions__state" v-if="sessionActive && valid">
      <div class="standard__navbar-actions__state__text" v-if="loading">Updating...</div>
      <div class="standard__navbar-actions__state__text" v-if="!loading">Up to date.</div>
    </div>
    <div class="standard__navbar-actions__state" v-if="sessionActive && !valid">
      <div class="standard__navbar-actions__state__text standard__navbar-actions__state__text--error">Standard invalid.</div>
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
  protected get valid() {
    return (this.$store.state.standards.selectedStandard || {}).valid;
  }

  protected get loading() {
    return this.$store.getters['standards/selectedStandardLoading'];
  }

  protected get sessionActive() {
    return this.$store.getters['session/isActive'];
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
  min-width: 7rem;
  text-align: center;
  white-space: nowrap;
  color: $color-text-light;
  padding: 0 1rem;
}

.standard__navbar-actions__state__text--error {
  color: $color-salmon;
}
</style>
