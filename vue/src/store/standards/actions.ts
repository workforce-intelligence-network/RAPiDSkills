import _get from 'lodash/get';
import _isUndefined from 'lodash/isUndefined';

import OccupationStandard, { OccupationStandardCollection } from '@/models/OccupationStandard';

export const fetchStandards = async (
  { commit, rootState },
  occupationId: number | undefined = _get(rootState, 'occupations.selectedOccupation.id'),
) => {
  try {
    commit('updateStandardsSearchLoading', true);

    const { model } = await OccupationStandardCollection.get({ occupationId }, OccupationStandard);

    commit('updateStandardsSearchList', model);
  } catch (e) {
    //
  }

  commit('updateStandardsSearchLoading', false);
};

export const getStandard = async ({ state, commit }, id: string | number | undefined = _get(state, 'selectedStandard.id')) => {
  if (_isUndefined(id)) {
    return;
  }

  try {
    commit('updateSelectedStandardLoading', true);

    const { model } = await OccupationStandard.get(Number(id));

    commit('updateSelectedStandard', model);
  } catch (e) {
    //
  }

  commit('updateSelectedStandardLoading', false);
};
