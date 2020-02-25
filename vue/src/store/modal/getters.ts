export const modalComponentName = state => (state.component || {}).name;

export const modalOnClose = state => (state.component || {}).onClose || (() => {});
