import * as actions from './actions';
import * as mutations from './mutations';
import * as getters from './getters';

export default {
  namespaced: true,
  state: {
    session: undefined,
    token: undefined,
    initialized: false,
  },
  mutations,
  actions,
  getters,
};
