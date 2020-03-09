export const update = async ({ commit }, component: ModalComponent) => {
  commit('update', component);
};

export const close = async ({ commit, getters }, callOnClose: boolean = true) => {
  if (callOnClose) {
    getters.modalComponentOnClose();
  }

  commit('update');
};
