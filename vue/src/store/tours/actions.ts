import storage from '@/storage';

export const continueTour = async ({ commit, getters, rootState }, tourId: string) => {
  // Clear any visible steps
  const tourConfiguration: string[] = getters.tourConfiguration(tourId);
  tourConfiguration.forEach((tourStepId: string) => {
    commit('hideTourStep', getters.tourStepVisibleId(tourStepId));
  });

  if (rootState.user.userPromise) {
    await rootState.user.userPromise;
  }

  const firstStepId: string | undefined = await getters.firstUnseenTourStepId(tourId);
  if (firstStepId) {
    commit('showTourStep', getters.tourStepVisibleId(firstStepId));
  }
};

export const closeTour = async ({ dispatch, commit, getters }, tourId: string) => {
  const tourConfiguration: string[] = getters.tourConfiguration(tourId);
  tourConfiguration.forEach((tourStepId: string) => {
    dispatch('closeTourStep', tourStepId);
  });
};

export const skipTour = async ({ dispatch, commit, getters }, tourId: string) => {
  const tourConfiguration: string[] = getters.tourConfiguration(tourId);
  tourConfiguration.forEach((tourStepId: string) => {
    dispatch('closeTourStep', tourStepId);
    dispatch('disableTourStep', tourStepId);
  });
};

export const nextTourStep = async ({ dispatch, getters }, tourStepId: string) => {
  await dispatch('closeTourStep', tourStepId);
  await dispatch('disableTourStep', tourStepId);
  const tourStepConfiguration = getters.tourStepConfiguration(tourStepId);
  dispatch('continueTour', tourStepConfiguration.tourId);
};

export const closeTourStep = async ({ commit, getters }, tourStepId: string) => {
  commit('hideTourStep', getters.tourStepVisibleId(tourStepId));
};

export const disableTourStep = async ({ commit, getters }, tourStepId: string) => {
  await storage.setItem(getters.tourStepSeenStorageId(tourStepId), true);
};

export const resetTour = async ({ getters }, tourId: string) => {
  const tourConfiguration: string[] = getters.tourConfiguration(tourId);
  tourConfiguration.forEach((tourStepId: string) => {
    storage.setItem(getters.tourStepSeenStorageId(tourStepId), false);
  });
};
