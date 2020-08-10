import Vue from 'vue';

export const updateStandardsSearchLoading = (state, loading: boolean) => {
  Vue.set(state, 'loading', loading);
};

export const updateStandardsSearchList = (state, list: []) => {
  Vue.set(state, 'list', list);
};

export const updateSelectedStandard = (state, standard: object) => {
  Vue.set(state, 'selectedStandard', standard);
};

export const updateSelectedStandardLoading = (state, loading: boolean) => {
  Vue.set(state, 'selectedStandardLoading', loading);
};

export const updateSelectedStandardPromise = (state, promise: Promise<any>) => {
  Vue.set(state, 'selectedStandardPromise', promise);
};

export const updateStandardsSearchOccupationTitle = (state, occupationTitle: string | undefined) => {
  Vue.set(state, 'occupationTitle', occupationTitle);
};

export const resetPagination = (state) => {
  Vue.set(state, 'page', 1);
  Vue.set(state, 'moreAvailable', true);
};

export const incrementPage = (state) => {
  Vue.set(state, 'page', state.page + 1);
};

export const updateMoreAvailable = (state, moreAvailable: boolean) => {
  Vue.set(state, 'moreAvailable', moreAvailable);
};

export const updateDuplicateStandard = (state, duplicateStandard) => {
  Vue.set(state, 'duplicateStandard', duplicateStandard);
};

export const updateDuplicateStandardLoading = (state, duplicateStandardLoading) => {
  Vue.set(state, 'duplicateStandardLoading', duplicateStandardLoading);
};

export const updateStandardsSearchPromise = (state, promise) => {
  Vue.set(state, 'promise', promise);
};
