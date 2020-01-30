import ModelBase from '@/models/ModelBase';
import Skill from '@/models/Skill';

export default class WorkProcess extends ModelBase {
  constructor(workProcess: Partial<WorkProcess> = {}) {
    super(workProcess);

    this.description = workProcess.description || '';
    this.title = workProcess.title || '';
    this.skills = workProcess.skills || [];
    this.skills.forEach((skill, key) => {
      this.skills[key] = new Skill(skill);
    });
  }

  static jsonApiClassName: string = 'work_process'

  static jsonApiClassDefinition: object = {
    skills: {
      jsonApi: 'hasMany',
      type: 'skill',
    },
  }

  classDefinition: Function = WorkProcess

  description: string

  title: string

  skills: Skill[]

  expanded?: boolean
}

WorkProcess.registerWithJsonApi();
