import _isFunction from 'lodash/isFunction';

export const update = async ({ commit }, component: ModalComponent) => {
  commit('update', component);
};

export const close = async ({ state, commit, getters }, callOnClose: boolean = true) => {
  if (!state.component) {
    return;
  }

  if (callOnClose) {
    const { onClose } = state.component;
    if (_isFunction(onClose)) {
      onClose!();
    }
  }

  commit('update');
};
