import _get from 'lodash/get';

import OccupationStandard from '@/models/OccupationStandard';
import WorkProcess from '@/models/WorkProcess';
import Skill from '@/models/Skill';

export const fetchStandards = async (
  { commit, state, rootState },
  occupationId: number | undefined = _get(rootState, 'occupations.selectedOccupation.id'),
) => {
  if (occupationId !== state.occupationId) {
    commit('resetPagination');
  }

  if (!state.moreAvailable && state.list.length && occupationId === state.occupationId) {
    return;
  }

  try {
    commit('updateStandardsSearchOccupationId', occupationId);
    commit('updateStandardsSearchLoading', true);

    const { meta, model } = await OccupationStandard.getAll({
      occupationId,
      page: {
        number: state.page,
        size: state.pageSize,
      },
    });

    commit('updateStandardsSearchList', state.page <= 1 ? model : state.list.concat(model));

    const moreAvailable: boolean = Number(meta.currentPage) < Number(meta.totalPages);

    if (moreAvailable) {
      commit('incrementPage');
    }

    commit('updateMoreAvailable', moreAvailable);
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

export const refreshSelectedStandard = ({ state, commit }) => {
  commit('updateSelectedStandard', new OccupationStandard(state.selectedStandard));
};

export const deleteSkillFromSelectedStandard = async ({ dispatch, state }, { skill, workProcess }) => {
  await state.selectedStandard.removeSkill(skill, workProcess);

  dispatch('refreshSelectedStandard');
};

export const deleteWorkProcessFromSelectedStandard = async ({ dispatch, state }, workProcess: WorkProcess) => {
  await state.selectedStandard.removeWorkProcess(workProcess);

  dispatch('refreshSelectedStandard');
};

export const addNewWorkProcessToSelectedStandard = async ({ dispatch, state }) => {
  state.selectedStandard.addWorkProcess(new WorkProcess({
    title: '',
    occupationStandard: state.selectedStandard,
  }));

  dispatch('refreshSelectedStandard');
};

export const addNewSkillToSelectedStandard = async ({ dispatch, state }, workProcess?: WorkProcess) => {
  const freshSkill: Skill = new Skill({
    description: '',
    occupationStandard: state.selectedStandard,
    workProcess,
  });

  if (workProcess) {
    workProcess.addSkill(freshSkill);
  } else {
    state.selectedStandard.addSkill(freshSkill);
  }

  dispatch('refreshSelectedStandard');
};
