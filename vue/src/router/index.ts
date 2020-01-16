import _get from 'lodash/get';

import Vue from 'vue';
import VueRouter from 'vue-router';

import store from '@/store';

import AppInnerLanding from '@/components/AppInnerLanding.vue';
import AppInnerDashboard from '@/components/AppInnerDashboard.vue';
import Search from '@/components/Search.vue';
import PageTitle from '@/components/PageTitle.vue';

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
    ],
  },
  {
    path: '/',
    component: AppInnerDashboard,
    children: [
      {
        path: 'standards',
        name: 'standards',
        components: {
          default: () => import(/* webpackChunkName: "dashboard" */ '@/views/Dashboard.vue'),
          navbarActions: Search,
        },
        beforeEnter: (to, from, next) => {
          store.dispatch('standards/fetchStandards');
          next();
        },
      },
      {
        path: 'standards/:id',
        name: 'standard',
        components: {
          default: () => import(/* webpackChunkName: "standard" */ '@/views/Standard.vue'),
          navbarActions: PageTitle,
        },
        beforeEnter: (to, from, next) => {
          store.dispatch('standards/getStandard', to.params.id);
          next();
        },
        meta: {
          pageTitle: () => _get(store, 'state.standards.selectedStandard.title'),
        },
      },
      {
        path: 'favorites',
        name: 'favorites',
        components: {
          default: () => import(/* webpackChunkName: "favorites" */ '@/views/Favorites.vue'),
          navbarActions: Search,
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
});

export default router;
