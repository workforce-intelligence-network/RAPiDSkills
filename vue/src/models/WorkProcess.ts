import jsonApi from '@/helpers/api';

jsonApi.define('work_process', {
  description: '',
  title: '',
  skills: {
    jsonApi: 'hasMany',
    type: 'skill',
  },
});
