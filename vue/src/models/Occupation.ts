import _capitalize from 'lodash/capitalize';

import ModelBase from '@/models/ModelBase';

export default class Occupation extends ModelBase {
  constructor(occupation: Partial<Occupation> = {}) {
    super(occupation);

    this.title = occupation.title || '';
    this.titleAliases = occupation.titleAliases || '';
    this.onetCode = occupation.onetCode || '';
    this.rapidsCode = occupation.rapidsCode || '';
    this.termLengthMin = occupation.termLengthMin || 3000; // TODO: better defaults
    this.termLengthMax = occupation.termLengthMax || 3445; // TODO: better defaults
    this.onetPageUrl = occupation.onetPageUrl || '';
    this.kind = _capitalize(occupation.kind || '');
  }

  static jsonApiClassName: string = 'occupation'

  classDefinition: Function = Occupation

  title: string

  titleAliases: string

  onetCode: string

  rapidsCode: string

  termLengthMin: number

  termLengthMax: number

  onetPageUrl: string

  kind: string
}

Occupation.registerWithJsonApi();
