import Occupation, { OccupationCollection } from '@/models/Occupation';

export const setOccupationSearchQuery = async ({ commit, state }, query: string = state.query) => {
  commit('updateOccupationsSearchQuery', query);
};

export const searchForOccupations = async ({ commit, state }, query: string = state.query) => {
  try {
    commit('updateOccupationsSearchLoading', true);
    commit('updateOccupationsSearchQuery', query);
    const { model } = await OccupationCollection.get({ q: query }, Occupation);
    commit('updateOccupationsSearchList', model);
    commit('updateOccupationsSearchLoading', false);
  } catch (e) {
    //
  }
};

export function setSelectedOccupation({ commit, dispatch }, occupation?: any) {
  commit('updateSelectedOccupation', occupation);
  dispatch('standards/fetchStandards', undefined, { root: true });
}
