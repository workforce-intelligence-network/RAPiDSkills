import Skill from '@/models/Skill';

export const searchForSkills = async ({ state, commit }, skill) => {
  if (state.skill !== skill) {
    commit('updateSkillsList', []);
    commit('updateSkill', skill);
  }

  if (skill.description === state.query && state.list.length) {
    commit('updateSkillsQuery', skill.description);
    return;
  }

  try {
    commit('updateSkillsLoading', true);
    commit('updateSkillsQuery', skill.description);
    const { model } = await Skill.getAll({ q: skill.description });
    commit('updateSkillsList', model);
    commit('updateSkillsLoading', false);

    console.log('after search state', state);
  } catch (e) {
    //
  }
};

export const hideSkillsSearch = async ({ state, commit }, skill: Skill) => {
  if (skill !== state.skill) {
    return;
  }

  commit('updateSkill');

  console.log('after hide state', state);
};
