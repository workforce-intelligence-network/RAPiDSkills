import _get from 'lodash/get';
import _set from 'lodash/set';
import _isFunction from 'lodash/isFunction';

import axios from 'axios';
import JsonApi from 'devour-client';

import {
  recursivelyCamelCase,
  recursivelySnakeCase,
} from '@/utilities/case';

export const { VUE_APP_API_BASE_URL } = process.env;
export const API_NAMESPACE = '/api/v1';
const apiUrl = `${VUE_APP_API_BASE_URL}${API_NAMESPACE}`;

export const apiRaw = axios.create({
  baseURL: apiUrl,
});

const jsonApi = new JsonApi({
  apiUrl,
  logger: false,
});

const requestMiddleware = {
  name: 'snake-case-attributes',
  req: (payload) => {
    const updatedPayload = Object.assign({}, payload);
    updatedPayload.req.params = recursivelySnakeCase(updatedPayload.req.params);
    updatedPayload.req.data = recursivelySnakeCase(updatedPayload.req.data);
    return updatedPayload;
  },
};

const responseMiddleware = {
  name: 'camel-case-attributes',
  res: (payload) => {
    const updatedPayload = Object.assign({}, payload);
    updatedPayload.res = recursivelyCamelCase(updatedPayload.res);
    return updatedPayload;
  },
};

jsonApi.insertMiddlewareBefore('axios-request', requestMiddleware);
jsonApi.insertMiddlewareBefore('response', responseMiddleware);

const axiosRequest = {
  name: 'custom-axios-request',
  req(payload) {
    let promise;

    try {
      promise = payload.jsonApi.axios(payload.req);
    } catch (e) {
      //
    }

    return promise;
  },
};

jsonApi.removeMiddleware('axios-request');
jsonApi.insertMiddlewareAfter('snake-case-attributes', axiosRequest);

export default jsonApi;
