import _pick from 'lodash/pick';
import _every from 'lodash/every';

import { MinLength } from 'class-validator';

import _isUndefined from 'lodash/isUndefined';

import store from '@/store';

import jsonApi from '@/utilities/api';

import ModelBase from '@/models/ModelBase';

import WorkProcess from '@/models/WorkProcess';

import Skill from '@/models/Skill';
import Organization from '@/models/Organization';
import Occupation from '@/models/Occupation';
import User from '@/models/User';

export default class OccupationStandard extends ModelBase {
  constructor(standard: Partial<OccupationStandard> = {}) {
    super(standard);

    this.parentOccupationStandardId = this.id || '';
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

    this.creator = standard.creator ? new User(standard.creator) : undefined;
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
    creator: {
      jsonApi: 'hasOne',
      type: 'user',
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

  @MinLength(1)
  title: string

  workProcesses: WorkProcess[]

  skills: Skill[]

  occupation: Occupation

  organization: Organization

  parentOccupationStandardId: string | number

  creator: User | undefined

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

  async clone(params: object = {}): Promise<any> {
    const apiResponse = await jsonApi.create(
      this.staticType.jsonApiClassName,
      _pick(this.jsonApiObject, [
        'parentOccupationStandardId',
        'title',
      ]),
      params,
    );

    const { data } = apiResponse;

    return Object.assign(apiResponse, { model: new OccupationStandard(data) });
  }

  get valid() {
    return super.valid
      && _every(this.workProcesses, workProcess => workProcess.valid)
      && _every(this.skills, skill => skill.valid);
  }

  get loggedInUserIsCreator() {
    const { userId } = (store.state as any).session;
    return !_isUndefined(userId) && this.creator && !_isUndefined(this.creator.id) && String(userId) === String(this.creator.id);
  }
}

OccupationStandard.registerWithJsonApi();
