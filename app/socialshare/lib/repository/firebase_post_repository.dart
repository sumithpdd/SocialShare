import '../models/post.dart';
import '../services/firebase_service.dart';
import 'post_repository.dart';

class FirebasePostRepository implements PostRepository {
  final FirebaseService _firebaseService;

  FirebasePostRepository({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService();

  @override
  Future<List<Post>> getAllPosts() async {
    return await _firebaseService.getAllPosts();
  }

  @override
  Future<Post?> getPostById(String id) async {
    return await _firebaseService.getPostById(id);
  }

  @override
  Future<List<Post>> getPostsByDate(DateTime date) async {
    return await _firebaseService.getPostsByDate(date);
  }

  @override
  Future<List<Post>> getUpcomingPosts() async {
    return await _firebaseService.getUpcomingPosts();
  }

  @override
  Future<List<Post>> getPostedPosts() async {
    return await _firebaseService.getPostedPosts();
  }

  @override
  Future<Post> createPost(Post post) async {
    return await _firebaseService.createPost(post);
  }

  @override
  Future<Post> updatePost(Post post) async {
    return await _firebaseService.updatePost(post);
  }

  @override
  Future<bool> deletePost(String id) async {
    return await _firebaseService.deletePost(id);
  }

  @override
  Future<Post> togglePostStatus(String id) async {
    return await _firebaseService.togglePostStatus(id);
  }
}
