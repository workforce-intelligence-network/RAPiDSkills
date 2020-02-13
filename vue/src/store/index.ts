import Vue from 'vue';
import Vuex from 'vuex';

import user from '@/store/user';
import modal from '@/store/modal';
import session from '@/store/session';
import standards from '@/store/standards';
import occupations from '@/store/occupations';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
  },
  mutations: {
  },
  actions: {
  },
  modules: {
    user,
    modal,
    session,
    standards,
    occupations,
  },
});
