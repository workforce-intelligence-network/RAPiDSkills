<template>
  <div class="page--forgot">
    <div class="page--forgot__form">
      <div class="page--forgot__text page--forgot__form__text page--forgot__title" v-html="formTitle" />
      <div class="page--forgot__text page--forgot__form__text page--forgot__subtitle" v-html="formSubtitle" />
      <div class="page--forgot__form__success" v-if="successful" v-html="successMessage" />
      <form class="page--forgot__form__inputs" @submit.prevent="submit" v-if="!successful">
        <div class="input input--spaced page--forgot__form__inputs__input" :class="{ 'input--error': userPropertyInvalid('email') }">
          <label for="email" class="input__label page--forgot__form__inputs__input__label">Email</label>
          <input type="email" id="email" name="email" :placeholder="emailPlaceholder" class="input__input page--forgot__form__inputs__input__input" v-model="user.email" />
        </div>
        <div class="page--forgot__form__inputs__error" v-if="submitError" v-html="errorMessage" />
        <button type="submit" class="button button--inverted page--forgot__form__inputs__button--submit" :disabled="user.loading">
          {{ submitButtonText }}
        </button>
      </form>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import { Component, Prop } from 'vue-property-decorator';

import {
  ValidatorOptions,
} from 'class-validator';

import User, { VALIDATION_GROUP_NAME_FORGOT } from '@/models/User';

const validatorOptions: ValidatorOptions = {
  groups: [VALIDATION_GROUP_NAME_FORGOT],
};

@Component
export default class ForgotPassword extends Vue {
  submitError: boolean = false

  successful: boolean = false

  user: User = new User({ validatorOptions })

  formTitle: string = 'Forgot password'

  formSubtitle: string = 'Please enter your email to reset your password.'

  emailPlaceholder: string = 'Your email'

  successMessage: string = 'We sent you an email with a link to reset your password.'

  errorMessage: string = 'We failed to send you a reset link.'

  userPropertyInvalid(property: string) {
    return this.submitError || (this.user.validating && this.user.propertyInvalid(property));
  }

  async submit() {
    try {
      await this.user.save();
      this.successful = true;
    } catch (e) {
      this.submitError = this.user.valid;
    }
  }

  get submitButtonText(): string {
    return this.user.loading ? 'Submitting...' : 'Submit';
  }
}
</script>

<style lang="scss" scoped>
@import '@/scss/colors';

.page--forgot {
  padding-top: 6rem;
  min-height: 50rem;
}

.page--forgot__form {
  max-width: 32rem;
  margin: 0 auto;
  padding: 0 1rem;
}

.page--forgot__form__text {
  color: $color-white;
}

.page--forgot__form__submitted {
  display: flex;
  flex-direction: column;
  justify-content: center;
  font-size: 1.5rem;
  line-height: 2.5rem;
  height: 22rem;
}

.page--forgot__title {
  font-size: 2.5rem;
  margin-bottom: 1.5rem;
  font-weight: 600;
}

.page--forgot__subtitle {
  font-size: 1.125rem;
  line-height: 2rem;
  margin-bottom: 3rem;
  font-weight: 500;
}

.page--forgot__form__inputs__input {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.page--forgot__form__inputs__input__label,
.page--forgot__form__inputs__input__input {
  text-align: left;
  width: 100%;
}

.page--forgot__form__inputs__input__label {
  color: $color-white;
}

.page--forgot__form__inputs__button--submit {
  margin-top: 1rem;
}

.page--forgot__form__inputs__error {
  padding-top: .5rem;
  color: $color-salmon;
  font-weight: 700;
}

.page--forgot__form__success {
  padding: 2rem;
  color: $color-white;
  font-weight: 700;
  font-size: 1.5rem;
}
</style>
