export const updateStandardsSearchQuery = async (state, query) => {
  state.query = query;
};

export const updateStandardsSearchList = async (state, list) => {
  state.list = list;
};

export const updateSelectedStandard = async (state, standard) => {
  state.selectedStandard = standard;
};
