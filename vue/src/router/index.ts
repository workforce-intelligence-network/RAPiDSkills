import Vue from 'vue';
import VueRouter from 'vue-router';

import jsonApi from '@/helpers/api';

import store from '@/store';

import AppInnerLanding from '@/components/AppInnerLanding.vue';
import AppInnerDashboard from '@/components/AppInnerDashboard.vue';
import Search from '@/components/Search.vue';

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
        path: 'dashboard',
        name: 'dashboard',
        components: {
          default: () => import(/* webpackChunkName: "dashboard" */ '@/views/Dashboard.vue'),
          search: Search,
        },
        beforeEnter: async (to, from, next) => {
          store.dispatch('standards/searchForStandards');
          next();
        },
      },
      {
        path: 'favorites',
        name: 'favorites',
        components: {
          default: () => import(/* webpackChunkName: "favorites" */ '@/views/Favorites.vue'),
          search: Search,
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
];

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes,
});

export default router;
