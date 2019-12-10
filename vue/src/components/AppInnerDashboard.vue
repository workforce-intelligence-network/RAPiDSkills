<template>
  <div class="app__inner app__inner--dashboard">
    <div class="app__inner--dashboard__body">
      <div class="app__inner--dashboard__body__content">
        <router-view />
      </div>
    </div>
    <div class="app__inner--dashboard__nav--top">
      <router-link class="app__inner--dashboard__nav--top__link app__inner--dashboard__nav--top__link--logo" :to="{ name: 'home' }">
        <img :src="LOGO_ALT_FULL_NO_ICON" alt="RapidSkills Logo" class="app__inner--dashboard__nav--top__link--logo__logo" />
      </router-link>
      <div class="app__inner--dashboard__nav--top__search">
        <router-view name="search" />
      </div>
      <a class="app__inner--dashboard__nav--top__link app__inner--dashboard__nav--top__link--support" href="javascript:void(0)">
        <img :src="ICON_TOP_NAV_SUPPORT" alt="Support Icon" class="app__inner--dashboard__nav--top__link__icon" />
      </a>
    </div>
    <div class="app__inner--dashboard__nav--left">
      <router-link class="app__inner--dashboard__nav--left__link app__inner--dashboard__nav--left__link--icon" :to="{ name: 'dashboard' }">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <img :src="ICON_WHITE" alt="RapidSkills White Icon" class="app__inner--dashboard__nav--left__link--icon__icon" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <img :src="LOGO_ALT_FULL_NO_ICON_WHITE" alt="RapidSkills Logo White" class="app__inner--dashboard__nav--left__link__name__logo" />
        </span>
      </router-link>
      <router-link class="app__inner--dashboard__nav--left__link" :to="{ name: 'dashboard' }" active-class="app__inner--dashboard__nav--left__link--active">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <img :src="ICON_LEFT_NAV_DASHBOARD" alt="Dashboard Icon" class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <span class="app__inner--dashboard__nav--left__link__name__text">
            Search Database
          </span>
        </span>
      </router-link>
      <!-- <router-link class="app__inner--dashboard__nav--left__link" :to="{ name: 'favorites' }" active-class="app__inner--dashboard__nav--left__link--active">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <img :src="ICON_LEFT_NAV_HEART" alt="Favorites Icon" class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <span class="app__inner--dashboard__nav--left__link__name__text">
            Saved Standards
          </span>
        </span>
      </router-link>
      <router-link class="app__inner--dashboard__nav--left__link" :to="{ name: 'reports' }" active-class="app__inner--dashboard__nav--left__link--active">
        <span class="app__inner--dashboard__nav--left__link--icon__icon-wrapper">
          <img :src="ICON_LEFT_NAV_PIE_CHART" alt="Reports Icon" class="app__inner--dashboard__nav--left__link--icon__icon-wrapper__icon" />
        </span>
        <span class="app__inner--dashboard__nav--left__link__name">
          <span class="app__inner--dashboard__nav--left__link__name__text">
            Reports
          </span>
        </span>
      </router-link>
      <router-link class="app__inner--dashboard__nav--left__link" :to="{ name: 'settings' }" active-class="app__inner--dashboard__nav--left__link--active">
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
import ICON_WHITE from '@/assets/icon-white.svg';
import ICON_LEFT_NAV_DASHBOARD from '@/assets/left-nav-icon-dashboard.svg';
import ICON_LEFT_NAV_HEART from '@/assets/left-nav-icon-heart.svg';
import ICON_LEFT_NAV_PIE_CHART from '@/assets/left-nav-icon-pie-chart.svg';
import ICON_LEFT_NAV_SETTINGS from '@/assets/left-nav-icon-settings.svg';
import LOGO_ALT_FULL_NO_ICON from '@/assets/logo-alt-full-no-icon.svg';
import LOGO_ALT_FULL_NO_ICON_WHITE from '@/assets/logo-alt-full-no-icon-white.svg';
import ICON_TOP_NAV_SUPPORT from '@/assets/top-nav-icon-support.svg';

export default {
  data() {
    return {
      ICON_WHITE,
      ICON_LEFT_NAV_DASHBOARD,
      ICON_LEFT_NAV_HEART,
      ICON_LEFT_NAV_PIE_CHART,
      ICON_LEFT_NAV_SETTINGS,
      LOGO_ALT_FULL_NO_ICON,
      LOGO_ALT_FULL_NO_ICON_WHITE,
      ICON_TOP_NAV_SUPPORT,
    };
  },
};
</script>

<style scoped lang="scss">
@import '@/scss/mixins';
@import '@/scss/colors';
@import '@/scss/navbars';

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

.app__inner--dashboard__nav--top__search {
  display: flex;
  flex-basis: auto;
  align-self: center;
  flex-grow: 1;
  justify-content: center;
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
}

.app__inner--dashboard__nav--top__link--support {
  align-self: flex-end;
  flex-basis: 0;
  margin-left: auto;
}

.app__inner--dashboard__nav--top__link__icon {
  width: 2rem;
}

.app__inner--dashboard__nav--left {
  top: 0;
  bottom: 0;
  left: 0;
  width: 100%;
  max-width: $nav-left-width;
  background: #002E58;
  flex-direction: column;
  align-content: flex-start;
  transition: max-width .25s ease;
  overflow-x: hidden;

  &:hover {
    max-width: $nav-left-width-expanded;
  }
}

.app__inner--dashboard__nav--left__link {
  display: flex;
  height: $nav-top-height;
  justify-content: flex-start;
  opacity: .5;

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

</style>
