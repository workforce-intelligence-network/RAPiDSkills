import jsonApi from '@/utilities/api';

export const searchForOccupations = async ({ commit, state }, query: string = state.query) => {
  try {
    commit('updateOccupationsSearchLoading', true);
    commit('updateOccupationsSearchQuery', query);
    const { data } = await jsonApi.findAll('occupations', { q: query });
    commit('updateOccupationsSearchList', data);
  } catch (e) {
    console.error(e);
  }

  commit('updateOccupationsSearchLoading', false);
};

export function setSelectedOccupation({ commit, dispatch }, occupation?: any) {
  commit('updateSelectedOccupation', occupation);
  dispatch('standards/fetchStandards', undefined, { root: true });
}
