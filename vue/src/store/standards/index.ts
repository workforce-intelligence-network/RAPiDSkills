import * as actions from './actions';
import * as mutations from './mutations';
import * as getters from './getters';

export default {
  namespaced: true,
  state: {
    list: [],
    loading: false,
    query: '',
    page: 1,
    occupationId: undefined,
    selectedStandard: undefined,
    selectedStandardLoading: false,
  },
  mutations,
  actions,
  getters,
};
