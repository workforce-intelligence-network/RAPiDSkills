import { MinLength } from 'class-validator';
import ModelBase from '@/models/ModelBase';

export default class Skill extends ModelBase {
  constructor(skill: Partial<Skill> = {}) {
    super(skill);

    this.description = skill.description || '';
  }

  static jsonApiClassName: string = 'skill'

  classDefinition: Function = Skill

  @MinLength(1)
  description: string
}

Skill.registerWithJsonApi();
