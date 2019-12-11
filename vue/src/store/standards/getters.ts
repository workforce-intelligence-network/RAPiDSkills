export function standardsListEmptyAndNotLoading(state, getters) {
  return getters.standardsListEmpty && !state.loading;
}

export function standardsListEmpty(state, getters) {
  return !state.list.length;
}
