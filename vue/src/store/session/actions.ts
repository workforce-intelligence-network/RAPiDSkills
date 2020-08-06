import _isUndefined from 'lodash/isUndefined';

import Vue from 'vue';

import moment from 'moment';
import storage from '@/storage';

import jsonApi, { apiRaw } from '@/utilities/api';

import Session from '@/models/Session';

const SESSION_EXPIRATION_AMOUNT = 4;
const SESSION_EXPIRATION_UNITS = 'hours';

export const setSession = async ({ commit, dispatch }, session: Session) => {
  const expirationDateTime = moment().add(SESSION_EXPIRATION_AMOUNT, SESSION_EXPIRATION_UNITS);

  commit('setSession', session);

  await storage.setItem('sessionId', session.id);
  await storage.setItem('sessionToken', session.bearerToken);
  await storage.setItem('sessionTokenExpiration', expirationDateTime.toISOString());

  return dispatch('initializeSession');
};

export const initializeSession = async ({ dispatch, commit }) => {
  const token: string | null | undefined = await storage.getItem('sessionToken');
  const sessionId: string | number | null | undefined = await storage.getItem('sessionId');

  if (!token || _isUndefined(sessionId)) {
    return dispatch('expireToken');
  }

  const expirationMomentString: string | null | undefined = await storage.getItem('sessionTokenExpiration');

  const expirationDateTime: moment.Moment = moment(expirationMomentString);

  if (!expirationMomentString || moment().isAfter(expirationDateTime)) {
    return dispatch('expireToken');
  }

  commit('setSession', new Session({
    id: sessionId as string | number | undefined,
  }));

  commit('setToken', token);

  apiRaw.defaults.headers.common.Authorization = token;
  jsonApi.axios.defaults.headers.common.Authorization = token;

  // TODO: finish UI for token expiring
  // const millisecondsUntilExpiration: number = expirationDateTime.diff(moment(), 'milliseconds');

  // setTimeout(() => dispatch('expireToken'), millisecondsUntilExpiration);

  return true;
};

export const expireToken = async ({ state, commit }) => {
  try {
  // eslint-disable-next-line prefer-destructuring
    const session: Session | undefined = state.session;
    if (session) {
      await jsonApi
        .one(session.staticType.jsonApiClassName, session.id)
        .destroy();
    }
  } catch (e) {
    (Vue as any).rollbar.error(e);
  }

  // TODO: if initialized, allow to re-login or persist state before wiping out token/state
  // if (state.initialized) {
  //   alert('Token expired');
  // }

  commit('setToken');

  await storage.setItem('sessionToken', undefined);
  await storage.setItem('sessionTokenExpiration', undefined);

  delete apiRaw.defaults.headers.common.Authorization;
  delete jsonApi.axios.defaults.headers.common.Authorization;

  commit('setSession');
  await storage.setItem('sessionId', undefined);
};
