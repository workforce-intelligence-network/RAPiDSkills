export const setSession = (state, session) => {
  state.session = session;
};

export const setToken = (state, token?: string) => {
  state.token = token;
  state.initialized = true;
};
