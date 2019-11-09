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
