<template>
  <div class="page page--saved">
    <div class="page--saved__cards" v-if="!showLoadingState">
      <Standard v-for="standard in standards" :standard="standard" :key="standard.id" label="Standard" saved />
    </div>
    <div class="page--saved__state--loading" v-if="showLoadingState">
      <Loading />
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
  protected get showLoadingState() {
    return this.$store.state.user.savedStandardsLoading;
  }

  protected get standards() {
    return this.$store.state.user.savedStandards;
  }
}
</script>

<style scoped lang="scss">
@import "@/scss/page";
@import "@/scss/mixins";
@import "@/scss/standards";
@import "@/scss/navbars";

$card-column-gap: 2rem;
$card-column-padding: 2rem;

.page--saved__cards {
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
</style>
