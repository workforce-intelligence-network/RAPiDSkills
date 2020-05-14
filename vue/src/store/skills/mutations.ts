import Vue from 'vue';

export const updateSkillsLoading = (state, loading: boolean) => {
  Vue.set(state, 'loading', loading);
};

export const updateSkillsQuery = (state, query: string) => {
  Vue.set(state, 'query', query);

  Vue.set(state, 'freshSearch', true);
};

export const updateSkillsList = (state, list: boolean) => {
  Vue.set(state, 'list', list);
};
