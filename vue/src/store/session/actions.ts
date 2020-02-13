import moment from 'moment';
import storage from '@/storage';

import jsonApi, { apiRaw } from '@/utilities/api';

import User from '@/models/User';


const SESSION_EXPIRATION_AMOUNT = 4;
const SESSION_EXPIRATION_UNITS = 'hours';

export const setUser = async ({ commit }, user: User) => {
  await storage.setItem('userId', user.id);
};

export const setToken = async ({ dispatch }, token: string) => {
  const expirationDateTime = moment().add(SESSION_EXPIRATION_AMOUNT, SESSION_EXPIRATION_UNITS);

  await storage.setItem('sessionToken', token);
  await storage.setItem('sessionTokenExpiration', expirationDateTime.toISOString());

  return dispatch('initializeSession');
};

export const initializeSession = async ({ dispatch, commit }) => {
  const token: string | undefined = await storage.getItem('sessionToken');
  if (!token) {
    return dispatch('expireToken');
  }

  const expirationMomentString: string | undefined = await storage.getItem('sessionTokenExpiration');

  const expirationDateTime: moment.Moment = moment(expirationMomentString);

  if (!expirationMomentString || moment().isAfter(expirationDateTime)) {
    return dispatch('expireToken');
  }

  commit('setToken', token);

  apiRaw.defaults.headers.common.Authorization = token;
  jsonApi.axios.defaults.headers.common.Authorization = token;

  // TODO: finish UI for token expiring
  // const millisecondsUntilExpiration: number = expirationDateTime.diff(moment(), 'milliseconds');

  // setTimeout(() => dispatch('expireToken'), millisecondsUntilExpiration);

  const userId: string | number | undefined = await storage.getItem('userId');

  commit('setUserId', userId);

  return true;
};

export const expireToken = async ({ state, commit }) => {
  // TODO: if initialized, allow to re-login or persist state before wiping out token/state
  // if (state.initialized) {
  //   alert('Token expired');
  // }

  commit('setToken');

  await storage.setItem('sessionToken', undefined);
  await storage.setItem('sessionTokenExpiration', undefined);
  await storage.setItem('userId', undefined);

  delete apiRaw.defaults.headers.common.Authorization;
  delete jsonApi.axios.defaults.headers.common.Authorization;
};
