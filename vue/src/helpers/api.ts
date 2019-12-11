import axios from 'axios';
import JsonApi from 'devour-client';

export const { VUE_APP_API_BASE_URL } = process.env;
export const API_NAMESPACE = '/api/v1';
const fullUrl = `${VUE_APP_API_BASE_URL}${API_NAMESPACE}`;

export const apiRaw = axios.create({
  baseURL: fullUrl,
});

const jsonApi = new JsonApi({ apiUrl: fullUrl });

export default jsonApi;
