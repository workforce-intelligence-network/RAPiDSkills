// eslint-disable-next-line import/prefer-default-export
export const showOccupationSearchList = (state): boolean => state.freshSearch && (state.list.length || state.loading);
