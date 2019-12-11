import * as actions from './actions';
import * as mutations from './mutations';
import * as getters from './getters';

export default {
  namespaced: true,
  state: {
    list: [],
    loading: false,
    query: '',
    freshSearch: true,
    page: 1,
    selectedOccupation: undefined,
  },
  mutations,
  actions,
  getters,
};
