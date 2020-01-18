import ModelBase, { ModelCollection } from '@/models/ModelBase';
import Skill, { SkillCollection } from '@/models/Skill';

export default class WorkProcess extends ModelBase {
  constructor(workProcess: Partial<WorkProcess> = {}) {
    super(workProcess);

    this.description = workProcess.description || '';
    this.title = workProcess.title || '';
    this.skills = new SkillCollection((workProcess.skills || []) as Array<Skill>);
  }

  static jsonApiClassName: string = 'work_process'

  classDefinition: Function = WorkProcess

  description: string

  title: string

  skills: SkillCollection<Skill>
}

WorkProcess.registerWithJsonApi();

export class WorkProcessCollection<WorkProcess> extends ModelCollection<WorkProcess> {
  constructor(collection: Array<WorkProcess> = []) {
    super(collection, WorkProcess);
  }

  static jsonApiClassName: string = 'work_process'

  classDefinition: Function = WorkProcessCollection
}
