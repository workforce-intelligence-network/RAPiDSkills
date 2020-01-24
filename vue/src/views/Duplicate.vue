<template>
  <div class="page--duplicate">
    Penis
  </div>
</template>

<script lang="tsx">
import Vue from 'vue';
import { Component, Prop, Provide } from 'vue-property-decorator';

@Component
export default class Duplicate extends Vue {
  beforeDestroy() {
    this.$router.push({ name: 'standards' });
  }
}
</script>

<style lang="scss" scoped>
@import '@/scss/colors';
</style>
