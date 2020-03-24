import Vue from 'vue';
import VueAnalytics from 'vue-analytics';
import VueScrollTo from 'vue-scrollto';

import Rollbar from 'vue-rollbar';

import '@/utilities/font-awesome';

import '@/models';

import App from '@/App.vue';
import router from '@/router';
import store from '@/store';

const { VUE_APP_ROLLBAR_ENVIRONMENT } = process.env;

Vue.config.productionTip = false;

Vue.use(VueAnalytics, {
  id: 'UA-159063587-1',
});

Vue.use(Rollbar, {
  accessToken: '6c41d7f381264bfcb064f34ad4a98501',
  captureUncaught: true,
  captureUnhandledRejections: true,
  enabled: true,
  environment: VUE_APP_ROLLBAR_ENVIRONMENT,
  payload: {
    client: {
      javascript: {
        code_version: '1.0',
        source_map_enabled: true,
        guess_uncaught_frames: true,
      },
    },
  },
});

Vue.use(VueScrollTo, {
  container: '#body',
});

(async () => {
  try {
    // Make sure session is loaded before loading views
    await store.dispatch('session/initializeSession');

    new Vue({
      router,
      store,
      render: h => h(App),
    }).$mount('#app');
  } catch (e) {
    if ((Vue as any).rollbar) {
      (Vue as any).rollbar.error(e);
    }
  }
})();
