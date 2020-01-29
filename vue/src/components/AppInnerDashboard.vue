<template>
  <div class="app__inner--dashboard">
    <div class="app__inner--dashboard__body">
      <div class="app__inner--dashboard__body__content">
        <router-view />
      </div>
    </div>
    <div class="app__inner--dashboard__nav--top">
      <router-link class="app__inner--dashboard__nav--top__link app__inner--dashboard__nav--top__link--logo" :to="{ name: 'home' }">
        <img :src="LOGO_ALT_FULL_NO_ICON" alt="RapidSkills Logo" class="app__inner--dashboard__nav--top__link--logo__logo" />
      </router-link>
      <div class="app__inner--dashboard__nav--top__navbar-actions" :class="{ 'app__inner--dashboard__nav--top__navbar-actions--session-active': sessionActive }">
        <router-view name="navbarActions" />
      </div>
      <a class="app__inner--dashboard__nav--top__link app__inner--dashboard__nav--top__link--support" href="javascript:void(0)">
        <img :src="ICON_TOP_NAV_SUPPORT" alt="Support Icon" class="app__inner--dashboard__nav--top__link__icon" />
      </a>
      <a class="app__inner--dashboard__nav--top__link app__inner--dashboard__nav--top__link--user" href="javascript:void(0)" v-if="sessionActive">
        <div class="app__inner--dashboard__nav--top__link--user__button">
          ?
        </div>
      </a>
    </div>
    <div class="app__inner--dashboard__nav--left">
      <a class="app__inner--dashboard__nav--left__link app__inner--dashboard__nav--left__link--icon" href="javascript:void(0)">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <img :src="ICON_WHITE" alt="RapidSkills White Icon" class="app__inner--dashboard__nav--left__link--icon__icon" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <img :src="LOGO_ALT_FULL_NO_ICON_WHITE" alt="RapidSkills Logo White" class="app__inner--dashboard__nav--left__link__name__logo" />
        </span>
      </a>
      <router-link class="app__inner--dashboard__nav--left__link" :to="{ name: 'standards' }" active-class="app__inner--dashboard__nav--left__link--active">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <img :src="ICON_LEFT_NAV_DASHBOARD" alt="Dashboard Icon" class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <span class="app__inner--dashboard__nav--left__link__name__text">
            Search Database
          </span>
        </span>
      </router-link>
      <!-- <router-link class="app__inner--dashboard__nav--left__link" :to="{ name: 'saved' }" active-class="app__inner--dashboard__nav--left__link--active" v-if="sessionActive">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <img :src="ICON_LEFT_NAV_HEART" alt="Saved Standards Icon" class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <span class="app__inner--dashboard__nav--left__link__name__text">
            Saved Standards
          </span>
        </span>
      </router-link> -->
      <!-- <router-link class="app__inner--dashboard__nav--left__link" :to="{ name: 'reports' }" active-class="app__inner--dashboard__nav--left__link--active" v-if="sessionActive">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <img :src="ICON_LEFT_NAV_PIE_CHART" alt="Reports Icon" class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <span class="app__inner--dashboard__nav--left__link__name__text">
            Reports
          </span>
        </span>
      </router-link>
      <router-link class="app__inner--dashboard__nav--left__link" :to="{ name: 'settings' }" active-class="app__inner--dashboard__nav--left__link--active" v-if="sessionActive">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <img :src="ICON_LEFT_NAV_SETTINGS" alt="Settings Icon" class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <span class="app__inner--dashboard__nav--left__link__name__text">
            Settings
          </span>
        </span>
      </router-link> -->
    </div>
  </div>
</template>

<script scoped lang="ts">
import Vue from 'vue';
import {
  Component, Provide,
} from 'vue-property-decorator';

import ICON_WHITE from '@/assets/icon-white.svg';
import ICON_LEFT_NAV_DASHBOARD from '@/assets/left-nav-icon-dashboard.svg';
import ICON_LEFT_NAV_HEART from '@/assets/left-nav-icon-heart.svg';
import ICON_LEFT_NAV_PIE_CHART from '@/assets/left-nav-icon-pie-chart.svg';
import ICON_LEFT_NAV_SETTINGS from '@/assets/left-nav-icon-settings.svg';
import LOGO_ALT_FULL_NO_ICON from '@/assets/logo-alt-full-no-icon.svg';
import LOGO_ALT_FULL_NO_ICON_WHITE from '@/assets/logo-alt-full-no-icon-white.svg';
import ICON_TOP_NAV_SUPPORT from '@/assets/top-nav-icon-support.svg';


@Component
export default class AppInnerDashboard extends Vue {
  @Provide('ICON_WHITE') ICON_WHITE = ICON_WHITE

  @Provide('ICON_LEFT_NAV_DASHBOARD') ICON_LEFT_NAV_DASHBOARD = ICON_LEFT_NAV_DASHBOARD

  @Provide('ICON_LEFT_NAV_HEART') ICON_LEFT_NAV_HEART = ICON_LEFT_NAV_HEART

