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
    selectedOccupation: undefined,
    cancel: undefined,
    cancelToken: undefined,
  },
  mutations,
  actions,
  getters,
};
