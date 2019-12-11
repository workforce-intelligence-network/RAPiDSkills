import axios from 'axios';
import JsonApi from 'devour-client';

import {
  recursivelyCamelCase,
  recursivelySnakeCase,
} from '@/helpers/case';

export const { VUE_APP_API_BASE_URL } = process.env;
export const API_NAMESPACE = '/api/v1';
const apiUrl = `${VUE_APP_API_BASE_URL}${API_NAMESPACE}`;

export const apiRaw = axios.create({
  baseURL: apiUrl,
});

const jsonApi = new JsonApi({ apiUrl });

const requestMiddleware = {
  name: 'snake-case-attributes',
  req: (payload) => {
    const updatedPayload = Object.assign({}, payload);
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

export default jsonApi;
