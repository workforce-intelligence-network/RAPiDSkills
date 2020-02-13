export const updateContent = async ({ commit }, content) => {
  commit('updateContent', content);
};

export const close = async ({ commit }) => {
  commit('updateContent');
};
