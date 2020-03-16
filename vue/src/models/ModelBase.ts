import _set from 'lodash/set';
import _pick from 'lodash/pick';
import _omit from 'lodash/omit';
import _uniq from 'lodash/uniq';
import _flatten from 'lodash/flatten';
import _isUndefined from 'lodash/isUndefined';
import _zipObject from 'lodash/zipObject';
import _isObject from 'lodash/isObject';
import _isArray from 'lodash/isArray';
import _isFunction from 'lodash/isFunction';
import _isString from 'lodash/isString';
import _isNumber from 'lodash/isNumber';

import {
  validateSync, ValidationError, ValidatorOptions,
} from 'class-validator';
import moment, { Moment } from 'moment';
import jsonApi from '@/utilities/api';

interface ValidationErrorMap {
  [propertyName: string]: ValidationError[]
}

export default class ModelBase {
  constructor(object: any = {}) {
    Object.assign(this, object);

    this.id = object.id || '';
  }

  id: number | string

  type?: string

  links?: {}

  updatedAt?: string

  classDefinition!: Function

  validatorOptions?: ValidatorOptions

  validating: boolean = false

  loading: boolean = false

  dirty: boolean = false

  apiErrors?: []

  static jsonApiClassName: string

  static jsonApiClassDefinition: object

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

  static async getAll(params: object = {}): Promise<any> {
    const apiResponse = await jsonApi.findAll(this.jsonApiClassName, params);

    const { data } = apiResponse;

    (data as []).forEach((object: any, key) => {
      data[key] = new this(object);
    });

    return Object.assign(apiResponse, { model: data });
  }

  get generatedJsonApiClassDefinition() {
    return _zipObject(
      this.propertyKeys,
      this.propertyKeys.map((key) => {
        if (
          (!this.staticType.jsonApiClassDefinition || !this.staticType.jsonApiClassDefinition[key])
          && !(this[key] instanceof ModelBase)
          && (_isArray(this[key]) || _isObject(this[key]))
        ) {
          throw new Error('JSON API class definition required for any sub-type that does not extend ModelBase');
        }

        if (this[key] instanceof ModelBase) {
          return {
            jsonApi: 'hasOne',
            type: (this[key] as ModelBase).staticType.jsonApiClassName,
          };
        }

        if (!_isUndefined((this.staticType.jsonApiClassDefinition || {})[key])) {
          return (this.staticType.jsonApiClassDefinition || {})[key];
        }

        return this[key];
      }),
    );
  }

  async save(params: object = {}): Promise<any> {
    this.validating = true;

    if (this.invalid) {
      this.dirty = true;
      throw this.validationErrors; // TODO: reformat to standard format?
    }

    this.dirty = false;
    this.apiErrors = undefined;
    this.loading = true;

    let result: any;

    try {
      const apiMethod: Function = (this.synced
        ? jsonApi.update
        : jsonApi.create
      ).bind(jsonApi);

      result = await apiMethod(this.staticType.jsonApiClassName, this.jsonApiObject, params);

      // Automatically sets id if present
      if (!this.synced) {
        const { data } = result;
        if (_isNumber(data.id) || _isString(data.id)) {
          this.id = data.id;
        }
      }

      this.updatedAt = moment().format();
    } catch (errors) {
      this.apiErrors = _flatten([errors]);
      this.dirty = true;
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

  get synced() {
    return this.id === 0 || !!String(this.id || '').length;
  }

  get propertyKeys() {
    return _uniq(
      Object.keys(this.staticType.jsonApiClassDefinition || {}).concat(
        Object.keys(this).filter(key => !_isFunction(this[key]) && [
          'type',
          'links',
          'classDefinition',
          'validatorOptions',
          'validating',
          'loading',
          'apiErrors',
          'dirty',
        ].indexOf(key) === -1),
      ),
    );
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
