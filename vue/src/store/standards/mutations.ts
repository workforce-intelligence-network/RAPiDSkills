export const updateStandardsSearchLoading = (state, loading: boolean) => {
  state.loading = loading;
};

export const updateStandardsSearchList = (state, list: []) => {
  state.list = list;
};

export const updateSelectedStandard = (state, standard: object) => {
  state.selectedStandard = standard;
};

export const updateSelectedStandardLoading = (state, loading: boolean) => {
  state.selectedStandardLoading = loading;
};

export const updateSelectedStandardEditing = (state, editing: boolean) => {
  state.selectedStandardEditing = editing;
};

export const updateStandardsSearchOccupationId = (state, occupationId: number | undefined) => {
  state.occupationId = occupationId;
};
