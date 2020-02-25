export const update = async ({ commit }, component) => {
  commit('update', component);
};

export const close = async ({ commit, getters }, callOnClose: boolean = true) => {
  if (callOnClose) {
    getters.modalOnClose();
  }
  commit('update');
};
