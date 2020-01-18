<template>
  <div class="page--login">
    <div class="page--login__form">
      <div class="page--login__text page--login__form__text page--login__title" v-html="formTitle" />
      <div class="page--login__text page--login__form__text page--login__subtitle" v-html="formSubtitle" />
      <form class="page--login__form__inputs" @submit.prevent="submit">
        <div class="input input--spaced page--login__form__inputs__input" :class="{ 'input--error': sessionPropertyInvalid('email') }">
          <label for="email" class="input__label page--login__form__inputs__input__label">Email</label>
          <input type="email" id="email" name="email" :placeholder="emailPlaceholder" class="input__input page--login__form__inputs__input__input" v-model="session.email" />
        </div>
        <div class="input input--spaced page--login__form__inputs__input" :class="{ 'input--error': sessionPropertyInvalid('password') }">
          <label for="password" class="input__label page--login__form__inputs__input__label">Password</label>
          <input type="password" id="password" name="password" :placeholder="passwordPlaceholder" class="input__input page--login__form__inputs__input__input" v-model="session.password" />
        </div>
        <div class="page--login__form__inputs__error" v-if="submitError" v-html="errorMessage" />
        <button type="submit" class="button button--inverted page--login__form__inputs__button--submit" :disabled="loading">
          {{ submitButtonText }}
        </button>
      </form>
    </div>
  </div>
</template>

<script lang="tsx">
import Vue from 'vue';
import { Component, Prop } from 'vue-property-decorator';

import {
  ValidationError,
} from 'class-validator';

import Session from '@/models/Session';

import { apiRaw } from '@/utilities/api';

@Component
export default class Login extends Vue {
  submitted: boolean = false

  submitError: boolean = false

  loading: boolean = false

  session: Session = new Session()

  formTitle: string = 'Login'

  formSubtitle: string = 'Please enter your email and password to login.'

  emailPlaceholder: string = 'Your email'

  passwordPlaceholder: string = 'Your password'

  errorMessage: string = 'Incorrect email or password, please try again.'

  sessionPropertyInvalid(property: string) {
    return this.submitError || (this.submitted && this.session.propertyInvalid(property));
  }

  async submit() {
    this.submitted = true;

    if (this.session.invalid) {
      return;
    }

    this.submitted = false;
    this.submitError = false;
    this.loading = true;

    try {
      await this.session.save();
      this.$router.push({ name: 'standards' }); // TODO: define a "go to home" method?
    } catch (e) {
      this.submitError = true;
    }

    this.loading = false;
  }

  get submitButtonText(): string {
    return this.loading ? 'Submitting...' : 'Submit';
  }
}
</script>

<style lang="scss">
@import '@/scss/colors';

.page--login {
  padding-top: 6rem;
  min-height: 50rem;
}

.page--login__form {
  max-width: 32rem;
  margin: 0 auto;
  padding: 0 1rem;
}

.page--login__form__text {
  color: $color-white;
}

.page--login__form__submitted {
  display: flex;
  flex-direction: column;
  justify-content: center;
  font-size: 1.5rem;
  line-height: 2.5rem;
  height: 22rem;
}

.page--login__title {
  font-size: 2.5rem;
  margin-bottom: 1.5rem;
  font-weight: 600;
}

.page--login__subtitle {
  font-size: 1.125rem;
  line-height: 2rem;
  margin-bottom: 3rem;
  font-weight: 500;
}

.page--login__form__inputs__input {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.page--login__form__inputs__input__label,
.page--login__form__inputs__input__input {
  text-align: left;
  width: 100%;
}

.page--login__form__inputs__input__label {
  color: $color-white;
}

.page--login__form__inputs__button--submit {
  margin-top: 2rem;
}

.page--login__form__inputs__error {
  padding-top: .5rem;
  color: $color-salmon;
  font-weight: bold;
}
</style>
