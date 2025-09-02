import 'package:flutter/foundation.dart';
import '../models/post.dart';
import '../services/json_post_service.dart';

class JsonPostProvider with ChangeNotifier {
  List<Post> _posts = [];
  Post? _selectedPost;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _error;

  List<Post> get posts => _posts;
  Post? get selectedPost => _selectedPost;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Post> get upcomingPosts => _posts
      .where((post) => post.date.isAfter(DateTime.now()) && !post.isPosted)
      .toList();

  List<Post> get postedPosts => _posts.where((post) => post.isPosted).toList();

  List<Post> get recentPosts => _posts.take(6).toList();

  /// Loads posts from the assets/posts folder
  Future<void> loadPosts() async {
    _setLoading(true);
    try {
      _posts = await JsonPostService.loadPosts();
      _error = null;
    } catch (e) {
      _error = 'Failed to load posts: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Refreshes posts from the assets/posts folder
  Future<void> refreshPosts() async {
    _setLoading(true);
    try {
      _posts = await JsonPostService.refreshPosts();
      _error = null;
    } catch (e) {
      _error = 'Failed to refresh posts: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void selectPost(Post post) {
    _selectedPost = post;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  List<Post> getPostsByDate(DateTime date) {
    return JsonPostService.getPostsByDate(date);
  }

  List<Post> getPostsByPlatform(SocialPlatform platform) {
    return JsonPostService.getPostsByPlatform(platform);
  }

  List<Post> getPostsByTag(String tag) {
    return JsonPostService.getPostsByTag(tag);
  }

  List<Post> getPostsByCampaign(String campaign) {
    return JsonPostService.getPostsByCampaign(campaign);
  }

  List<String> getAvailableCampaigns() {
    return JsonPostService.getAvailableCampaigns();
  }

  Post? getPostById(String id) {
    return JsonPostService.getPostById(id);
  }

  /// Create a post and persist to assets (desktop-only). Falls back to memory on web.
  Future<void> addPost(Post post) async {
    _setLoading(true);
    try {
      final path = await JsonPostService.createPostFile(post);
      if (path == null) {
        // Web or unsupported runtime: keep in-memory only
        _posts.add(post);
        _posts.sort((a, b) => b.date.compareTo(a.date));
      } else {
        // On success, ensure in-memory list is updated (already done in service), but refresh to be safe
        _posts = JsonPostService.getAllPosts();
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to create post: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Update a post and persist to assets on desktop.
  Future<void> updatePost(Post updatedPost) async {
    _setLoading(true);
    try {
      final ok = await JsonPostService.updatePostFile(updatedPost);
      if (!ok) {
        // Fallback: update memory only
        final index = _posts.indexWhere((p) => p.id == updatedPost.id);
        if (index != -1) {
          _posts[index] = updatedPost;
        }
      } else {
        _posts = JsonPostService.getAllPosts();
      }
      if (_selectedPost?.id == updatedPost.id) {
        _selectedPost = updatedPost;
      }
      _posts.sort((a, b) => b.date.compareTo(a.date));
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update post: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a post and remove the file on desktop.
  Future<void> deletePost(String postId) async {
    _setLoading(true);
    try {
      final ok = await JsonPostService.deletePostFileById(postId);
      if (!ok) {
        // Fallback: delete memory only
        _posts.removeWhere((post) => post.id == postId);
      } else {
        _posts = JsonPostService.getAllPosts();
      }
      if (_selectedPost?.id == postId) {
        _selectedPost = null;
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete post: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Toggles the posted status of a post
  Future<void> togglePostStatus(String postId) async {
    try {
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final post = _posts[index];
        final updatedPost = Post(
          id: post.id,
          title: post.title,
          content: post.content,
          date: post.date,
          isPosted: !post.isPosted,
          postedBy: post.postedBy,
          imageUrl: post.imageUrl,
          tags: post.tags,
          platforms: post.platforms,
          additionalLinks: post.additionalLinks,
          campaign: post.campaign,
          mentions: post.mentions,
          postedAt: !post.isPosted ? DateTime.now() : null,
          postUrl: post.postUrl,
        );

        await updatePost(updatedPost);
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
