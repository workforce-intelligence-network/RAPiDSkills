import _get from 'lodash/get';

import {
  IsEmail, MinLength, ValidatorOptions,
} from 'class-validator';

import store from '@/store';

import ModelBase from '@/models/ModelBase';

import EqualsOtherProperty from '@/validation/EqualsOtherProperty';

export const VALIDATION_GROUP_NAME_LOGIN = 'login';
export const VALIDATION_GROUP_NAME_RESET = 'reset';

export default class Session extends ModelBase {
  constructor(session: Partial<Session> = {}) {
    super(session);

    this.resetToken = session.resetToken || '';
    this.email = session.email || '';
    this.password = session.password || '';
  }

  static jsonApiClassName = 'session'

  classDefinition: Function = Session

  @IsEmail({}, {
    groups: [VALIDATION_GROUP_NAME_LOGIN],
  })
  email: string;

  @MinLength(8, {
    message: 'Please enter a minimum of 8 characters',
    groups: [VALIDATION_GROUP_NAME_LOGIN, VALIDATION_GROUP_NAME_RESET],
  })
  password: string;

  @MinLength(8, {
    message: 'Please enter a minimum of 8 characters',
    groups: [VALIDATION_GROUP_NAME_RESET],
  })
  @EqualsOtherProperty('password', {
    groups: [VALIDATION_GROUP_NAME_RESET],
  })
  passwordConfirmation?: string;

  @MinLength(1, {
    groups: [VALIDATION_GROUP_NAME_RESET],
  })
  resetToken: string;

  async save() {
    const { meta } = await super.save();
    await store.dispatch('session/setToken', `${meta.tokenType} ${meta.accessToken}`);
  }
}

Session.registerWithJsonApi();
