import _get from 'lodash/get';

import OccupationStandard from '@/models/OccupationStandard';
import WorkProcess from '@/models/WorkProcess';

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

export const duplicateSelectedStandard = async ({ state, commit }) => {
  try {
    const { model } = await (state.selectedStandard as OccupationStandard).clone();
    commit('updateSelectedStandard', model);
  } catch (e) {
    // console.log('duplicate error', e);
  }
};

export const editSelectedStandard = ({ state, commit }, editing: boolean = !state.editing) => {
  commit('updateSelectedStandardEditing', editing);
};

export const deleteSkillFromSelectedStandard = async ({ commit, state }, { skill, workProcess }) => {
  await state.selectedStandard.removeSkill(skill, workProcess);

  commit('updateSelectedStandard', state.selectedStandard);
};

export const deleteWorkProcessFromSelectedStandard = async ({ commit, state }, workProcess: WorkProcess) => {
  await state.selectedStandard.removeWorkProcess(workProcess);

  commit('updateSelectedStandard', state.selectedStandard);
};
