<template>
  <div class="page--reset">
    <div class="page--reset__form">
      <div class="page--reset__text page--reset__form__text page--reset__title" v-html="formTitle" />
      <div class="page--reset__text page--reset__form__text page--reset__subtitle" v-html="formSubtitle" />
      <form class="page--reset__form__inputs" @submit.stop.prevent="submit" @keydown.enter.stop.prevent="submit">
        <div class="input input--spaced page--reset__form__inputs__input" :class="{ 'input--error': sessionPropertyInvalid('password') }">
          <label for="password" class="input__label page--reset__form__inputs__input__label">Password</label>
          <input type="password" id="password" name="password" :placeholder="passwordPlaceholder" class="input__input page--reset__form__inputs__input__input" v-model="session.password" />
        </div>
        <div class="input input--spaced page--reset__form__inputs__input" :class="{ 'input--error': sessionPropertyInvalid('passwordConfirmation') }">
          <label for="passwordConfirmation" class="input__label page--reset__form__inputs__input__label">Confirm password</label>
          <input type="password" id="passwordConfirmation" name="passwordConfirmation" :placeholder="passwordConfirmationPlaceholder" class="input__input page--reset__form__inputs__input__input" v-model="session.passwordConfirmation" />
        </div>
        <div class="page--reset__form__inputs__error" v-if="submitError" v-html="errorMessage" />
        <button type="submit" class="button button--inverted page--reset__form__inputs__button--submit" :disabled="session.loading">
          {{ submitButtonText }}
        </button>
      </form>
    </div>
  </div>
</template>

<script lang="tsx">
import _get from 'lodash/get';
import Vue from 'vue';
import { Component, Prop } from 'vue-property-decorator';

import {
  ValidatorOptions,
} from 'class-validator';

import Session, { VALIDATION_GROUP_NAME_RESET } from '@/models/Session';

const validatorOptions: ValidatorOptions = {
  groups: [VALIDATION_GROUP_NAME_RESET],
  whitelist: true,
};

@Component
export default class ResetPassword extends Vue {
  submitError: boolean = false

  session: Session = new Session({ validatorOptions })

  formTitle: string = 'Reset password'

  formSubtitle: string = 'Please enter a new password to finish resetting.'

  passwordPlaceholder: string = 'Your new password'

  passwordConfirmationPlaceholder: string = 'Your new password, again'

  errorMessage: string = 'We failed to reset your password, please try again.'

  sessionPropertyInvalid(property: string) {
    return this.submitError || (this.session.validating && this.session.propertyInvalid(property));
  }

  mounted() {
    this.session.resetToken = _get(this, '$route.query.resetToken');
  }

  async submit() {
    try {
      await this.session.save();
      this.$router.push({ name: 'standards' }); // TODO: define a "go to home" method?
    } catch (e) {
      this.submitError = this.session.valid;
    }
  }

  get submitButtonText(): string {
    return this.session.loading ? 'Submitting...' : 'Submit';
  }
}
</script>

<style lang="scss" scoped>
@import '@/scss/colors';

.page--reset {
  padding-top: 6rem;
  min-height: 50rem;
}

.page--reset__form {
  max-width: 32rem;
  margin: 0 auto;
  padding: 0 1rem;
}

.page--reset__form__text {
  color: $color-white;
}

.page--reset__form__submitted {
  display: flex;
  flex-direction: column;
  justify-content: center;
  font-size: 1.5rem;
  line-height: 2.5rem;
  height: 22rem;
}

.page--reset__title {
  font-size: 2.5rem;
  margin-bottom: 1.5rem;
  font-weight: 600;
}

.page--reset__subtitle {
  font-size: 1.125rem;
  line-height: 2rem;
  margin-bottom: 3rem;
  font-weight: 500;
}

.page--reset__form__inputs__input {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.page--reset__form__inputs__input__label,
.page--reset__form__inputs__input__input {
  text-align: left;
  width: 100%;
}

.page--reset__form__inputs__input__label {
  color: $color-white;
}

.page--reset__form__inputs__button--submit {
  margin-top: 1rem;
}

.page--reset__form__inputs__error {
  padding-top: .5rem;
  color: $color-salmon;
  font-weight: 700;
}
</style>
