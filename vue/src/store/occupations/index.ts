import * as actions from './actions';
import * as mutations from './mutations';
import * as getters from './getters';

export default {
  namespaced: true,
  state: {
    list: [],
    promise: undefined,
    loading: false,
    query: '',
    freshSearch: false,
    selectedOccupation: undefined,
  },
  mutations,
  actions,
  getters,
};
