import '../models/post.dart';
import '../repository/post_repository.dart';

abstract class PostService {
  Future<List<Post>> getAllPosts();
  Future<Post?> getPostById(String id);
  Future<List<Post>> getPostsByDate(DateTime date);
  Future<List<Post>> getUpcomingPosts();
  Future<List<Post>> getPostedPosts();
  Future<Post> createPost(Post post);
  Future<Post> updatePost(Post post);
  Future<bool> deletePost(String id);
  Future<Post> togglePostStatus(String id);
}

class PostServiceImpl implements PostService {
  final PostRepository _repository;

  PostServiceImpl({required PostRepository repository})
      : _repository = repository;

  @override
  Future<List<Post>> getAllPosts() async {
    return await _repository.getAllPosts();
  }

  @override
  Future<Post?> getPostById(String id) async {
    return await _repository.getPostById(id);
  }

  @override
  Future<List<Post>> getPostsByDate(DateTime date) async {
    return await _repository.getPostsByDate(date);
  }

  @override
  Future<List<Post>> getUpcomingPosts() async {
    return await _repository.getUpcomingPosts();
  }

  @override
  Future<List<Post>> getPostedPosts() async {
    return await _repository.getPostedPosts();
  }

  @override
  Future<Post> createPost(Post post) async {
    return await _repository.createPost(post);
  }

  @override
  Future<Post> updatePost(Post post) async {
    return await _repository.updatePost(post);
  }

  @override
  Future<bool> deletePost(String id) async {
    return await _repository.deletePost(id);
  }

  @override
  Future<Post> togglePostStatus(String id) async {
    return await _repository.togglePostStatus(id);
  }
}
