export const updateUser = (state, user) => {
  state.user = user;
};

export const updateUserLoading = (state, loading) => {
  state.loading = loading;
};

export const updateUserPromise = (state, userPromise) => {
  state.userPromise = userPromise;
};

export const updateSavedStandards = (state, standards) => {
  state.savedStandards = standards;
};

export const updateSavedStandardsLoading = (state, loading) => {
  state.savedStandardsLoading = loading;
};

export const updateFavorites = (state, favorites) => {
  state.favorites = favorites;
};

export const updateFavoritesLoading = (state, loading) => {
  state.favoritesLoading = loading;
};
