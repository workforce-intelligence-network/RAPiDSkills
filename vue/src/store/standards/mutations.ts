export const updateStandardsSearchLoading = (state, loading: boolean) => {
  state.loading = loading;
};

export const updateStandardsSearchList = (state, list: []) => {
  state.list = list;
};

export const updateSelectedStandard = (state, standard) => {
  state.selectedStandard = standard;
};
