<template>
  <div class="page--signup">
    <div class="page--signup__form">
      <div class="page--signup__text page--signup__form__text page--signup__title" v-html="formTitle" />
      <div class="page--signup__text page--signup__form__text page--signup__subtitle" v-html="formSubtitle" />
      <form class="page--signup__form__inputs" @submit.prevent="submit">
        <div class="input input--spaced page--signup__form__inputs__input" :class="{ 'input--error': userPropertyInvalid('name') }">
          <label for="name" class="input__label page--signup__form__inputs__input__label">Name</label>
          <input type="name" id="name" name="name" :placeholder="namePlaceholder" class="input__input page--signup__form__inputs__input__input" v-model="user.name" />
        </div>
        <div class="input input--spaced page--signup__form__inputs__input" :class="{ 'input--error': userPropertyInvalid('organizationName') }">
          <label for="organizationName" class="input__label page--signup__form__inputs__input__label">Organization</label>
          <input type="organizationName" id="organizationName" name="organizationName" :placeholder="organizationNamePlaceholder" class="input__input page--signup__form__inputs__input__input" v-model="user.organizationName" />
        </div>
        <div class="input input--spaced page--signup__form__inputs__input" :class="{ 'input--error': userPropertyInvalid('email') }">
          <label for="email" class="input__label page--signup__form__inputs__input__label">Email</label>
          <input type="email" id="email" name="email" :placeholder="emailPlaceholder" class="input__input page--signup__form__inputs__input__input" v-model="user.email" />
        </div>
        <div class="input input--spaced page--signup__form__inputs__input" :class="{ 'input--error': userPropertyInvalid('password') }">
          <label for="password" class="input__label page--signup__form__inputs__input__label">Password</label>
          <input type="password" id="password" name="password" :placeholder="passwordPlaceholder" class="input__input page--signup__form__inputs__input__input" v-model="user.password" />
        </div>
        <div class="input input--spaced page--signup__form__inputs__input" :class="{ 'input--error': userPropertyInvalid('passwordConfirmation') }">
          <label for="passwordConfirmation" class="input__label page--signup__form__inputs__input__label">Confirm password</label>
          <input type="password" id="passwordConfirmation" name="passwordConfirmation" :placeholder="passwordConfirmationPlaceholder" class="input__input page--signup__form__inputs__input__input" v-model="user.passwordConfirmation" />
        </div>
        <div class="page--signup__form__inputs__error" v-if="submitError" v-html="errorMessage" />
        <button type="submit" class="button button--inverted page--signup__form__inputs__button--submit" :disabled="user.loading">
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

import User, { VALIDATION_GROUP_NAME_REGISTRATION } from '@/models/User';
import Session from '@/models/Session';

const validatorOptions: ValidatorOptions = {
  groups: [VALIDATION_GROUP_NAME_REGISTRATION],
};

@Component
export default class SignUp extends Vue {
  submitError: boolean = false

  user: User = new User({ validatorOptions })

  formTitle: string = 'Sign up'

  formSubtitle: string = 'Please enter your information to get started.'

  namePlaceholder: string = 'Your full name'

  organizationNamePlaceholder: string = 'Your organization\'s name'

  emailPlaceholder: string = 'Your email'

  passwordPlaceholder: string = 'Your password'

  passwordConfirmationPlaceholder: string = 'Your password, again'

  errorMessage: string = 'We failed to create your account.'

  userPropertyInvalid(property: string) {
    return this.submitError || (this.user.validating && this.user.propertyInvalid(property));
  }

  async submit() {
    try {
      const { data, meta } = await this.user.save();

      const session: Session = new Session({
        ...data.sessions[0],
        bearerToken: `${meta.tokenType} ${meta.accessToken}`,
      });

      await session.persist();

      this.$router.push({ name: 'standards' }); // TODO: define a "go to home" method?
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

.page--signup {
  padding-top: 6rem;
  min-height: 50rem;
}

.page--signup__form {
  max-width: 32rem;
  margin: 0 auto;
  padding: 0 1rem;
}

.page--signup__form__text {
  color: $color-white;
}

.page--signup__form__submitted {
  display: flex;
  flex-direction: column;
  justify-content: center;
  font-size: 1.5rem;
  line-height: 2.5rem;
  height: 22rem;
}

.page--signup__title {
  font-size: 2.5rem;
  margin-bottom: .5rem;
  font-weight: 600;
}

.page--signup__subtitle {
  font-size: 1.125rem;
  line-height: 2rem;
  margin-bottom: 1rem;
  font-weight: 500;
}

.page--signup__form__inputs__input {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.page--signup__form__inputs__input__label,
.page--signup__form__inputs__input__input {
  text-align: left;
  width: 100%;
}

.page--signup__form__inputs__input__label {
  color: $color-white;
}

.page--signup__form__inputs__button--submit {
  margin-top: 1rem;
}

.page--signup__form__inputs__error {
  padding-top: .5rem;
  color: $color-salmon;
  font-weight: 700;
}
</style>
