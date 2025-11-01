import Post from './Post';

function PostList({ posts, onDelete, onLike, onUnlike }) {
  if (posts.length === 0) {
    return (
      <div style={{ 
        textAlign: 'center', 
        padding: '40px', 
        color: '#657786' 
      }}>
        No posts yet. Be the first to post!
      </div>
    );
  }

  return (
    <div>
      {posts.map((post) => (
        <Post
          key={post.id}
          post={post}
          onDelete={onDelete}
          onLike={onLike}
          onUnlike={onUnlike}
        />
      ))}
    </div>
  );
}

export default PostList;
