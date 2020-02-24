import * as actions from './actions';
import * as mutations from './mutations';
import * as getters from './getters';

export default {
  namespaced: true,
  state: {
    user: undefined,
    loading: false,
    savedStandards: [],
    savedStandardsLoading: false,
  },
  mutations,
  actions,
  getters,
};
