import Skill from '@/models/Skill';

export const searchForSkills = async ({ state, commit }, query?: string) => {
  if (query === state.query && state.list.length) {
    commit('updateSkillsQuery', query);
    return;
  }

  try {
    commit('updateSkillsLoading', true);
    commit('updateSkillsQuery', query);
    const { model } = await Skill.getAll({ q: query });
    commit('updateSkillsList', model);
    commit('updateSkillsLoading', false);
  } catch (e) {
    //
  }
};

export const hideSkillsSearch = async ({ commit }) => {
  commit('hideSkillsSearch');
};
