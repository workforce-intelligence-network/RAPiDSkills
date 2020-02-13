import _get from 'lodash/get';
import _isUndefined from 'lodash/isUndefined';

import { apiRaw } from '@/utilities/api';

import User from '@/models/User';
import OccupationStandard from '@/models/OccupationStandard';

export const getUser = async ({ state, commit, rootState }) => {
  const userId: number | string | undefined = _get(rootState, 'session.userId');
  if (_isUndefined(userId)) {
    return;
  }

  commit('updateUserLoading', true);

  const { model } = await User.get(userId);

  commit('updateUserLoading', false);
  commit('updateUser', model);
};

export const clearSavedStandards = async ({ commit }) => {
  commit('updateSavedStandards', []);
};

export const getSavedStandards = async ({ state, commit, rootState }) => {
  const userId: number | string | undefined = _get(rootState, 'session.userId');
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
