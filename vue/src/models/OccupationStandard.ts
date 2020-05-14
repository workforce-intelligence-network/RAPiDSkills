import _find from 'lodash/find';
import _pick from 'lodash/pick';
import _every from 'lodash/every';
import _clone from 'lodash/clone';
import _capitalize from 'lodash/capitalize';
import _isUndefined from 'lodash/isUndefined';

import Vue from 'vue';

import { MinLength } from 'class-validator';

import store from '@/store';

import jsonApi, { apiRaw } from '@/utilities/api';

import ModelBase from '@/models/ModelBase';

import WorkProcess from '@/models/WorkProcess';

import Skill from '@/models/Skill';
import Organization from '@/models/Organization';
import Occupation from '@/models/Occupation';
import User from '@/models/User';

import LOGO_DEFAULT from '@/assets/default-standard-logo-alt.png';

export default class OccupationStandard extends ModelBase {
  constructor(standard: Partial<OccupationStandard> = {}) {
    super(standard);

    this.excelCreatedAt = standard.excelCreatedAt || '';
    this.excelFilename = standard.excelFilename || '';
    this.excelUrl = standard.excelUrl || '';
    this.industryTitle = standard.industryTitle || '';
    this.occupationTitle = standard.occupationTitle || '';
    this.organizationTitle = standard.organizationTitle || '';
    this.organizationLogoUrl = standard.organizationLogoUrl || LOGO_DEFAULT;
    this.occupationKind = _capitalize(standard.occupationKind || '');
    this.occupationOnetCode = standard.occupationOnetCode || '';
    this.occupationRapidsCode = standard.occupationRapidsCode || '';
    this.pdfCreatedAt = standard.pdfCreatedAt || '';
    this.pdfFilename = standard.pdfFilename || '';
    this.pdfUrl = standard.pdfUrl || '';
    this.shouldGenerateAttachments = standard.shouldGenerateAttachments || false;
    this.title = standard.title || '';

    this.workProcesses = standard.workProcesses || [];
    this.workProcesses.forEach((workProcess, key) => {
      this.workProcesses[key] = new WorkProcess({
        ...workProcess,
        occupationStandard: this,
      });
    });

    this.skills = standard.skills || [];
    this.skills.forEach((skill, key) => {
      this.skills[key] = new Skill({
        ...skill,
        occupationStandard: this,
      });
    });

    this.occupation = new Occupation(standard.occupation || {});
    this.organization = new Organization(standard.organization || {});

    this.creator = standard.creator ? new User(standard.creator) : undefined;

    this.workProcessesCount = standard.workProcessesCount || 0;
    this.skillsCount = standard.skillsCount || 0;
    this.hoursCount = standard.hoursCount || 0;
    this.parentOccupationStandard = standard.parentOccupationStandard ? new OccupationStandard(standard.parentOccupationStandard) : undefined;
  }

  static jsonApiClassName: string = 'occupation_standard'

  static jsonApiClassDefinition: object = {
    parentOccupationStandardId: '',
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
    parentOccupationStandard: {
      jsonApi: 'hasOne',
      type: 'occupation_standard',
    },
  }

  classDefinition: Function = OccupationStandard

  excelCreatedAt: string

  excelFilename: string

  excelUrl: string

  industryTitle: string

  organizationTitle: string

  organizationLogoUrl: string

  occupationKind: string

  occupationOnetCode: string

  occupationRapidsCode: string

  occupationTitle: string

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

  creator: User | undefined

  workProcessesCount: number

  skillsCount: number

  hoursCount: number

  parentOccupationStandard: OccupationStandard | undefined

  get totalNumberOfSkills() {
    return this.skills.length + this.workProcesses.reduce(
      (total: number, workProcess: WorkProcess) => total + workProcess.skills.length,
      0,
    );
  }

  get totalNumberOfHours() {
    return this.workProcesses
      .reduce(
        (total, workProcess) => total + (workProcess as any).hours || 0,
        0,
      );
  }

  async persistDuplicate(params: object = {}): Promise<any> {
    const apiResponse = await jsonApi.create(
      this.staticType.jsonApiClassName,
      {
        parentOccupationStandardId: this.id,
        title: this.title,
      },
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
    // eslint-disable-next-line prefer-destructuring
    const user: User | undefined = (store.state as any).user.user;
    return user && user.synced && this.creator && !_isUndefined(this.creator.id) && String(user.id) === String(this.creator.id);
  }

  get favorited() {
    // eslint-disable-next-line prefer-destructuring
    const favorites: OccupationStandard[] = (store.state as any).user.favorites;
    return this.synced && !!_find(favorites, (favorite: OccupationStandard) => String(favorite.id) === String(this.id));
  }

  async destroySkillIfSynced(skill: Skill) {
    if (!skill.synced) {
      return;
    }

    await jsonApi
      .one(this.staticType.jsonApiClassName, this.id)
      .relationships('skills')
      .destroy([{ id: skill.id }]);

    // TODO: undo if fails?
  }

  async removeOrReplaceSkill(skill: Skill, workProcess?: WorkProcess, replacement?: Skill) {
    const updatedSkills: Skill[] = _clone(this.skills);
    const indexOfSkill: number = updatedSkills.indexOf(skill);

    if (indexOfSkill !== -1) {
      if (replacement) {
        updatedSkills.splice(indexOfSkill, 1, replacement);
      } else {
        updatedSkills.splice(indexOfSkill, 1);
      }

      this.skills = updatedSkills;

      await this.destroySkillIfSynced(skill);

      return;
    }

    if (!workProcess) {
      throw new Error('Failed to find skill to remove from standard skills');
    }

    const accurateWorkProcessReference: WorkProcess = _find(
      this.workProcesses,
      (currentWorkProcess: WorkProcess) => currentWorkProcess === workProcess || (currentWorkProcess.synced && currentWorkProcess.id === workProcess.id),
    );

    try {
      accurateWorkProcessReference.removeOrReplaceSkill(skill, replacement);
    } catch (e) {
      (Vue as any).rollbar.error(e);
    }

    await this.destroySkillIfSynced(skill);
  }

  async destroyWorkProcessIfSynced(workProcess: WorkProcess) {
    if (!workProcess.synced) {
      return;
    }

    await apiRaw.delete(`/occupation_standards/${this.id}/relationships/work_processes`, {
      data: {
        data: [{
          id: workProcess.id,
        }],
      },
    });

    // TODO: get the following working with middleware?

    // .one(this.staticType.jsonApiClassName, this.id)
    // .relationships('work_processes')
    // .destroy([{ id: workProcess.id }]);

    // TODO: undo if fails?
  }

  addSkill(skill: Skill) {
    const updatedSkills: Skill[] = _clone(this.skills);

    updatedSkills.unshift(skill);
    this.skills = updatedSkills;
  }

  addWorkProcess(workProcess: WorkProcess) {
    const updatedWorkProcesses: WorkProcess[] = _clone(this.workProcesses);

    updatedWorkProcesses.unshift(workProcess);
    this.workProcesses = updatedWorkProcesses;
  }

  async removeWorkProcess(workProcess: WorkProcess) {
    const updatedWorkProcesses: WorkProcess[] = _clone(this.workProcesses);
    const indexOfWorkProcess: number = updatedWorkProcesses.indexOf(workProcess);

    if (indexOfWorkProcess === -1) {
      throw new Error('Failed to find work process to remove from standard');
    }

    updatedWorkProcesses.splice(indexOfWorkProcess, 1);
    this.workProcesses = updatedWorkProcesses;

    await this.destroyWorkProcessIfSynced(workProcess);
  }
}

OccupationStandard.registerWithJsonApi();
