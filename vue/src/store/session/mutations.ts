import Vue from 'vue';

export const setSession = (state, session) => {
  Vue.set(state, 'session', session);
};

export const setToken = (state, token?: string) => {
  Vue.set(state, 'token', token);
  Vue.set(state, 'initialized', true);
};
