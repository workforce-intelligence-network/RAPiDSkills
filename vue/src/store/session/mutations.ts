export const setUserId = (state, id?: string | number) => {
  state.userId = id;
};

export const setToken = (state, token?: string) => {
  state.token = token;
  state.initialized = true;
};
