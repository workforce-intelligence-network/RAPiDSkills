<template>
  <div class="app__inner--pages">
    <div class="app__inner--pages__body" id="body">
      <div class="app__inner--pages__body__content">
        <router-view />
      </div>
    </div>
    <div class="app__inner--pages__nav--top">
      <router-link class="app__inner--pages__nav--top__link app__inner--pages__nav--top__link--logo" :to="{ name: 'home' }">
        <img :src="LOGO_ALT" alt="RapidSkills Logo" class="app__inner--pages__nav--top__link--logo__logo" />
      </router-link>
    </div>
  </div>
</template>

<script scoped lang="ts">
import Vue from 'vue';
import {
  Component, Provide,
} from 'vue-property-decorator';

import LOGO_ALT from '@/assets/logo-alt.svg';

@Component
export default class AppInnerDashboard extends Vue {
  @Provide('LOGO_ALT') LOGO_ALT = LOGO_ALT
}
</script>

<style scoped lang="scss">
@import "@/scss/mixins";
@import "@/scss/colors";
@import "@/scss/navbars";
@import "@/scss/dashboard";

.app__inner--pages__nav--top,
.app__inner--pages__body {
  position: fixed;
}

.app__inner--pages__nav--top {
  display: flex;
}

.app__inner--pages__nav--top {
  top: 0;
  left: 0;
  right: 0;
  height: $nav-top-height;
  background: $color-white;
  box-shadow: $color-nav-bar-top-box-shadow 0px 4px 32px 1px;
  flex-direction: row;
  align-content: center;
  justify-content: center;
}

.app__inner--pages__nav--top__link {
  display: flex;
  height: $nav-top-height;
  justify-content: center;
  padding: 0 $nav-top-link-padding-sides;
  &:hover {
    background: transparentize($color: $color-black, $amount: 0.98);
  }
}

.app__inner--pages__nav--top__link--logo {
  padding: 0 1rem;
}

.app__inner--pages__nav--top__link__icon {
  width: 2rem;
}

.app__inner--pages__body {
  top: $nav-top-height;
  left: 0;
  min-width: 100vw;
  min-height: calc(100vh - #{$nav-top-height});
  right: 0;
  bottom: 0;
  overflow: auto;
}

.app__inner--pages__body__content {
  position: relative;
  min-height: 100%;
  width: 100%;
  overflow-x: hidden;
  padding-bottom: $dashboard-body-content-bottom-padding;
}

</style>
