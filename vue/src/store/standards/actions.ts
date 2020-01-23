import _get from 'lodash/get';

import OccupationStandard from '@/models/OccupationStandard';

export const fetchStandards = async (
  { commit, state, rootState },
  occupationId: number | undefined = _get(rootState, 'occupations.selectedOccupation.id'),
) => {
  if (state.list.length && occupationId === state.occupationId) {
    return;
  }

  try {
    commit('updateStandardsSearchOccupationId', occupationId);
    commit('updateStandardsSearchLoading', true);

    const { model } = await OccupationStandard.getAll({ occupationId });

    commit('updateStandardsSearchList', model);
  } catch (e) {
    //
  }

  commit('updateStandardsSearchLoading', false);
};

export const getStandard = async ({ state, commit }, id: string | number) => {
  if (id === _get(state, 'selectedStandard.id')) {
    return;
  }

  try {
    commit('updateSelectedStandard');

    commit('updateSelectedStandardLoading', true);

    const { model } = await OccupationStandard.get(Number(id));

    commit('updateSelectedStandard', model);
  } catch (e) {
    //
  }

  commit('updateSelectedStandardLoading', false);
};
