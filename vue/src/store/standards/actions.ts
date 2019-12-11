import jsonApi from '@/helpers/api';

export const searchForStandards = async ({ commit, state }, query: string = state.query) => {
  try {
    commit('updateStandardsSearchQuery', query);
    const { data } = await jsonApi.findAll('occupation_standards', { query });
    commit('updateStandardsSearchList', data);
  } catch (e) {
    console.error(e);
  }
};

export const getStandard = async ({ state }, id: string | number) => {

};
