<template>
  <div id="app" class="app">
    <router-view :class="{ 'app__inner--blurred': !!modalComponent }" />
    <Modal :class="{ 'modal--visible': !!modalComponent }" :component="modalComponent" />
  </div>
</template>

<script lang="tsx">
import Vue from 'vue';
import { Component } from 'vue-property-decorator';
import Modal from '@/components/Modal.vue';

@Component({
  components: {
    Modal,
  },
})
export default class App extends Vue {
  protected get modalComponent() {
    return this.$store.state.modal.content;
  }
}
</script>

<style lang="scss">
@import "@/scss/colors";
@import "@/scss/mixins";
@import "@/scss/modal";

@import url("https://fonts.googleapis.com/css?family=Livvic:100,200,300,400,500,600,700,900&display=swap");
@import url("https://fonts.googleapis.com/css?family=Heebo:300,400,500,700&display=swap");

html,
body {
  font-size: 16px;
  margin: 0;
  padding: 0;
  height: 100%;
  width: 100%;
  font-family: "Livvic", "Heebo", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: $color-body-text;
  background: $color-body-background;
}

body * {
  box-sizing: border-box;
  user-select: none;
}

a {
  &,
  &:hover {
    text-decoration: none;
  }
}

.app {
  position: relative;
  height: 100%;
  width: 100%;
}

.app__inner {
  transition: $modal-transition-time filter ease;
}

.app__inner--blurred {
  filter: blur(2px);
}

.button {
  border-radius: 25px;
  font-size: 1rem;
  line-height: 1rem;
  padding: 0.7rem 1.5rem;
  font-weight: 600;
  border: none;
  white-space: nowrap;
  font-family: "Livvic", "Heebo", Helvetica, Arial, sans-serif;

  &[disabled] {
    opacity: .5;
    pointer-events: none;
  }

  @include breakpoint--xs {
    padding: 0.7rem 0.75rem;
  }

  color: $color-white;
  background: $color-button-blue;

  cursor: pointer;

  &:hover {
    background: $color-link-blue;
  }

  &,
  &:hover {
    text-decoration: none;
  }
}

.button--link,
.button--inverted {
  color: $color-button-blue;
  &:hover {
    color: $color-link-blue;
  }
}

.button--inverted {
  background: $color-white;
  &:hover {
    background: darken(white, 10);
  }
}

.button--link {
  padding: 0;
  &,
  &:hover {
    background: none;
  }
}

.button--link--alternative {
  &,
  &:hover {
    color: $color-white;
  }
  &:hover {
    opacity: .8;
  }
}

.button--round {
  padding: 0.5rem;
  border-radius: 50%;
}

.button--square {
  border-radius: 4px;
}

.button--tall {
  line-height: 2rem;
}

.button--alternative {
  background: $color-button-alternative-blue;
  color: $color-blue;
  border: 1px solid $color-blue;

  &:hover {
    background: fade-in($color-button-alternative-blue, .125);
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
  border-color: $color-salmon;
  &::placeholder {
    color: $color-salmon;
  }
}

.input--error .input__label {
  color: $color-salmon;
  font-weight: 700;
}

.input__label {
  font-size: 1rem;
  margin-bottom: 0.5rem;
  cursor: pointer;
}

.input__input {
  border-radius: 4px;
  margin: 0;
  padding: 0 0.5rem;
  font-size: 1rem;
  outline: none;
  border: 1px solid #f2f2f2;
  font-family: "Livvic", "Heebo", Helvetica, Arial, sans-serif;
  &:focus {
    outline: dashed 1px $color-link-blue;
    outline-offset: 4px;
  }
  &[disabled] {
    background: none;
    color: $color-text-light;
  }
}

.input__input:not(textarea) {
  height: 2.75rem;
}

.input--subtle {
  .input__label {
    margin-bottom: 0;
  }

  .input__input {
    border: none;
    border-radius: 0;
    border-bottom: 1px solid $color-gray-light;
    padding: 0;
    height: 2rem;
    &:focus {
      outline: none;
      border-bottom: 1px solid $color-blue;
    }

    &[disabled] {
      background: none;
    }
  }

  &.input--error {
    .input__label {
      color: $color-salmon;
      font-weight: 400;
    }

    .input__input {
      border-color: $color-salmon;
      &::placeholder {
        color: $color-text-light;
      }
    }
  }
}
</style>
