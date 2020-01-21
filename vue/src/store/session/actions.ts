import moment from 'moment';
import storage from '@/storage';

import jsonApi from '@/utilities/api';

const SESSION_EXPIRATION_AMOUNT = 4;
const SESSION_EXPIRATION_UNITS = 'hours';

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

  jsonApi.axios.defaults.headers.common.Authorization = token;

  // TODO: finish UI for token expiring
  // const millisecondsUntilExpiration: number = expirationDateTime.diff(moment(), 'milliseconds');

  // setTimeout(() => dispatch('expireToken'), millisecondsUntilExpiration);

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

  delete jsonApi.axios.defaults.headers.common.Authorization;
};
