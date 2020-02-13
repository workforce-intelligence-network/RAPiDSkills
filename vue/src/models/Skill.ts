import { MinLength } from 'class-validator';

import ModelBase from '@/models/ModelBase';
import OccupationStandard from '@/models/OccupationStandard';
import WorkProcess from '@/models/WorkProcess';

export default class Skill extends ModelBase {
  constructor(skill: Partial<Skill> = {}) {
    super(skill);

    this.description = skill.description || '';
  }

  static jsonApiClassName: string = 'skill'

  static jsonApiClassDefinition: object = {
    occupationStandard: {
      jsonApi: 'hasOne',
      type: 'occupation_standard',
    },
    workProcess: {
      jsonApi: 'hasOne',
      type: 'work_process',
    },
  }

  classDefinition: Function = Skill

  @MinLength(1)
  description: string

  occupationStandard?: OccupationStandard

  workProcess?: WorkProcess
}

Skill.registerWithJsonApi();
