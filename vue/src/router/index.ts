import _get from 'lodash/get';

import Vue from 'vue';
import VueRouter from 'vue-router';

import store from '@/store';

import AppInnerLanding from '@/components/AppInnerLanding.vue';
import AppInnerDashboard from '@/components/AppInnerDashboard.vue';
import SearchOccupations from '@/components/SearchOccupations.vue';
import PageTitle from '@/components/PageTitle.vue';
import StandardNavBarActions from '@/components/StandardNavBarActions.vue';

import Standard from '@/views/Standard.vue';

import { duplicateComponentName } from '@/modal';

Vue.use(VueRouter);

const routes = [
  {
    path: '/',
    component: AppInnerLanding,
    children: [
      {
        path: '',
        name: 'home',
        component: () => import(/* webpackChunkName: "home" */ '@/views/Home.vue'),
      },
      {
        path: 'follow',
        name: 'follow',
        // route level code-splitting
        // this generates a separate chunk (follow.[hash].js) for this route
        // which is lazy-loaded when the route is visited.
        component: () => import(/* webpackChunkName: "follow" */ '@/views/Follow.vue'),
      },
      {
        path: 'login',
        name: 'login',
        component: () => import(/* webpackChunkName: "login" */ '@/views/Login.vue'),
        beforeEnter(to, from, next) {
          if (store.getters['session/isActive']) {
            return next({ name: 'standards' }); // TODO: go home method?
          }

          return next();
        },
      },
      {
        path: 'signup',
        name: 'signup',
        component: () => import(/* webpackChunkName: "signup" */ '@/views/SignUp.vue'),
        beforeEnter(to, from, next) {
          if (store.getters['session/isActive']) {
            return next({ name: 'standards' }); // TODO: go home method?
          }

          return next();
        },
      },
      {
        path: 'forgot',
        name: 'forgot',
        component: () => import(/* webpackChunkName: "forgot" */ '@/views/ForgotPassword.vue'),
        beforeEnter(to, from, next) {
          if (store.getters['session/isActive']) {
            return next({ name: 'standards' }); // TODO: go home method?
          }

          return next();
        },
      },
      {
        path: 'reset',
        name: 'reset',
        component: () => import(/* webpackChunkName: "reset" */ '@/views/ResetPassword.vue'),
        beforeEnter(to, from, next) {
          if (store.getters['session/isActive']) {
            return next({ name: 'standards' }); // TODO: go home method?
          }

          if (!_get(to, 'query.resetToken')) {
            return next({ name: 'login' });
          }

          return next();
        },
      },
      {
        path: 'signout',
        name: 'signout',
        async beforeEnter(to, from, next) {
          await store.dispatch('session/expireToken');
          await store.dispatch('user/clear');
          return next({ name: 'login' });
        },
      },
    ],
  },
  {
    path: '/',
    component: AppInnerDashboard,
    beforeEnter(to, from, next) {
      store.dispatch('user/getUser'); // TODO: get name, icon, etc.
      next();
    },
    children: [
      {
        path: 'standards/:id',
        name: 'standard',
        components: {
          default: Standard,
          navbarActions: StandardNavBarActions,
        },
        beforeEnter(to, from, next) {
          store.dispatch('standards/getStandard', to.params.id);
          next();
        },
        meta: {
          pageTitle: () => _get(store, 'state.standards.selectedStandard.title'),
        },
        children: [
          {
            path: 'duplicate',
            name: 'standardDuplicate',
            async beforeEnter(to, from, next) {
              store.dispatch('standards/ensureDuplicateStandard', to.params.id);
              store.dispatch('modal/update', {
                name: duplicateComponentName,
                onClose() {
                  // eslint-disable-next-line no-use-before-define
                  router.replace({
                    name: 'standard',
                  });
                },
              });
              next();
            },
          },
        ],
      },
      {
        path: 'standards',
        name: 'standards',
        components: {
          default: () => import(/* webpackChunkName: "dashboard" */ '@/views/Dashboard.vue'),
          navbarActions: SearchOccupations,
        },
        beforeEnter(to, from, next) {
          store.dispatch('standards/fetchStandards');
          next();
        },
        children: [
          {
            path: ':id/duplicate',
            name: 'duplicate',
            async beforeEnter(to, from, next) {
              store.dispatch('standards/ensureDuplicateStandard', to.params.id);
              store.dispatch('modal/update', {
                name: duplicateComponentName,
                onClose() {
                  // eslint-disable-next-line no-use-before-define
                  router.replace({
                    name: 'standards',
                  });
                },
              });
              next();
            },
          },
        ],
      },
      {
        path: 'saved',
        name: 'saved',
        component: () => import(/* webpackChunkName: "saved" */ '@/views/SavedStandards.vue'),
        beforeEnter(to, from, next) {
          store.dispatch('user/getSavedStandards');
          next();
        },
      },
      {
        path: 'reports',
        name: 'reports',
        component: () => import(/* webpackChunkName: "reports" */ '@/views/Reports.vue'),
      },
      {
        path: 'settings',
        name: 'settings',
        component: () => import(/* webpackChunkName: "settings" */ '@/views/Settings.vue'),
      },
    ],
  },
  {
    path: '/*',
    redirect: {
      name: 'home',
    },
  },
];

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (to.hash) {
      return {
        selector: to.hash,
      };
    }

    if (![
      'standard',
    ].includes(to.name || '') && savedPosition) {
      return savedPosition;
    }

    return { x: 0, y: 0 };
  },
});

router.afterEach((to, from) => {
  if (['duplicate', 'standardDuplicate'].includes(from.name || '')) {
    store.dispatch('modal/close', false);
  }
});

export default router;
