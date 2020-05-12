<template>
  <div class="flex-filler" />
</template>

<script lang="ts">
import Vue from 'vue';
import {
  Component,
} from 'vue-property-decorator';

@Component
export default class FlexFiller extends Vue {
}
</script>

<style scoped lang="scss">
.flex-filler {
  flex-grow: 1;
}
</style>
