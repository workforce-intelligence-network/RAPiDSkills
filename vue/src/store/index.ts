import Vue from 'vue';
import Vuex from 'vuex';

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
    standards,
    occupations,
  },
});
