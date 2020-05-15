import _isUndefined from 'lodash/isUndefined';

import Skill from '@/models/Skill';

export const skillActive = state => (skill?: Skill) => {
  const skillInQuestion: Skill | undefined = skill;
  const skillInState: Skill | undefined = state.skill;
  return !_isUndefined(skillInQuestion)
    && !_isUndefined(skillInState)
    && skillInState!.synced
    && skillInQuestion!.synced
    && skillInState!.id === skillInQuestion!.id;
};

export const showSkillsSearchList = (state, getters) => (skill?: Skill) => {
  if (getters.skillActive(skill)) {
    console.log('skill matches, showing?', state.skill, (!!state.list.length || state.loading));
  }
  return getters.skillActive(skill) && (!!state.list.length || state.loading);
};
