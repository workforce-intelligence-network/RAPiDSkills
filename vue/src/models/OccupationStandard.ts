import jsonApi from '@/utilities/api';

jsonApi.define('occupation_standard', {
  excelCreatedAt: '',
  excelFilename: '',
  excelUrl: '',
  industryTitle: '',
  occupationTitle: '',
  organizationTitle: '',
  pdfCreatedAt: '',
  pdfFilename: '',
  pdfUrl: '',
  shouldGenerateAttachments: false,
  title: '',
  workProcesses: {
    jsonApi: 'hasMany',
    type: 'workProcess',
  },
  skills: {
    jsonApi: 'hasMany',
    type: 'skill',
  },
});
