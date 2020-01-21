import ModelBase from '@/models/ModelBase';

export default class Organization extends ModelBase {
  constructor(organization: Partial<Organization> = {}) {
    super(organization);

    this.title = organization.title || '';
    this.logoUrl = organization.logoUrl || '';
    this.registersStandards = organization.registersStandards || false;
  }

  static jsonApiClassName: string = 'organization'

  classDefinition: Function = Organization

  title: string

  logoUrl: string

  registersStandards: boolean
}

Organization.registerWithJsonApi();
