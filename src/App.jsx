import { useState, useEffect } from 'react';
import PostForm from './components/PostForm';
import PostList from './components/PostList';
import { getPosts, createPost, deletePost, likePost, unlikePost } from './api/posts';
import './App.css';

function App() {
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchPosts = async () => {
    try {
      setLoading(true);
      const data = await getPosts();
      setPosts(data.posts);
      setError(null);
    } catch (err) {
      setError('Failed to load posts');
      console.error('Error fetching posts:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchPosts();
  }, []);

  const handleCreatePost = async (content, author) => {
    await createPost(content, author);
    await fetchPosts();
  };

  const handleDeletePost = async (postId) => {
    await deletePost(postId);
    setPosts(posts.filter(post => post.id !== postId));
  };

  const handleLikePost = async (postId) => {
    return await likePost(postId);
  };

  const handleUnlikePost = async (postId) => {
    return await unlikePost(postId);
  };

  return (
    <div style={{ minHeight: '100vh', backgroundColor: '#f7f9fa' }}>
      <div style={{ maxWidth: '600px', margin: '0 auto', padding: '20px' }}>
        <h1 style={{ fontSize: '32px', fontWeight: 'bold', marginBottom: '24px', color: '#1da1f2' }}>
          Twitter Clone
        </h1>
        
        <PostForm onCreatePost={handleCreatePost} />
        
        {loading && (
          <div style={{ textAlign: 'center', padding: '20px', color: '#657786' }}>
            Loading posts...
          </div>
        )}
        
        {error && (
          <div style={{ textAlign: 'center', padding: '20px', color: '#e0245e', backgroundColor: '#ffebee', borderRadius: '8px', marginBottom: '20px' }}>
            {error}
          </div>
        )}
        
        {!loading && !error && (
          <PostList posts={posts} onDelete={handleDeletePost} onLike={handleLikePost} onUnlike={handleUnlikePost} />
        )}
      </div>
    </div>
  );
}

export default App;
