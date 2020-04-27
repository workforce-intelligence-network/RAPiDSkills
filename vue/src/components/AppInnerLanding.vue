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
        <router-link :to="{ name: 'signup' }" active-class="app__inner--landing__nav__button--active">
          <div class="app__inner--landing__nav__button button button--inverted">
            Sign up
          </div>
        </router-link>
      </div>
    </div>
    <div class="app__inner--landing__body">
      <div class="app__inner--landing__body__hero" />
      <div class="app__inner--landing__body__content">
        <router-view />
      </div>
      <div class="app__inner--landing__footer--dol">
        <div>This workforce product was funded by a grant awarded by the U.S. Department of Labor’s Employment and Training Administration. The product was created by the recipient and does not necessarily reflect the official position of the U.S. Department of Labor. The Department of Labor makes no guarantees, warranties, or assurances of any kind, express or implied, with respect to such information, including any information on linked sites and including, but not limited to, accuracy of the information or its completeness, timeliness, usefulness, adequacy, continued availability, or ownership. This product is copyrighted by the institution that created it.</div>
        <div class="app__inner--landing__footer--dol__cc">
          <a rel="license" href="http://creativecommons.org/licenses/by/4.0/" class="app__inner--landing__footer--dol__cc__link">
            <img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" />
          </a>
          <span>
            Except where otherwise noted, this website is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>
          </span>
        </div>
      </div>
      <div class="app__inner--landing__footer">
        <div class="app__inner--landing__footer__index">
          <router-link to="">
            <div class="app__inner--landing__footer__index__link--rapid">
              <img :src="ICON_NO_LOGO" alt="RapidSkills" />
            </div>
          </router-link>
          <!-- <router-link to="privacy">
            <div class="app__inner--landing__footer__index__link">
              Privacy
            </div>
          </router-link>
          <router-link to="terms">
            <div class="app__inner--landing__footer__index__link">
              Terms
            </div>
          </router-link>
          <router-link to="partners">
            <div class="app__inner--landing__footer__index__link">
              Partners
            </div>
          </router-link> -->
        </div>
        <div class="app__inner--landing__footer__copyright">
          © {{ currentYear }} all rights reserved.
        </div>
        <!-- <div class="app__inner--landing__footer__links"> -->
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
        <!-- </div> -->
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
$footer-dol-height: 18rem;
$footer-dol-height-mobile: 36rem;

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
  min-height: calc(100vh - #{$footer-height + $footer-dol-height});
  @include breakpoint--sm {
    min-height: calc(100vh - #{$footer-height + $footer-dol-height-mobile});
  }
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
  justify-content: space-between;
  max-width: 69rem;
  padding: 2rem 1rem;
  margin: 0 auto;
}

.app__inner--landing__footer__index {
  /* padding: 1rem 0; */
  display: flex;
  flex-direction: column;
  text-align: left;
}

.app__inner--landing__footer__copyright {
  align-self: flex-end;
  line-height: 1.25rem;
  margin-left: auto;
}

.app__inner--landing__footer--dol {
  display: flex;
  flex-direction: column;
  justify-content: space-evenly;
  align-items: center;
  background: $color-gray-light;
  padding: 0 2rem;
  line-height: 1.5rem;
  font-size: .8rem;
  height: $footer-dol-height;
  @include breakpoint--sm {
    height: $footer-dol-height-mobile;
  }
}

.app__inner--landing__footer__index__link {
  padding: .25rem 0;
}

.app__inner--landing__footer__index__link--rapid {
  padding-top: 0.5rem;
  margin-bottom: .75rem;
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

.app__inner--landing__footer--dol__cc {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  margin-top: 1.5rem;
  padding-top: 1rem;
  border-top: 1px solid $color-black-lightest;
}

.app__inner--landing__footer--dol__cc__link {
  display: block;
  height: 31px;
  margin-right: .5rem;
}
</style>
