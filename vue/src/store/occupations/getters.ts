export const showOccupationSearchList = (state): boolean => state.freshSearch && (state.list.length || state.loading);

export const temp = (state): boolean => state.freshSearch && (state.list.length || state.loading); // Placeholder for eslint error
