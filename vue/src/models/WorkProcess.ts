import _clone from 'lodash/clone';
import _every from 'lodash/every';

import { MinLength } from 'class-validator';
import ModelBase from '@/models/ModelBase';
import Skill from '@/models/Skill';
import OccupationStandard from '@/models/OccupationStandard';

export default class WorkProcess extends ModelBase {
  constructor(workProcess: Partial<WorkProcess> = {}) {
    super(workProcess);

    this.description = workProcess.description || '';
    this.title = workProcess.title || '';
    this.skills = workProcess.skills || [];
    this.skills.forEach((skill, key) => {
      this.skills[key] = new Skill({
        ...skill,
        occupationStandard: this.occupationStandard,
        workProcess: this,
      });
    });
    this.hours = workProcess.hours || 0;
  }

  static jsonApiClassName: string = 'work_process'

  static jsonApiClassDefinition: object = {
    skills: {
      jsonApi: 'hasMany',
      type: 'skill',
    },
    occupationStandard: {
      jsonApi: 'hasOne',
      type: 'occupation_standard',
    },
  }

  classDefinition: Function = WorkProcess

  description: string

  @MinLength(1)
  title: string

  skills: Skill[]

  occupationStandard?: OccupationStandard

  hours: number

  get valid() {
    return super.valid
      && _every(this.skills, skill => skill.valid);
  }

  removeSkill(skill: Skill): WorkProcess {
    const updatedWorkProcessSkills: Skill[] = _clone(this.skills);
    const indexOfWorkProcessSkill: number = updatedWorkProcessSkills.indexOf(skill);

    if (indexOfWorkProcessSkill === -1) {
      throw new Error('Failed to find skill to remove from work process skills');
    }

    updatedWorkProcessSkills.splice(indexOfWorkProcessSkill, 1);
    this.skills = updatedWorkProcessSkills;

    return this;
  }

  addSkill(skill: Skill) {
    const updatedSkills: Skill[] = _clone(this.skills);

    updatedSkills.unshift(skill);
    this.skills = updatedSkills;
  }
}

WorkProcess.registerWithJsonApi();
