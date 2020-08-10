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
    page: 1,
    pageSize: 25,
    moreAvailable: true,
    occupationTitle: undefined,
    selectedStandard: undefined,
    selectedStandardLoading: false,
    selectedStandardPromise: undefined,
    duplicateStandard: undefined,
    duplicateStandardLoading: false,
  },
  mutations,
  actions,
  getters,
};
