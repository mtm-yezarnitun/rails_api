<!-- src/App.vue -->
<template>
  <div id="app">
    <nav>
      <router-link to="/register">Register</router-link> |
      <router-link to="/login">Login</router-link> |
      <span class="lg-box">
        <span v-if="loggedIn && currentUser" class="status"> {{ currentUser.email }} </span>
          =<button v-if="loggedIn" @click="logout" class="action-btn">Logout</button>
       </span>
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
const currentUser = ref(null); 

onMounted(() => {
  const token = localStorage.getItem('token');
  const userData = localStorage.getItem('currentUser'); 

  loggedIn.value = !!token;

  if (userData) {
    try {
      currentUser.value = JSON.parse(userData);
    } catch (err) {
      console.warn('Invalid user data in localStorage');
      currentUser.value = null;
    }
  }
});

const logout = async () => {
  try {
    await logoutUser();
  } catch (err) {
    console.warn('Logout error:', err.response?.data);
  }
  localStorage.removeItem('token');
  localStorage.removeItem('user'); 
  loggedIn.value = false;
  currentUser.value = null;
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
  align-content: center;
}
nav a.router-link-active {
  font-weight: bold;
}
nav {
  display: flex;
  justify-content: flex-end;

}
button {
  margin-left: 15px;
}
.status {
  margin-left: 10px;
  color: green;
  font-weight: bold;
}
.action-btn {
  margin: 5px;
  padding: 8px 12px;
  background-color: #1fa731;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
</style>
