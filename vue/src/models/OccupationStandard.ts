import ModelBase, { ModelCollection } from '@/models/ModelBase';

import WorkProcess, { WorkProcessCollection } from '@/models/WorkProcess';

import Skill, { SkillCollection } from '@/models/Skill';
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
    this.workProcesses = new WorkProcessCollection((standard.workProcesses || []) as Array<WorkProcess>);
    this.skills = new SkillCollection((standard.skills || []) as Array<Skill>);
    this.occupation = new Occupation(standard.occupation || {});
    this.organization = new Organization(standard.organization || {});
  }

  static jsonApiClassName: string = 'occupation_standard'

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

  workProcesses: WorkProcessCollection<WorkProcess>

  skills: SkillCollection<Skill>

  occupation: Occupation

  organization: Organization

  get totalNumberOfHours() {
    return this.workProcesses
      .reduce(
        (total, workProcess) => total + (workProcess as any).hoursTotal || 0,
        0,
      );
  }
}

OccupationStandard.registerWithJsonApi();

export class OccupationStandardCollection<OccupationStandard> extends ModelCollection<OccupationStandard> {
  constructor(collection: Array<OccupationStandard> = []) {
    super(collection, OccupationStandard);
  }

  static jsonApiClassName: string = 'occupation_standard'

  classDefinition: Function = OccupationStandardCollection
}
