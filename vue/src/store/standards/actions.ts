import _get from 'lodash/get';

import jsonApi from '@/utilities/api';

export const fetchStandards = async (
  { commit, rootState },
  occupationId: number | undefined = _get(rootState, 'occupations.selectedOccupation.id'),
) => {
  try {
    commit('updateStandardsSearchLoading', true);

    const { data } = await jsonApi.findAll('occupation_standards', { occupationId });

    commit('updateStandardsSearchList', data);
  } catch (e) {
    //
  }

  commit('updateStandardsSearchLoading', false);
};

export const getStandard = async ({ state }, id: string | number) => {

};
