<template>
  <div class="page--follow">
    <div class="page--follow__form">
      <div class="page--follow__text page--follow__form__text page--follow__title">
        Follow Us
      </div>
      <div class="page--follow__text page--follow__form__text page--follow__subtitle">
        Please enter your information so that we can keep you up to date on what is happening with RapidSkills.
      </div>
      <div class="page--follow__form__submitted page--follow__form__text" v-if="!loading && successful">
        <div>Your information has been submitted!</div>
        <div>Keep your eyes peeled for some updates.</div>
      </div>
      <form class="page--follow__form__inputs" @submit="submitUser($event)" v-if="!successful">
        <div class="input input--spaced page--follow__form__inputs__input" :class="{ 'input--error': submitted && !user.parameterValid('name') }">
          <label for="name" class="input__label page--follow__form__inputs__input__label">Name</label>
          <input type="text" id="name" name="name" placeholder="Your full name" class="input__input page--follow__form__inputs__input__input" v-model="user.name" />
        </div>
        <div class="input input--spaced page--follow__form__inputs__input" :class="{ 'input--error': submitted && !user.parameterValid('email') }">
          <label for="email" class="input__label page--follow__form__inputs__input__label">Email</label>
          <input type="email" id="email" name="email" placeholder="Your email" class="input__input page--follow__form__inputs__input__input" v-model="user.email" />
        </div>
        <div class="input input--spaced page--follow__form__inputs__input" :class="{ 'input--error': submitted && !user.parameterValid('organizationName') }">
          <label for="organization" class="input__label page--follow__form__inputs__input__label">Organization</label>
          <input type="text" id="organization" name="organization" placeholder="Your organization's name" class="input__input page--follow__form__inputs__input__input" v-model="user.organizationName" />
        </div>
        <button type="submit" class="button button--inverted page--follow__form__inputs__button--submit" :disabled="loading">
          {{ loading ? 'Submitting...' : 'Submit' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import axios from 'axios';

import {
  IsEmail, MinLength, validate, validateSync, ValidationError, IsDefined,
} from 'class-validator';

const apiV1 = axios.create({
  baseURL: 'http://www.rapidskills.org/v1',
});

class CreateUserUser {
  @MinLength(1)
  name: string = '';

  @IsEmail()
  email: string = '';

  @MinLength(1)
  organizationName: string = '';

  parameterValid(parameter: string): boolean {
    const paramErrors: ValidationError[] = validateSync(this);
    return !paramErrors.filter(error => error.property === parameter).length;
  }
}

const createUser = async (user: CreateUserUser) => apiV1.post('users', {
  name: user.name,
  email: user.email,
  organization_name: user.organizationName,
});

export default {
  methods: {
    async userValid(): Promise<boolean> {
      const errors: ValidationError[] = await validate((this as any).user);
      return !errors.length;
    },
    async submitUser(event: any) {
      event.preventDefault();

      (this as any).submitted = true;
      (this as any).invalid = !(await this.userValid());

      if ((this as any).invalid) {
        return;
      }

      (this as any).submitted = false;
      (this as any).submitError = false;
      (this as any).loading = true;

      try {
        const response = await createUser((this as any).user);
        (this as any).successful = true;
      } catch (e) {
        (this as any).submitError = true;
      }

      (this as any).loading = false;
    },
  },
  data() {
    return {
      submitted: false,
      successful: false,
      invalid: false,
      submitError: false,
      loading: false,
      user: new CreateUserUser(),
    };
  },
};
</script>

<style lang="scss">
.page--follow {
  padding-top: 5rem;
}

.page--follow__form {
  max-width: 32rem;
  margin: 0 auto;
  padding: 0 1rem;
}

.page--follow__form__text {
  color: white;
}

.page--follow__form__submitted {
  display: flex;
  flex-direction: column;
  justify-content: center;
  font-size: 1.5rem;
  line-height: 2.5rem;
  height: 22rem;
}

.page--follow__title {
  font-size: 2.5rem;
  margin-bottom: 1.5rem;
  font-weight: 600;
}

.page--follow__subtitle {
  font-size: 1.125rem;
  line-height: 2rem;
  margin-bottom: 3rem;
  font-weight: 500;
}

.page--follow__form__inputs__input {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.page--follow__form__inputs__input__label,
.page--follow__form__inputs__input__input {
  text-align: left;
  width: 100%;
}

.page--follow__form__inputs__input__label {
  color: white;
}

.page--follow__form__inputs__button--submit {
  margin-top: 2rem;
}
</style>
