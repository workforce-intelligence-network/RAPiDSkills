import * as actions from './actions';
import * as mutations from './mutations';

export default {
  namespaced: true,
  state: {
    list: [],
    loading: false,
    query: '',
    page: 1,
    selectedStandard: undefined,
  },
  mutations,
  actions,
};
