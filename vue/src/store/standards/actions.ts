import _get from 'lodash/get';
import _uniqBy from 'lodash/uniqBy';
import _isUndefined from 'lodash/isUndefined';

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

export const getStandard = async ({ state, commit }, id: string | number | undefined = _get(state, 'selectedStandard.id')) => {
  if (_isUndefined(id)) {
    return;
  }

  try {
    commit('updateSelectedStandardLoading', true);

    const { data } = await jsonApi.find('occupation_standards', Number(id));

    const standard = data.id === _get(state, 'selectedStandard.id') ? Object.assign({}, state.selectedStandard, data) : data;

    standard.workProcesses = _uniqBy(standard.workProcesses, (workProcess: any) => workProcess.id);

    commit('updateSelectedStandard', standard);
  } catch (e) {
    //
  }

  commit('updateSelectedStandardLoading', false);
};
