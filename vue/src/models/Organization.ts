import ModelBase from '@/models/ModelBase';

import LOGO_WIN from '@/assets/win.png';

export default class Organization extends ModelBase {
  constructor(organization: Partial<Organization> = {}) {
    super(organization);

    this.title = organization.title || '';
    this.logoUrl = organization.logoUrl || LOGO_WIN;
    this.registersStandards = organization.registersStandards || false;
  }

  static jsonApiClassName: string = 'organization'

  classDefinition: Function = Organization

  title: string

  logoUrl: string

  registersStandards: boolean
}

Organization.registerWithJsonApi();
