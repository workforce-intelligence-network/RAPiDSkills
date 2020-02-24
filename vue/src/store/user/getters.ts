// eslint-disable-next-line import/prefer-default-export
export const initials = (state) => {
  if (!state.user || !state.user.name) {
    return '?';
  }

  const split = state.user.name.split(' ');

  return split.map((name: string) => name[0]).join('');
};
