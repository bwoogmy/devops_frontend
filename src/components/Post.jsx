import { useState } from 'react';

function Post({ post, onDelete, onLike, onUnlike }) {
  const [liked, setLiked] = useState(false);
  const [likesCount, setLikesCount] = useState(post.likes_count);

  const handleLike = async () => {
    try {
      if (liked) {
        const data = await onUnlike(post.id);
        setLikesCount(data.likes_count);
        setLiked(false);
      } else {
        const data = await onLike(post.id);
        setLikesCount(data.likes_count);
        setLiked(true);
      }
    } catch (error) {
      console.error('Error liking post:', error);
    }
  };

  const handleDelete = async () => {
    if (window.confirm('Delete this post?')) {
      try {
        await onDelete(post.id);
      } catch (error) {
        console.error('Error deleting post:', error);
      }
    }
  };

  return (
    <div style={{
      border: '1px solid #e1e8ed',
      borderRadius: '8px',
      padding: '16px',
      marginBottom: '12px',
      backgroundColor: 'white'
    }}>
      <div style={{ marginBottom: '8px' }}>
        <strong style={{ color: '#1da1f2' }}>@{post.author}</strong>
        <span style={{ color: '#657786', fontSize: '14px', marginLeft: '8px' }}>
          {new Date(post.created_at).toLocaleString()}
        </span>
      </div>
      <p style={{ margin: '12px 0', fontSize: '16px', lineHeight: '1.5' }}>
        {post.content}
      </p>
      <div style={{ display: 'flex', gap: '16px', alignItems: 'center' }}>
        <button
          onClick={handleLike}
          style={{
            background: 'none',
            border: 'none',
            cursor: 'pointer',
            fontSize: '16px',
            color: liked ? '#e0245e' : '#657786'
          }}
        >
          {liked ? '❤️' : '🤍'} {likesCount}
        </button>
        <button
          onClick={handleDelete}
          style={{
            background: 'none',
            border: 'none',
            cursor: 'pointer',
            fontSize: '16px',
            color: '#657786'
          }}
        >
          🗑️
        </button>
      </div>
    </div>
  );
}

export default Post;
