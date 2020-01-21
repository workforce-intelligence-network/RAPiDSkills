import Occupation from '@/models/Occupation';

export const searchForOccupations = async ({ commit, state }, query: string) => {
  commit('updateSelectedOccupation');

  if (query === state.query && state.list.length) {
    commit('updateOccupationsSearchQuery', query);
    return;
  }

  try {
    commit('updateOccupationsSearchLoading', true);
    commit('updateOccupationsSearchQuery', query);
    const { model } = await Occupation.getAll({ q: query });
    commit('updateOccupationsSearchList', model);
    commit('updateOccupationsSearchLoading', false);
  } catch (e) {
    //
  }
};

export function setSelectedOccupation({ commit, dispatch }, occupation?: any) {
  commit('updateOccupationsSearchQuery', '');
  commit('updateSelectedOccupation', occupation);
  dispatch('standards/fetchStandards', undefined, { root: true });
}

export function hideOccupationsList({ commit }) {
  commit('hideOccupationsList');
}
