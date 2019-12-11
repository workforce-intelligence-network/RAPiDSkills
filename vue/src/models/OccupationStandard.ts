import jsonApi from '@/helpers/api';

jsonApi.define('occupation_standard', {
  excel_created_at: '',
  excel_filename: '',
  excel_url: '',
  industry_title: '',
  occupation_title: '',
  organization_title: '',
  pdf_created_at: '',
  pdf_filename: '',
  pdf_url: '',
  should_generate_attachments: false,
  title: '',
  work_processes: {
    jsonApi: 'hasMany',
    type: 'work_process',
  },
  skills: {
    jsonApi: 'hasMany',
    type: 'skill',
  },
});
