<template>
  <div id="app" class="app">
    <div id="nav" class="app__nav">
      <router-link to="/">
        <div class="app__nav__link">
          <FontAwesomeIcon icon="bolt" class="app__nav__link__icon" />
          <span>RapidSkills</span>
        </div>
      </router-link>
      <router-link to="/follow" active-class="app__nav__button--active">
        <div class="app__nav__button button button--inverted">
          Follow Us
        </div>
      </router-link>
    </div>
    <div class="app__body">
      <div class="app__body__hero" />
      <div class="app__body__content">
        <router-view />
      </div>
      <div class="app__footer">
        <router-link to="/">
          <div class="app__footer__icon">
            <img src="./assets/icon-no-logo.svg" alt="RapidSkills" />
          </div>
        </router-link>
        <div class="app__footer__copyright">
          © {{ currentYear }} all rights reserved.
        </div>
        <div class="app__footer__links">
          <a class="app__footer__links__link" href="https://facebook.com" target="_blank">
            <FontAwesomeIcon :icon="['fab', 'facebook-f']" class="app__footer__links__icon" />
          </a>
          <a class="app__footer__links__link" href="https://twitter.com" target="_blank">
            <FontAwesomeIcon :icon="['fab', 'twitter']" class="app__footer__links__icon" />
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
export default {
  computed: {
    currentYear() {
      return (new Date()).getFullYear();
    },
  },
};
</script>

<style lang="scss">
@import url('https://fonts.googleapis.com/css?family=Livvic:100,200,300,400,500,600,700,900&display=swap');
@import url('https://fonts.googleapis.com/css?family=Heebo:300,400,500,700&display=swap');

$breakpoint-mobile: 32rem;
@mixin breakpoint--mobile {
  @media (max-width: $breakpoint-mobile) {
    @content;
  }
}

html, body {
  font-size: 16px;
  margin: 0;
  padding: 0;
  height: 100%;
  width: 100%;
  overflow-x: hidden;
  overflow-y: auto;
  font-family: 'Livvic', 'Heebo', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  background: #FAFBFC;
}

body * {
  box-sizing: border-box;
}

a {
  &, &:hover {
    text-decoration: none;
  }
}

$nav-height: 4rem;

$footer-height: 12.5rem;

$hero-height: 50rem;

.app {
  position: relative;
  height: 100%;
  width: 100%;
  overflow: auto;
}

.app__footer,
.app__nav {
  z-index: 2;
}

.app__nav {
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
  margin-top: .5rem;
}

.app__nav,
.app__nav__link,
.app__nav__button {
  display: flex;
}

.app__nav__button--active {
  display: none;
}

.app__nav__link__icon {
  height: 2rem;
  line-height: 2rem;
  margin-right: .5rem;
}

.app__nav__link {
  font-size: 1.125rem;
  line-height: 2rem;
  color: white;
  padding: 1rem 1rem;
}

.app__body {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1;
}

.app__body__content {
  position: relative;
  z-index: 1;
  min-height: calc(100vh - #{$footer-height});
}

.app__body__hero {
  z-index: 0;
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: $hero-height;
  background-image: url('./assets/home-hero-background.svg');
  background-position: left;
  background-size: cover;
}

.app__footer {
  height: $footer-height;
  display: flex;
  align-items: center;
  max-width: 69rem;
  padding: 0 1rem;
  margin: 0 auto;
}

.app__footer__copyright {
  line-height: 1.25rem;
  margin-left: 1rem;
}

.app__footer__icon {
  padding-top: .5rem;
}

.app__footer__links {
  display: flex;
  margin-left: auto;
}

.app__footer__links__link {
  padding: 1rem;
}

.app__footer__links__icon {
  &, &:hover {
    color: initial;
    background: none;
  }
}

.button {
  border-radius: 25px;
  font-size: 1rem;
  padding: .7rem 1.5rem;
  font-weight: 600;

  color: white;
  background: #459EFF;

  cursor: pointer;

  &:hover {
    background: #0073FF;
  }

  &, &:hover {
    text-decoration: none;
  }
}

.button--link,
.button--inverted {
  color: #459EFF;
  &:hover {
    color: #0073FF;
  }
}

.button--inverted {
  background: white;
  &:hover {
    background: darken(white, 10);
  }
}

.button--link {
  padding: 0;
  &, &:hover {
    background: none;
  }
}

.input {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.input--spaced {
  margin-bottom: 1rem;
}

.input--error .input__input {
  border-color: salmon;
  &::placeholder {
    color: salmon;
  }
}

.input--error .input__label {
  color: salmon;
}

.input__label {
  font-size: 1rem;
  margin-bottom: .5rem;
  cursor: pointer;
}

.input__input {
  border-radius: 4px;
  margin: 0;
  padding: 0 .5rem;
  font-size: 1rem;
  outline: none;
  border: 1px solid #f2f2f2;
  font-family: 'Livvic', 'Heebo', Helvetica, Arial, sans-serif;
  &:focus {
    outline: dashed 1px #459EFF;
    outline-offset: 4px;
  }
}

.input__input:not(textarea) {
  height: 2.75rem;
}
</style>
