import _get from 'lodash/get';
import _find from 'lodash/find';
import _isUndefined from 'lodash/isUndefined';

import storage from '@/storage';

export const tourStepVisible = (state, getters) => (tourStepId: string): boolean => !!state[getters.tourStepVisibleId(tourStepId)];

export const tourStepVisibleId = state => (tourStepId: string): string => {
  if (!tourStepId) {
    throw new Error('Tour step id required to generate visibleId');
  }

  return `${tourStepId}-visible`;
};

export const tourStepSeen = (state, getters) => async (tourStepId: string): Promise<boolean> => {
  if (!tourStepId) {
    throw new Error('Tour step id required to determine if step has been seen');
  }

  const seenId: string = getters.tourStepSeenStorageId(tourStepId);
  const seen: boolean | null | undefined = await storage.getItem(seenId);
  return !!seen;
};

export const firstUnseenTourStepId = (state, getters, rootState, rootGetters) => async (tourId: string): Promise<string | undefined> => {
  const configuration: string[] = getters.tourConfiguration(tourId);
  const stepsSeen = await Promise.all(configuration.map(async (tourStepId: string) => ({
    unseen: (!state[tourStepId].loggedIn || rootGetters['session/isActive']) && !(await getters.tourStepSeen(tourStepId)),
    tourStepId,
  })));

  return (_find(stepsSeen, step => step.unseen) || {}).tourStepId;
};

export const tourStepSeenStorageId = (state, getters, rootState) => (tourStepId: string) => {
  if (!tourStepId) {
    throw new Error('Tour step ID required to generate seen storage id');
  }

  const userId: number | string | undefined = _get(rootState, 'user.user.id');

  // TODO: remove user id once stored on backend?
  if (!_isUndefined(userId)) {
    return `user:${userId}:tourStepSeen:${tourStepId}`;
  }

  return `tourStepSeen:${tourStepId}`;
};

export const tourStepConfiguration = (state, getters) => (tourStepId: string) => {
  if (!tourStepId) {
    throw new Error('Tour step id required to return step configuration');
  }

  const configuration: any | undefined = state[tourStepId];

  if (!configuration) {
    throw new Error(`Tour step does not exist with id: ${tourStepId}`);
  }

  if (!configuration.tourId || !getters.tourConfiguration(configuration.tourId)) {
    throw new Error('Tour step configuration must reference tour configuration via id');
  }

  return configuration;
};

export const tourConfiguration = state => (tourId: string) => {
  if (!tourId) {
    throw new Error('Tour id required to return tour configuration');
  }

  if (!state[tourId]) {
    throw new Error(`Tour does not exist with id: ${tourId}`);
  }

  return state[tourId];
};
