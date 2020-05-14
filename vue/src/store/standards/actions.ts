import _get from 'lodash/get';

import Vue from 'vue';

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

    const selectedStandardPromise: Promise<any> = OccupationStandard.get(id);

    commit('updateSelectedStandardPromise', selectedStandardPromise);

    const { model } = await selectedStandardPromise;

    commit('updateSelectedStandard', model);
  } catch (e) {
    //
  }

  commit('updateSelectedStandardLoading', false);
};

export const persistStandardDuplicate = async ({ state, commit }) => {
  try {
    const { model } = await (state.duplicateStandard as OccupationStandard).persistDuplicate();
    commit('updateDuplicateStandard', model);
    commit('updateSelectedStandard', model);
  } catch (e) {
    (Vue as any).rollbar.error(e);
  }
};

export const refreshSelectedStandard = ({ state, commit, dispatch }) => {
  commit('updateSelectedStandard', new OccupationStandard(state.selectedStandard));
  dispatch('user/clearSavedStandards', undefined, { root: true });
};

export const deleteSkillFromSelectedStandard = async ({ dispatch, state }, { skill, workProcess, replacement }) => {
  await state.selectedStandard.removeOrReplaceSkill(skill, workProcess, replacement);

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

export const replaceSkill = async ({ dispatch }, { skill, replacement, workProcess }) => {
  dispatch('deleteSkillFromSelectedStandard');
};

export const updateStandardToDuplicate = ({ commit }, standard: OccupationStandard) => {
  commit('updateDuplicateStandard', new OccupationStandard(standard));
};

export const ensureDuplicateStandard = async ({ state, commit }, standardId: string | number) => {
  // eslint-disable-next-line prefer-destructuring
  const duplicateStandard: OccupationStandard | undefined = state.duplicateStandard;

  if (duplicateStandard && String(duplicateStandard.id) === String(standardId) && duplicateStandard.title) {
    return;
  }

  try {
    commit('updateDuplicateStandard');

    commit('updateDuplicateStandardLoading', true);

    const { model } = await OccupationStandard.get(standardId);

    commit('updateDuplicateStandard', model);
  } catch (e) {
    //
  }

  commit('updateDuplicateStandardLoading', false);
};
