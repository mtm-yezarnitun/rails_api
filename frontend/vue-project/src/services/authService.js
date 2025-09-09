import axios from 'axios';

const API = axios.create({
  baseURL: 'http://localhost:3000', 
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
  },
});

export const registerUser = async (userData) => {
  return API.post('/sign-up', userData);
};
export const loginUser = async (userData) => {
  return API.post('/login', userData);
};
export const logoutUser = async () => {
  return API.delete('/logout');
};


API.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
