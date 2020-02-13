import * as actions from './actions';
import * as mutations from './mutations';
// import * as getters from './getters';

export default {
  namespaced: true,
  state: {
    content: undefined,
  },
  mutations,
  actions,
  // getters,
};
