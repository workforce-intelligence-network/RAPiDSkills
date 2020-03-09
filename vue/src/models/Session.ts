import _get from 'lodash/get';

import {
  IsEmail, MinLength,
} from 'class-validator';

import store from '@/store';

import ModelBase from '@/models/ModelBase';
import User from '@/models/User';

import EqualsOtherProperty from '@/validation/EqualsOtherProperty';

export const VALIDATION_GROUP_NAME_LOGIN = 'login';
export const VALIDATION_GROUP_NAME_RESET = 'reset';

export default class Session extends ModelBase {
  constructor(session: Partial<Session> = {}) {
    super(session);

    this.resetToken = session.resetToken || '';
    this.email = session.email || '';
    this.password = session.password || '';
    this.user = (session.user && session.user instanceof User) ? session.user : new User(session.user || {});
    this.bearerToken = session.bearerToken || '';
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

  user: User

  bearerToken: string

  async save() {
    const response = await super.save();
    const { data, meta } = response;

    const session: Session = new Session({
      ...data,
      bearerToken: `${meta.tokenType} ${meta.accessToken}`,
    });

    return session.persist();
  }

  async persist() {
    await store.dispatch('user/setUser', this.user);
    await store.dispatch('session/setSession', this);
  }
}

Session.registerWithJsonApi();
