export const updateUser = (state, user) => {
  state.user = user;
};

export const updateUserLoading = (state, loading) => {
  state.loading = loading;
};

export const updateSavedStandards = (state, standards) => {
  state.savedStandards = standards;
};

export const updateSavedStandardsLoading = (state, loading) => {
  state.savedStandardsLoading = loading;
};
