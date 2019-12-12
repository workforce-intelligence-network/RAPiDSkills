import axios from 'axios';

import jsonApi from '@/utilities/api';

export const setOccupationSearchQuery = async ({ commit, state }, query: string = state.query) => {
  commit('updateOccupationsSearchQuery', query);
};

export const searchForOccupations = async ({ commit, state }, query: string = state.query) => {
  try {
    commit('resetOccupationsSearchCancelToken');
    commit('updateOccupationsSearchLoading', true);
    commit('updateOccupationsSearchQuery', query);
    const { data } = await jsonApi.findAll('occupations', { q: query, cancelToken: state.cancelToken });
    commit('updateOccupationsSearchList', data);
    commit('updateOccupationsSearchLoading', false);
  } catch (e) {
    //
  }
};

export function setSelectedOccupation({ commit, dispatch }, occupation?: any) {
  commit('updateSelectedOccupation', occupation);
  dispatch('standards/fetchStandards', undefined, { root: true });
}
