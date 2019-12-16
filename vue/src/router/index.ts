import Vue from 'vue';
import VueRouter from 'vue-router';

import jsonApi from '@/utilities/api';

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
        path: 'standards',
        name: 'standards',
        components: {
          default: () => import(/* webpackChunkName: "dashboard" */ '@/views/Dashboard.vue'),
          search: Search,
        },
        beforeEnter: (to, from, next) => {
          store.dispatch('standards/fetchStandards');
          next();
        },
      },
      {
        path: 'standards/:id',
        name: 'standard',
        component: () => import(/* webpackChunkName: "standard" */ '@/views/Standard.vue'),
        beforeEnter: (to, from, next) => {
          store.dispatch('standards/getStandard', to.params.id);
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
