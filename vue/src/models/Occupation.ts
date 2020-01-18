import ModelBase, { ModelCollection } from '@/models/ModelBase';

export default class Occupation extends ModelBase {
  constructor(occupation: Partial<Occupation> = {}) {
    super(occupation);

    this.title = occupation.title || '';
    this.titleAliases = occupation.titleAliases || '';
    this.onetCode = occupation.onetCode || '';
    this.rapidsCode = occupation.rapidsCode || '';
    this.termLengthMin = occupation.termLengthMin || 3000;
    this.termLengthMax = occupation.termLengthMax || 3445;
  }

  static jsonApiClassName: string = 'occupation'

  classDefinition: Function = Occupation

  title: string

  titleAliases: string

  onetCode: string

  rapidsCode: string

  termLengthMin: number

  termLengthMax: number
}

Occupation.registerWithJsonApi();

export class OccupationCollection<Occupation> extends ModelCollection<Occupation> {
  constructor(collection: Array<Occupation> = []) {
    super(collection, Occupation);
  }

  static jsonApiClassName: string = 'occupation'

  classDefinition: Function = OccupationCollection
}
