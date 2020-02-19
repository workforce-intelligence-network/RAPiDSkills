import _get from 'lodash/get';
import _isUndefined from 'lodash/isUndefined';

import { apiRaw } from '@/utilities/api';

import User from '@/models/User';
import OccupationStandard from '@/models/OccupationStandard';

export const clear = async ({ commit, dispatch }, user: User) => {
  commit('updateUser');
  dispatch('clearSavedStandards');
};

export const setUser = async ({ commit }, user: User) => {
  commit('updateUser', user);
};

export const getUser = async ({ state, commit, rootState }) => {
  const sessionId: number | string | undefined = _get(rootState, 'session.session.id');
  if (_isUndefined(sessionId)) {
    return;
  }

  commit('updateUserLoading', true);

  const response = await apiRaw.get(`/sessions/${sessionId}/user`);
  if (!_get(response, 'data.data.attributes')) {
    console.error('Invalid response for session user GET');
    return;
  }

  const user: User = new User({
    id: response.data.data.id,
    ...response.data.data.attributes,
  });

  commit('updateUserLoading', false);
  commit('updateUser', user);
};

export const clearSavedStandards = async ({ commit }) => {
  commit('updateSavedStandards', []);
};

export const getSavedStandards = async ({ state, commit }) => {
  const userId: number | string | undefined = _get(state, 'user.id');
  if (_isUndefined(userId)) {
    return;
  }

  if (state.savedStandards.length) {
    return;
  }

  try {
    commit('updateSavedStandardsLoading', true);

    const response = await apiRaw.get(`/users/${userId}/relationships/occupation_standards`);

    const standards: OccupationStandard[] = (await Promise.all((response.data.data as [])
      .map(async (unsyncedOccupation: any) => OccupationStandard.get(unsyncedOccupation.id))) as []
    ).map((jsonApiResponse: any) => jsonApiResponse.model);

    commit('updateSavedStandards', standards);
  } catch (e) {
    //
  }

  commit('updateSavedStandardsLoading', false);
};