  @Provide('ICON_LEFT_NAV_PIE_CHART') ICON_LEFT_NAV_PIE_CHART = ICON_LEFT_NAV_PIE_CHART

  @Provide('ICON_LEFT_NAV_SETTINGS') ICON_LEFT_NAV_SETTINGS = ICON_LEFT_NAV_SETTINGS

  @Provide('LOGO_ALT_FULL_NO_ICON') LOGO_ALT_FULL_NO_ICON = LOGO_ALT_FULL_NO_ICON

  @Provide('LOGO_ALT_FULL_NO_ICON_WHITE') LOGO_ALT_FULL_NO_ICON_WHITE = LOGO_ALT_FULL_NO_ICON_WHITE

  @Provide('ICON_TOP_NAV_SUPPORT') ICON_TOP_NAV_SUPPORT = ICON_TOP_NAV_SUPPORT

  protected get sessionActive() {
    return this.$store.getters['session/isActive'];
  }
}
</script>

<style scoped lang="scss">
@import "@/scss/mixins";
@import "@/scss/colors";
@import "@/scss/navbars";

.app__inner--dashboard__nav--top,
.app__inner--dashboard__nav--left,
.app__inner--dashboard__body {
  position: fixed;
}

.app__inner--dashboard__nav--top,
.app__inner--dashboard__nav--left {
  display: flex;
}

.app__inner--dashboard__nav--top {
  top: 0;
  left: $nav-left-width;
  right: 0;
  height: $nav-top-height;
  background: $color-white;
  box-shadow: $color-nav-bar-top-box-shadow 0px 4px 32px 1px;
  flex-direction: row;
  align-content: space-between;
}

.app__inner--dashboard__nav--top__navbar-actions {
  display: flex;
  flex-basis: auto;
  align-self: center;
  flex-grow: 1;
  justify-content: center;
  padding-left: 0.5rem;
  max-width: calc(100% - 4rem);
  &.app__inner--dashboard__nav--top__navbar-actions--session-active {
    max-width: calc(100% - 8rem);
  }
}

.app__inner--dashboard__nav--top__link {
  display: flex;
  height: $nav-top-height;
  justify-content: center;
  padding: 0 $nav-top-link-padding-sides;
}

.app__inner--dashboard__nav--top__link--logo {
  align-self: flex-start;
  flex-basis: 0;

  @include breakpoint--sm {
    display: none;
  }
}

.app__inner--dashboard__nav--top__link--support {
  align-self: flex-end;
  flex-basis: 0;
  margin-left: auto;
  flex-shrink: 0;
}

.app__inner--dashboard__nav--top__link__icon {
  width: 2rem;
}

.app__inner--dashboard__nav--left {
  top: 0;
  bottom: 0;
  left: 0;
  width: $nav-left-width;
  height: 100vh;
  background: $color-nav-left-background-blue;
  flex-direction: column;
  align-content: flex-start;
  transition: width 0.25s ease;
  overflow-x: hidden;

  &:hover {
    width: $nav-left-width-expanded;
  }
}

.app__inner--dashboard__nav--left__link {
  display: flex;
  height: $nav-top-height;
  justify-content: flex-start;
  opacity: 0.5;

  &:hover {
    background: $color-black-darkened;
  }
}

.app__inner--dashboard__nav--left__link--icon__icon {
  width: 1.125rem;
}

.app__inner--dashboard__nav--left__link--icon__icon-wrapper {
  display: flex;
  justify-content: center;
  height: 100%;
  width: $nav-left-width;
}

.app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon {
  width: 1.5rem;
}

.app__inner--dashboard__nav--left__link--active {
  opacity: 1;
}

.app__inner--dashboard__nav--left__link--icon {
  opacity: 1;
  background: $color-blue;

  &:hover {
    background: $color-blue-darkened;
  }
}

.app__inner--dashboard__nav--left__link__name {
  display: flex;
  align-items: center;
  height: 100%;
  color: $color-white;
  width: 0;
  overflow: visible;
  white-space: nowrap;
  font-weight: 500;
}

.app__inner--dashboard__nav--left__link__name__logo {
  padding-left: $nav-top-link-padding-sides;
}

.app__inner--dashboard__body {
  top: $nav-top-height;
  left: $nav-left-width;
  min-width: calc(100vw - #{$nav-left-width});
  min-height: calc(100vh - #{$nav-top-height});
  right: 0;
  bottom: 0;
  overflow: auto;
}

.app__inner--dashboard__body__content {
  position: relative;
  min-height: 100%;
  width: 100%;
  overflow-x: hidden;
}

.app__inner--dashboard__nav--top__link--user {
  padding: 0.75rem;
  border-left: 1px solid $color-gray-light;
}

.app__inner--dashboard__nav--top__link--user__button {
  height: 2.5rem;
  width: 2.5rem;
  border-radius: 50%;
  color: $color-white;
  background-color: $color-blue;
  font-weight: 600;
  line-height: 2.5rem;
}
</style>
