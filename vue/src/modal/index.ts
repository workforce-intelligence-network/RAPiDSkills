import Vue from 'vue';

// eslint-disable-next-line import/prefer-default-export
export const duplicateComponentName = 'duplicate-standard';

Vue.component(duplicateComponentName, () => import(/* webpackChunkName: "duplicate" */ '@/views/Duplicate.vue'));
