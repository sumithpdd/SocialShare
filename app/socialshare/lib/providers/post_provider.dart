import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../repository/post_repository.dart';

class PostProvider with ChangeNotifier {
  final PostRepository _repository;

  List<Post> _posts = [];
  Post? _selectedPost;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _error;

  PostProvider({PostRepository? repository})
      : _repository = repository ?? PostRepositoryImpl() {
    _loadPosts();
  }

  PostRepository get repository => _repository;
  List<Post> get posts => _posts;
  Post? get selectedPost => _selectedPost;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Post> get upcomingPosts => _posts
      .where((post) => post.date.isAfter(DateTime.now()) && !post.isPosted)
      .toList();

  List<Post> get postedPosts => _posts.where((post) => post.isPosted).toList();

  Future<void> _loadPosts() async {
    _setLoading(true);
    try {
      _posts = await _repository.getAllPosts();
      _error = null;
    } catch (e) {
      _error = 'Failed to load posts: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> refreshPosts() async {
    await _loadPosts();
  }

  void selectPost(Post post) {
    _selectedPost = post;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<List<Post>> getPostsByDate(DateTime date) async {
    try {
      return await _repository.getPostsByDate(date);
    } catch (e) {
      _error = 'Failed to get posts by date: $e';
      notifyListeners();
      return [];
    }
  }

  Future<void> addPost(Post post) async {
    _setLoading(true);
    try {
      final newPost = await _repository.createPost(post);
      _posts.add(newPost);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to create post: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePost(Post updatedPost) async {
    _setLoading(true);
    try {
      final post = await _repository.updatePost(updatedPost);
      final index = _posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        _posts[index] = post;
        if (_selectedPost?.id == post.id) {
          _selectedPost = post;
        }
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update post: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePost(String postId) async {
    _setLoading(true);
    try {
      final success = await _repository.deletePost(postId);
      if (success) {
        _posts.removeWhere((post) => post.id == postId);
        if (_selectedPost?.id == postId) {
          _selectedPost = null;
        }
        _error = null;
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete post: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> togglePostStatus(String postId) async {
    try {
      final updatedPost = await _repository.togglePostStatus(postId);
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        _posts[index] = updatedPost;
        if (_selectedPost?.id == postId) {
          _selectedPost = updatedPost;
        }
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to toggle post status: $e';
      notifyListeners();
    }
  }

  void clearSelection() {
    _selectedPost = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
