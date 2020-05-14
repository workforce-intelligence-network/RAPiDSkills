import * as actions from './actions';
import * as mutations from './mutations';
import * as getters from './getters';

export default {
  namespaced: true,
  state: {
    loading: false,
    list: [],
    query: '',
    freshSearch: false,
  },
  mutations,
  actions,
  getters,
};
