<template>
  <div class="app__inner app__inner--landing">
    <div class="app__inner--landing__nav">
      <router-link to="/">
        <div class="app__inner--landing__nav__link app__inner--landing__nav__link--logo">
          <img :src="ICON_WITH_LOGO" alt="RapidSkills Icon" class="app__inner--landing__nav__link__icon" />
        </div>
      </router-link>
      <router-link to="/follow" active-class="app__inner--landing__nav__button--active">
        <div class="app__inner--landing__nav__button button button--inverted">
          Follow Us
        </div>
      </router-link>
    </div>
    <div class="app__inner--landing__body">
      <div class="app__inner--landing__body__hero" />
      <div class="app__inner--landing__body__content">
        <router-view />
      </div>
      <div class="app__inner--landing__footer">
        <router-link to="/standards">
          <div class="app__inner--landing__footer__icon">
            <img :src="ICON_NO_LOGO" alt="RapidSkills" />
          </div>
        </router-link>
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
import ICON_WITH_LOGO from '@/assets/icon-with-logo.svg';
import ICON_NO_LOGO from '@/assets/icon-no-logo.svg';

export default {
  data() {
    return {
      ICON_WITH_LOGO,
      ICON_NO_LOGO,
    };
  },
  computed: {
    currentYear() {
      return (new Date()).getFullYear();
    },
  },
};
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
}

.app__inner--landing__nav,
.app__inner--landing__nav__link,
.app__inner--landing__nav__button {
  display: flex;
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
