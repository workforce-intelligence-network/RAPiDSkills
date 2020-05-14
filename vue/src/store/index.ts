import Vue from 'vue';
import Vuex from 'vuex';

import user from '@/store/user';
import tours from '@/store/tours';
import modal from '@/store/modal';
import skills from '@/store/skills';
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
    tours,
    modal,
    skills,
    session,
    standards,
    occupations,
  },
});
