import { useState } from 'react';

function PostForm({ onCreatePost }) {
  const [content, setContent] = useState('');
  const [author, setAuthor] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!content.trim() || !author.trim()) {
      alert('Please fill in all fields');
      return;
    }

    setLoading(true);
    try {
      await onCreatePost(content, author);
      setContent('');
      setAuthor('');
    } catch (error) {
      console.error('Error creating post:', error);
      alert('Failed to create post');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{
      border: '1px solid #e1e8ed',
      borderRadius: '8px',
      padding: '16px',
      marginBottom: '20px',
      backgroundColor: 'white'
    }}>
      <h2 style={{ margin: '0 0 16px 0', fontSize: '20px' }}>Create Post</h2>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Your name"
          value={author}
          onChange={(e) => setAuthor(e.target.value)}
          maxLength={50}
          style={{
            width: '100%',
            padding: '12px',
            marginBottom: '12px',
            border: '1px solid #e1e8ed',
            borderRadius: '4px',
            fontSize: '16px',
            boxSizing: 'border-box'
          }}
        />
        <textarea
          placeholder="What's happening?"
          value={content}
          onChange={(e) => setContent(e.target.value)}
          maxLength={280}
          rows={4}
          style={{
            width: '100%',
            padding: '12px',
            marginBottom: '12px',
            border: '1px solid #e1e8ed',
            borderRadius: '4px',
            fontSize: '16px',
            resize: 'vertical',
            boxSizing: 'border-box'
          }}
        />
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <span style={{ color: '#657786', fontSize: '14px' }}>
            {content.length}/280
          </span>
          <button
            type="submit"
            disabled={loading}
            style={{
              backgroundColor: '#1da1f2',
              color: 'white',
              border: 'none',
              borderRadius: '20px',
              padding: '10px 24px',
              fontSize: '16px',
              fontWeight: 'bold',
              cursor: loading ? 'not-allowed' : 'pointer',
              opacity: loading ? 0.6 : 1
            }}
          >
            {loading ? 'Posting...' : 'Post'}
          </button>
        </div>
      </form>
    </div>
  );
}

export default PostForm;
