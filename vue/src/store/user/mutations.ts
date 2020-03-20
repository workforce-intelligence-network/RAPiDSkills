import Vue from 'vue';

export const updateUser = (state, user) => {
  Vue.set(state, 'user', user);
};

export const updateUserLoading = (state, loading) => {
  Vue.set(state, 'loading', loading);
};

export const updateUserPromise = (state, userPromise) => {
  Vue.set(state, 'userPromise', userPromise);
};

export const updateSavedStandards = (state, standards) => {
  Vue.set(state, 'savedStandards', standards);
};

export const updateSavedStandardsLoading = (state, loading) => {
  Vue.set(state, 'savedStandardsLoading', loading);
};

export const updateFavorites = (state, favorites) => {
  Vue.set(state, 'favorites', favorites);
};

export const updateFavoritesLoading = (state, loading) => {
  Vue.set(state, 'favoritesLoading', loading);
};
