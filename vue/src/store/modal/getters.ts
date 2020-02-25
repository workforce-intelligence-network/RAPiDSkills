export const modalComponentName = state => ((state.component || {}) as ModalComponent).name;

export const modalComponentOnClose = state => ((state.component || {}) as ModalComponent).onClose || (() => {});
