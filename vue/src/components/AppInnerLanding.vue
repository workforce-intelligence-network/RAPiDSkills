<template>
  <div class="app__inner--landing">
    <div class="app__inner--landing__nav">
      <router-link to="/">
        <div class="app__inner--landing__nav__link app__inner--landing__nav__link--logo">
          <img :src="ICON_WITH_LOGO" alt="RapidSkills Icon" class="app__inner--landing__nav__link__icon" />
        </div>
      </router-link>
      <div class="app__inner--landing__nav__right" v-if="sessionActive">
        <router-link :to="{ name: 'standards' }" active-class="app__inner--landing__nav__button--active">
          <div class="app__inner--landing__nav__button button button--inverted">
            Dashboard
          </div>
        </router-link>
      </div>
      <div class="app__inner--landing__nav__right" v-if="!sessionActive">
        <router-link :to="{ name: 'login' }" active-class="app__inner--landing__nav__button--active">
          <div class="app__inner--landing__nav__button button button--link button--link--alternative">
            Login
          </div>
        </router-link>
        <router-link :to="{ name: 'follow' }" active-class="app__inner--landing__nav__button--active">
          <div class="app__inner--landing__nav__button button button--inverted">
            Follow us
          </div>
        </router-link>
        <!-- <router-link :to="{ name: 'signup' }" active-class="app__inner--landing__nav__button--active">
          <div class="app__inner--landing__nav__button button button--inverted">
            Sign up
          </div>
        </router-link> -->
      </div>
    </div>
    <div class="app__inner--landing__body">
      <div class="app__inner--landing__body__hero" />
      <div class="app__inner--landing__body__content">
        <router-view />
      </div>
      <div class="app__inner--landing__footer">
        <router-link to="">
          <div class="app__inner--landing__footer__icon">
            <img :src="ICON_NO_LOGO" alt="RapidSkills" />
          </div>
        </router-link>
        <div class="app__inner--landing__footer__dol_copy">
          <small>
            This workforce product was funded by a grant awarded by the U.S. Department of Labor’s Employment and Training Administration. The product was created by the recipient and does not necessarily reflect the official position of the U.S. Department of Labor. The Department of Labor makes no guarantees, warranties, or assurances of any kind, express or implied, with respect to such information, including any information on linked sites and including, but not limited to, accuracy of the information or its completeness, timeliness, usefulness, adequacy, continued availability, or ownership. This product is copyrighted by the institution that created it.
          </small>
        </div>
        <div class="app__inner--landing__footer__copyright">
          © {{ currentYear }} all rights reserved.
        </div>
        <div class="app__inner--landing__footer__links">
          <!-- <a class="app__inner--landing__footer__links__link" href="https://facebook.com" target="_blank">
            <FontAwesomeIcon
              :icon="['fab', 'facebook-f']"
              class="app__inner--landing__footer__links__icon"
            />
          </a>
          <a class="app__inner--landing__footer__links__link" href="https://twitter.com" target="_blank">
            <FontAwesomeIcon
              :icon="['fab', 'twitter']"
              class="app__inner--landing__footer__links__icon"
            />
          </a> -->
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import {
  Component, Provide,
} from 'vue-property-decorator';

import ICON_WITH_LOGO from '@/assets/icon-with-logo.svg';
import ICON_NO_LOGO from '@/assets/icon-no-logo.svg';

@Component
export default class AppInnerLanding extends Vue {
  @Provide('ICON_WITH_LOGO') ICON_WITH_LOGO = ICON_WITH_LOGO

  @Provide('ICON_NO_LOGO') ICON_NO_LOGO = ICON_NO_LOGO

  @Provide('currentYear') currentYear = (new Date()).getFullYear()

  protected get sessionActive() {
    return this.$store.getters['session/isActive'];
  }
}
</script>

<style scoped lang="scss">
@import "@/scss/colors";
@import "@/scss/mixins";

$nav-height: 4rem;

$footer-height: 12.5rem;

$hero-height: 50rem;

.app__inner--landing__footer,
.app__inner--landing__nav {
  z-index: 2;
}

.app__inner--landing__nav {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  width: 100%;
  height: $nav-height;
  overflow: hidden;
  justify-content: space-between;
  align-items: center;
  padding: 0 1rem;
  margin-top: 0.5rem;

  @include breakpoint--xs {
    padding: 0.25rem;
  }
}
.app__inner--landing__nav__right {
  display: flex;
  justify-content: space-between;
}

.app__inner--landing__nav,
.app__inner--landing__nav__link,
.app__inner--landing__nav__button {
  display: flex;
}

.app__inner--landing__nav__button {
  white-space: nowrap;
}

.app__inner--landing__nav__button.button--link {
  display: flex;
  padding: .7rem 2rem;

  @include breakpoint--xs {
    padding: .7rem .75rem;
  }
}


.app__inner--landing__nav__button--active {
  display: none;
}

.app__inner--landing__nav__link__icon {
  @include breakpoint--sm {
    max-width: 8rem;
  }
}

.app__inner--landing__nav__link {
  font-size: 1.125rem;
  line-height: 2rem;
  color: $color-white;
  padding: 1rem 1rem;
}

.app__inner--landing__body {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1;
}

.app__inner--landing__body__content {
  position: relative;
  z-index: 1;
  min-height: calc(100vh - #{$footer-height});
}

.app__inner--landing__body__hero {
  z-index: 0;
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: $hero-height;
  background-image: url("../assets/home-hero-background.svg");
  background-position: left;
  background-size: cover;
}

.app__inner--landing__footer {
  height: $footer-height;
  display: flex;
  align-items: center;
  max-width: 69rem;
  padding: 0 1rem;
  margin: 0 auto;
}

.app__inner--landing__footer__copyright {
  line-height: 1.25rem;
  margin-left: 1rem;
}

.app__inner--landing__footer__dol_copy {
  margin: 50px;
}


.app__inner--landing__footer__icon {
  padding-top: 0.5rem;
}

.app__inner--landing__footer__links {
  display: flex;
  margin-left: auto;
}

.app__inner--landing__footer__links__link {
  padding: 1rem;
}

.app__inner--landing__footer__links__icon {
  &,
  &:hover {
    color: initial;
    background: none;
  }
}
</style>
