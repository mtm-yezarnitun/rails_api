<!-- src/App.vue -->
<template>
  <div id="app">
    <nav>
      <router-link to="/register">Register</router-link> |
      <router-link to="/login">Login</router-link> |
      <router-link to="/posts">Posts</router-link>
      <button v-if="loggedIn" @click="logout">Logout</button>
      <span v-if="loggedIn" class="status">✅ Logged in</span>
    </nav>

    <main>
      <router-view />
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { logoutUser } from './services/authService';
import { useRouter } from 'vue-router';

const router = useRouter();
const loggedIn = ref(false);

onMounted(() => {
  loggedIn.value = !!localStorage.getItem('token');
});

const logout = async () => {
  try {
    await logoutUser();
  } catch (err) {
    console.warn('Logout error:', err.response?.data);
  }
  localStorage.removeItem('token');
  loggedIn.value = false;
  router.push('/login');
};
</script>

<style>
nav {
  padding: 10px;
  background-color: #f5f5f5;
}
nav a {
  margin-right: 10px;
  text-decoration: none;
  color: green;
}
nav a.router-link-active {
  font-weight: bold;
}
button {
  margin-left: 15px;
}
.status {
  margin-left: 10px;
  color: green;
  font-weight: bold;
}
</style>
