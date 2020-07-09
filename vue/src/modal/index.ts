import Vue from 'vue';

export const MODAL_COMPONENT_NAME_DUPLICATE = 'duplicate-standard';

Vue.component(MODAL_COMPONENT_NAME_DUPLICATE, () => import(/* webpackChunkName: "duplicate" */ '@/views/Duplicate.vue'));

export const MODAL_COMPONENT_NAME_WELCOME = 'welcome';

Vue.component(MODAL_COMPONENT_NAME_WELCOME, () => import(/* webpackChunkName: "welcome" */ '@/views/Welcome.vue'));
