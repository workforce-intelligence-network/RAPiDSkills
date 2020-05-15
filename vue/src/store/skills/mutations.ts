import Vue from 'vue';

import Skill from '@/models/Skill';

export const updateSkillsLoading = (state, loading: boolean) => {
  Vue.set(state, 'loading', loading);
};

export const updateSkillsQuery = (state, query: string) => {
  Vue.set(state, 'query', query);
};

export const updateSkill = (state, skill?: Skill) => {
  Vue.set(state, 'skill', skill);
};

export const updateSkillsList = (state, list: Skill[]) => {
  Vue.set(state, 'list', list);
};
