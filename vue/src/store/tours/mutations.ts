import Vue from 'vue';

export const showTourStep = (state, tourStepVisibleId: string) => {
  Vue.set(state, tourStepVisibleId, true);
};

export const hideTourStep = (state, tourStepVisibleId: string) => {
  Vue.set(state, tourStepVisibleId, false);
};
