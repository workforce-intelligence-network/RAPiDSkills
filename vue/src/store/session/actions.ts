import _isUndefined from 'lodash/isUndefined';

import moment from 'moment';
import storage from '@/storage';

import jsonApi, { apiRaw } from '@/utilities/api';

import Session from '@/models/Session';

const SESSION_EXPIRATION_AMOUNT = 4;
const SESSION_EXPIRATION_UNITS = 'hours';

export const setSession = async ({ commit }, session: Session) => {
  commit('setSession', session);
  await storage.setItem('sessionId', session.id);
};

export const setToken = async ({ dispatch }, token: string) => {
  const expirationDateTime = moment().add(SESSION_EXPIRATION_AMOUNT, SESSION_EXPIRATION_UNITS);

  await storage.setItem('sessionToken', token);
  await storage.setItem('sessionTokenExpiration', expirationDateTime.toISOString());

  return dispatch('initializeSession');
};

export const initializeSession = async ({ dispatch, commit }) => {
  const token: string | undefined = await storage.getItem('sessionToken');
  const sessionId: string | number | undefined = await storage.getItem('sessionId');

  if (!token || _isUndefined(sessionId)) {
    return dispatch('expireToken');
  }

  const expirationMomentString: string | undefined = await storage.getItem('sessionTokenExpiration');

  const expirationDateTime: moment.Moment = moment(expirationMomentString);

  if (!expirationMomentString || moment().isAfter(expirationDateTime)) {
    return dispatch('expireToken');
  }

  commit('setSession', new Session({
    id: sessionId,
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
    console.log('Failed to delete session');
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
