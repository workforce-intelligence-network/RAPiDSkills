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

    const promise = Occupation.getAll({ q: query });
    commit('updateOccupationsSearchPromise', promise);
    const { model } = await promise;

    // Alternative to cancelable promise
    if (promise !== state.promise) {
      return;
    }

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

export function hideOccupationsList({ commit }) {
  commit('hideOccupationsList');
}
