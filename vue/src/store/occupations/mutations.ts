import _isFunction from 'lodash/isFunction';

import Vue from 'vue';

export const updateOccupationsSearchLoading = (state, loading: boolean) => {
  Vue.set(state, 'loading', loading);
};

export const updateOccupationsSearchQuery = (state, query: string) => {
  Vue.set(state, 'query', query);
  Vue.set(state, 'freshSearch', true);
};

export const updateOccupationsSearchList = (state, list: []) => {
  Vue.set(state, 'list', list);
};

export const hideSkillsList = (state) => {
  Vue.set(state, 'freshSearch', false);
};
