import _camelCase from 'lodash/camelCase';
import _snakeCase from 'lodash/snakeCase';
import _isArray from 'lodash/isArray';
import _isObject from 'lodash/isObject';
import _mapValues from 'lodash/mapValues';
import _mapKeys from 'lodash/mapKeys';

const recursivelyCase = (object, caseMethod = _camelCase) => {
  if (_isArray(object)) {
    return object.map(o => recursivelyCase(o, caseMethod));
  }

  if (!_isObject(object)) {
    return object;
  }

  return _mapValues(
    _mapKeys(object, (value, key) => caseMethod(key)),
    (value, key) => recursivelyCase(value, caseMethod),
  );
};

export const recursivelyCamelCase = object => recursivelyCase(object, _camelCase);
export const recursivelySnakeCase = object => recursivelyCase(object, _snakeCase);
