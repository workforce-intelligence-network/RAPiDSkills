import {
  IsEmail, MinLength,
} from 'class-validator';

import store from '@/store';

import ModelBase from '@/models/ModelBase';

export default class Session extends ModelBase {
  static jsonApiClassName = 'session'

  classDefinition: Function = Session

  @IsEmail()
  email: string = '';

  @MinLength(8, {
    message: 'Please enter a minimum of 8 characters',
  })
  password: string = '';

  async save() {
    const { meta } = await super.save();
    await store.dispatch('session/setToken', `${meta.tokenType} ${meta.accessToken}`);
  }
}

Session.registerWithJsonApi();
