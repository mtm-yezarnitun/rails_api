src/components/Login.vue
<template>
  <div class="login">
    <h2 class="title">Login</h2>
    <p v-if="success" style="color: green">{{ success }}</p>
    <p v-if="error" style="color: red">{{ error }}</p>
    <form @submit.prevent="login">
      <input v-model="email" type="email" placeholder="Email" required class="login-input"/>
      <input v-model="password" type="password" placeholder="Password" required class="login-input"/>
      <button type="submit" class="action-btn">Login</button>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { loginUser } from '../services/authService';

const email = ref('');
const password = ref('');
const error = ref('');
const success = ref('');

const login = async () => {
  error.value = '';
  success.value = '';

  try {
    const response = await loginUser({
      user: {
        email: email.value,
        password: password.value,
      },
    });

    const { token, user } = response.data;
    localStorage.setItem('token', token);
    localStorage.setItem('currentUser', JSON.stringify(user));
    success.value = `Welcome back ${user.email}!`;
  } catch (err) {
    error.value = err.response?.data?.error || 'Login failed';
  }
};
</script>

<style scoped>

.action-btn {
  margin: 5px;
  padding: 8px 12px;
  background-color: #1fa731;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.action-btn:hover {
  background-color: #158f28;
}

.title {
  text-align: center;
  font-size: 32px;
  font-weight: bold;
  padding: 10px;
  color: #1fa731;
}

.login-input{ 
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  box-sizing: border-box;
  border: 2px solid #fff;
  background-color: #fff;
  color: black;
  border-radius: 5px;
  resize: vertical;
}

</style> 

