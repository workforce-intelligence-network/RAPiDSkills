import _some from 'lodash/some';

import OccupationStandard from '@/models/OccupationStandard';
import WorkProcess from '@/models/WorkProcess';
import Skill from '@/models/Skill';

export function standardsListEmptyAndNotLoading(state, getters) {
  return getters.standardsListEmpty && !state.loading;
}

export function standardsListEmpty(state, getters) {
  return !state.list.length;
}

export function selectedStandardLoading(state) {
  const standard: OccupationStandard | undefined = state.selectedStandard;

  return standard && (
    standard.loading
    || _some(standard.workProcesses, (workProcess: WorkProcess) => workProcess.loading || _some(workProcess.skills, (skill: Skill) => skill.loading))
    || _some(standard.skills, (skill: Skill) => skill.loading)
  );
}
