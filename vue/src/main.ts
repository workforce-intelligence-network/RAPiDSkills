import Vue from 'vue';

import '@/utilities/font-awesome';

import '@/models';

import App from '@/App.vue';
import '@/registerServiceWorker';
import router from '@/router';
import store from '@/store';

Vue.config.productionTip = false;


(async () => {
  // Make sure session is loaded before loading views
  await store.dispatch('session/initializeSession');

  new Vue({
    router,
    store,
    render: h => h(App),
  }).$mount('#app');
})();
