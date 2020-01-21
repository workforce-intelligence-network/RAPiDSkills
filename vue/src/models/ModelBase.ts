import _set from 'lodash/set';
import _pick from 'lodash/pick';
import _omit from 'lodash/omit';
import _flatten from 'lodash/flatten';
import _isUndefined from 'lodash/isUndefined';

import {
  validateSync, ValidationError, ValidatorOptions,
} from 'class-validator';

import _zipObject from 'lodash/zipObject';
import _isObject from 'lodash/isObject';
import _isArray from 'lodash/isArray';
import _isFunction from 'lodash/isFunction';
import jsonApi from '@/utilities/api';

interface ValidationErrorMap {
  [propertyName: string]: ValidationError[]
}

export default class ModelBase {
  constructor(object: object = {}) {
    Object.assign(this, object);
  }

  id?: number | string

  type?: string

  links?: {}

  classDefinition!: Function

  validatorOptions?: ValidatorOptions

  validating: boolean = false

  loading: boolean = false

  apiErrors?: []

  static jsonApiClassName: string

  static jsonApiRelationship: string = 'hasOne'

  static jsonApiClassOptions: object = {}

  static registerWithJsonApi() {
    const instance = new this();
    jsonApi.define(this.jsonApiClassName, instance.generatedJsonApiClassDefinition, this.jsonApiClassOptions);
  }

  static async get(id: number | string | undefined, params: object = {}): Promise<any> {
    if (_isUndefined(id)) {
      throw new Error(`No id provided in ${typeof this.constructor}.get`);
    }

    const apiResponse = await jsonApi.find(this.jsonApiClassName, id, params);

    const { data } = apiResponse;

    return Object.assign(apiResponse, { model: new this(data) });
  }

  get generatedJsonApiClassDefinition() {
    return _zipObject(this.propertyKeys, this.propertyKeys.map(key => (this[key].classDefinition ? {
      jsonApi: (<typeof ModelBase> this[key].classDefinition).jsonApiRelationship,
      type: (<typeof ModelBase> this[key].classDefinition).jsonApiClassName,
    } : this[key])));
  }

  async save(params: object = {}): Promise<any> {
    this.validating = true;

    if (this.invalid) {
      throw this.validationErrors; // TODO: reformat to standard format?
    }

    this.validating = false;
    this.apiErrors = undefined;
    this.loading = true;

    let result: any;

    try {
      const apiMethod: Function = (_isUndefined(this.id)
        ? jsonApi.create
        : jsonApi.update
      ).bind(jsonApi);

      result = await apiMethod(this.staticType.jsonApiClassName, this.jsonApiObject, params);
    } catch (errors) {
      this.apiErrors = _flatten([errors]);
    }

    this.loading = false;

    if (this.apiErrors) {
      throw this.apiErrors; // TODO: reformat to standard format?
    }

    return result;
  }

  propertyInvalid(property: string): boolean {
    return !this.propertyValid(property);
  }

  propertyValid(property: string): boolean {
    return !this.propertyValidationErrors(property).length;
  }

  propertyValidationErrors(property: string): ValidationError[] {
    return this.validationErrorMap[property] || [];
  }

  get propertyKeys() {
    return Object.keys(this).filter(key => !_isFunction(this[key]) && [
      'type',
      'links',
      'classDefinition',
      'validatorOptions',
      'validating',
      'loading',
      'apiErrors',
    ].indexOf(key) === -1);
  }

  get jsonApiObject() {
    const modifiableDuplicate = new (this.classDefinition as any)(this);
    validateSync(modifiableDuplicate, this.validatorOptions || {});
    return _pick(modifiableDuplicate, this.propertyKeys);
  }

  get staticType() {
    return <typeof ModelBase> this.constructor;
  }

  get validationErrorMap(): ValidationErrorMap {
    const { validationErrors } = this;

    const validationMap: ValidationErrorMap = {};

    validationErrors.forEach((error: ValidationError) => {
      if (!validationMap[error.property]) {
        validationMap[error.property] = [];
      }

      validationMap[error.property].push(error);
    });

    return validationMap;
  }

  get validationErrors(): ValidationError[] {
    return validateSync(this, _omit(this.validatorOptions || {}, ['whitelist', 'forbidUnknownValues', 'forbidNonWhitelisted']));
  }

  get valid(): boolean {
    return !this.validationErrors.length;
  }

  get invalid(): boolean {
    return !this.valid;
  }
}

export class ModelCollection<T> extends Array<T> {
  constructor(collection: Array<T>, ClassConstructor: any) {
    super(...collection);

    this.forEach((object, key) => {
      _set(this, key, new ClassConstructor(object));
    });
  }

  static jsonApiClassName: string

  static jsonApiRelationship: string = 'hasMany'

  static async get(params: object = {}, ClassConstructor: any): Promise<any> {
    const apiResponse = await jsonApi.findAll(this.jsonApiClassName, params);

    const { data } = apiResponse;

    return Object.assign(apiResponse, { model: new this(data, ClassConstructor) });
  }

  classDefinition!: Function
}
