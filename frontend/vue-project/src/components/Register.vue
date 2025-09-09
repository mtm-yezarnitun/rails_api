<template>
  <div class="register">
    <h2 class="title">Register</h2>
    <form @submit.prevent="register">
      <input v-model="email" type="email" placeholder="Email" required  class="register-input"/>
      <input v-model="password" type="password" placeholder="Password" required class="register-input"/>
      <input v-model="passwordConfirmation" type="password" placeholder="Confirm Password" required class="register-input"/>
      <button type="submit" class="action-btn">Sign Up</button>
    </form>
    <p v-if="error" style="color: red">{{ error }}</p>
    <p v-if="success" style="color: green">{{ success }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { registerUser } from '../services/authService';

const email = ref('');
const password = ref('');
const passwordConfirmation = ref('');
const error = ref('');
const success = ref('');

const register = async () => {
  error.value = '';
  success.value = '';

  try {
    const response = await registerUser({
      user: {
        email: email.value,
        password: password.value,
        password_confirmation: passwordConfirmation.value,
      },
    });

    const { token, user } = response.data;
    localStorage.setItem('token', token);
    success.value = `Welcome ${user.email}!`;
  } catch (err) {
    error.value = err.response?.data?.errors?.join(', ') || 'Registration failed';
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
.register-input{ 
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
