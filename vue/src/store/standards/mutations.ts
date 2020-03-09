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

export const updateSelectedStandardPromise = (state, promise: Promise<any>) => {
  state.selectedStandardPromise = promise;
};

export const updateStandardsSearchOccupationId = (state, occupationId: number | undefined) => {
  state.occupationId = occupationId;
};

export const resetPagination = (state) => {
  state.page = 1;
  state.moreAvailable = true;
};

export const incrementPage = (state) => {
  state.page = state.page + 1;
};

export const updateMoreAvailable = (state, moreAvailable: boolean) => {
  state.moreAvailable = moreAvailable;
};

export const updateDuplicateStandard = (state, duplicateStandard) => {
  state.duplicateStandard = duplicateStandard;
};

export const updateDuplicateStandardLoading = (state, duplicateStandardLoading) => {
  state.duplicateStandardLoading = duplicateStandardLoading;
};
