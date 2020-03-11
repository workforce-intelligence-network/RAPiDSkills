process.env.VUE_APP_ROLLBAR_ENVIRONMENT = process.env.HEROKU_APP_NAME
  || process.env.RAPID_SKILLS_ENVIRONMENT
  || process.env.RAILS_ENV
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
