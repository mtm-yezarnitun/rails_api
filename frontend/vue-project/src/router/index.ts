import { createRouter, createWebHistory } from 'vue-router';
import Register from '../components/Register.vue';
import Login from '../components/Login.vue';
import Posts from '../components/Posts.vue';
import PostDetail from '../components/PostDetail.vue';

const routes = [
  { path: '/register', component: Register },
  { path: '/login', component: Login },
  { path: '/posts', component: Posts },
  { path: '/posts/:id', component: PostDetail },
  { path: '/', redirect: '/login'},
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
