// eslint-disable-next-line import/prefer-default-export
export const setToken = (state, token?: string) => {
  state.token = token;
  state.initialized = true;
};
