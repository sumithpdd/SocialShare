import 'package:flutter/foundation.dart';
import '../models/tag.dart';
import '../services/firebase_service.dart';

class TagProvider with ChangeNotifier {
  final FirebaseService _firebaseService;
  
  List<Tag> _tags = [];
  bool _isLoading = false;
  String? _error;

  TagProvider({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService() {
    _loadTags();
  }

  List<Tag> get tags => _tags;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _loadTags() async {
    _setLoading(true);
    try {
      _tags = await _firebaseService.getAllTags();
      _error = null;
    } catch (e) {
      _error = 'Failed to load tags: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> refreshTags() async {
    await _loadTags();
  }

  Future<void> addTag(Tag tag) async {
    _setLoading(true);
    try {
      final newTag = await _firebaseService.createTag(tag);
      _tags.add(newTag);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to create tag: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTag(Tag tag) async {
    _setLoading(true);
    try {
      final updatedTag = await _firebaseService.updateTag(tag);
      final index = _tags.indexWhere((t) => t.id == updatedTag.id);
      if (index != -1) {
        _tags[index] = updatedTag;
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update tag: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTag(String id) async {
    _setLoading(true);
    try {
      final success = await _firebaseService.deleteTag(id);
      if (success) {
        _tags.removeWhere((tag) => tag.id == id);
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete tag: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Tag? getTagById(String id) {
    try {
      return _tags.firstWhere((tag) => tag.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Tag> getTagsByName(String name) {
    return _tags.where((tag) => 
        tag.name.toLowerCase().contains(name.toLowerCase())).toList();
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
