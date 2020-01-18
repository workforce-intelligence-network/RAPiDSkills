import ModelBase, { ModelCollection } from '@/models/ModelBase';

export default class Skill extends ModelBase {
  constructor(skill: Partial<Skill> = {}) {
    super(skill);

    this.description = skill.description || '';
  }

  static jsonApiClassName: string = 'skill'

  classDefinition: Function = Skill

  description: string
}

Skill.registerWithJsonApi();

export class SkillCollection<Skill> extends ModelCollection<Skill> {
  constructor(collection: Array<Skill> = []) {
    super(collection, Skill);
  }

  static jsonApiClassName: string = 'skill'

  classDefinition: Function = SkillCollection
}
