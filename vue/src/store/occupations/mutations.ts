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

export const updateSelectedOccupation = (state, occupation: object) => {
  Vue.set(state, 'selectedOccupation', occupation);
  Vue.set(state, 'freshSearch', false);
};

export const hideOccupationsList = (state) => {
  Vue.set(state, 'freshSearch', false);
};
