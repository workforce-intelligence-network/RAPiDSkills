import ModelBase from '@/models/ModelBase';

import WorkProcess from '@/models/WorkProcess';

import Skill from '@/models/Skill';
import Organization from '@/models/Organization';
import Occupation from '@/models/Occupation';

export default class OccupationStandard extends ModelBase {
  constructor(standard: Partial<OccupationStandard> = {}) {
    super(standard);

    this.excelCreatedAt = standard.excelCreatedAt || '';
    this.excelFilename = standard.excelFilename || '';
    this.excelUrl = standard.excelUrl || '';
    this.industryTitle = standard.industryTitle || '';
    this.occupationTitle = standard.occupationTitle || '';
    this.organizationTitle = standard.organizationTitle || '';
    this.pdfCreatedAt = standard.pdfCreatedAt || '';
    this.pdfFilename = standard.pdfFilename || '';
    this.pdfUrl = standard.pdfUrl || '';
    this.shouldGenerateAttachments = standard.shouldGenerateAttachments || false;
    this.title = standard.title || '';
    this.workProcesses = standard.workProcesses || [];
    this.workProcesses.forEach((workProcess, key) => {
      this.workProcesses[key] = new WorkProcess(workProcess);
    });
    this.skills = standard.skills || [];
    this.skills.forEach((skill, key) => {
      this.skills[key] = new Skill(skill);
    });
    this.occupation = new Occupation(standard.occupation || {});
    this.organization = new Organization(standard.organization || {});
  }

  static jsonApiClassName: string = 'occupation_standard'

  static jsonApiClassDefinition: object = {
    skills: {
      jsonApi: 'hasMany',
      type: 'skill',
    },
    workProcesses: {
      jsonApi: 'hasMany',
      type: 'work_process',
    },
  }

  classDefinition: Function = OccupationStandard

  excelCreatedAt: string

  excelFilename: string

  excelUrl: string

  industryTitle: string

  occupationTitle: string

  organizationTitle: string

  pdfCreatedAt: string

  pdfFilename: string

  pdfUrl: string

  shouldGenerateAttachments: boolean

  title: string

  workProcesses: WorkProcess[]

  skills: Skill[]

  occupation: Occupation

  organization: Organization

  get totalNumberOfSkills() {
    return this.skills.length + this.workProcesses.reduce(
      (total: number, workProcess: WorkProcess) => total + workProcess.skills.length,
      0,
    );
  }

  get totalNumberOfHours() {
    return this.workProcesses
      .reduce(
        (total, workProcess) => total + (workProcess as any).hoursTotal || 0,
        0,
      );
  }
}

OccupationStandard.registerWithJsonApi();
