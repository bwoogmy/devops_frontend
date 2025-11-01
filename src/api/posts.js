import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000/api/v1';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const getPosts = async (limit = 50, offset = 0) => {
  const response = await api.get(`/posts?limit=${limit}&offset=${offset}`);
  return response.data;
};

export const createPost = async (content, author) => {
  const response = await api.post('/posts', { content, author });
  return response.data;
};

export const deletePost = async (postId) => {
  await api.delete(`/posts/${postId}`);
};

export const likePost = async (postId, userIdentifier = 'anonymous') => {
  const response = await api.post(`/posts/${postId}/like?user_identifier=${userIdentifier}`);
  return response.data;
};

export const unlikePost = async (postId, userIdentifier = 'anonymous') => {
  const response = await api.delete(`/posts/${postId}/like?user_identifier=${userIdentifier}`);
  return response.data;
};
