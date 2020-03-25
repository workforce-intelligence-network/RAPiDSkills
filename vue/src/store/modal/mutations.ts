import Vue from 'vue';

/* eslint-disable import/prefer-default-export */
export const update = (state, component: ModalComponent) => {
  Vue.set(state, 'component', component);
};
