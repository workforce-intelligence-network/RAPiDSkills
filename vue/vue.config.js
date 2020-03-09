let RAPID_SKILLS_ENVIRONMENT = {};

try {
  RAPID_SKILLS_ENVIRONMENT = JSON.parse(process.env.RAPID_SKILLS_ENVIRONMENT);
} catch {
  //
}

process.env.VUE_APP_ROLLBAR_ENVIRONMENT = process.env.HEROKU_APP_NAME
  || (RAPID_SKILLS_ENVIRONMENT || {}).presence // TODO: is this right?
  || process.env.NODE_ENV
  || 'production';

module.exports = {
  chainWebpack: (config) => {
    config.module
      .rule('svg')
      .test(/\.(svg)(\?.*)?$/)
      .use('file-loader')
      .loader('file-loader')
      .end();
  },
};
