import {
  IsEmail, MinLength, Allow,
} from 'class-validator';

import _get from 'lodash/get';
import EqualsOtherProperty from '@/validation/EqualsOtherProperty';

import ModelBase from '@/models/ModelBase';

export const VALIDATION_GROUP_NAME_REGISTRATION = 'registration';
export const VALIDATION_GROUP_NAME_FORGOT = 'forgot';

export default class User extends ModelBase {
  constructor(user: Partial<User> = {}) {
    super(user);

    this.name = user.name || '';
    this.organizationName = user.organizationName || '';
    this.email = user.email || '';
    this.password = user.password || '';
  }

  @Allow()
  static jsonApiClassName = 'user'

  @Allow()
  classDefinition: Function = User

  @MinLength(1, {
    groups: [VALIDATION_GROUP_NAME_REGISTRATION],
  })
  name: string;

  @MinLength(1, {
    groups: [VALIDATION_GROUP_NAME_REGISTRATION],
  })
  organizationName: string;

  @IsEmail({}, {
    groups: [VALIDATION_GROUP_NAME_REGISTRATION, VALIDATION_GROUP_NAME_FORGOT],
  })
  email?: string;

  @MinLength(8, {
    message: 'Please enter a minimum of 8 characters',
    groups: [VALIDATION_GROUP_NAME_REGISTRATION],
  })
  password?: string;

  @MinLength(8, {
    message: 'Please enter a minimum of 8 characters',
    groups: [VALIDATION_GROUP_NAME_REGISTRATION],
  })
  @EqualsOtherProperty('password', {
    groups: [VALIDATION_GROUP_NAME_REGISTRATION],
  })
  passwordConfirmation?: string;
}

User.registerWithJsonApi();
