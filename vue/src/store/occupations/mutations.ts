import axios from 'axios';

import _isFunction from 'lodash/isFunction';

export const resetOccupationsSearchCancelToken = (state) => {
  if (_isFunction(state.cancel)) {
    state.cancel();
  }

  state.cancelToken = new axios.CancelToken((cancel) => {
    state.cancel = cancel;
  });
};

export const updateOccupationsSearchLoading = (state, loading: boolean) => {
  state.loading = loading;
};

export const updateOccupationsSearchQuery = (state, query: string) => {
  state.query = query;
  state.freshSearch = true;
};

export const updateOccupationsSearchList = (state, list: []) => {
  state.list = list;
};

export const updateSelectedOccupation = (state, occupation: object) => {
  state.selectedOccupation = occupation;
  state.freshSearch = false;
};
