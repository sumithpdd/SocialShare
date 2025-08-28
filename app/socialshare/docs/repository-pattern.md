# Repository Pattern

## 🎯 Overview

The **Repository Pattern** is a design pattern that abstracts data access logic from the business logic layer. In SocialShare, this pattern provides a clean separation between data sources and the rest of the application, making the code more maintainable, testable, and flexible.

## 🏗️ What is the Repository Pattern?

### **Definition**
A repository acts as a **mediator** between the business logic and data access layers. It provides a collection-like interface for accessing domain objects while hiding the complexity of data persistence.

### **Benefits**
- **Abstraction**: Business logic doesn't know about data source details
- **Testability**: Easy to mock for unit testing
- **Flexibility**: Can switch between different data sources
- **Maintainability**: Data access logic is centralized
- **Separation of Concerns**: Clear boundaries between layers

## 🧩 Repository Pattern in SocialShare

### **Architecture Overview**

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                      │
│  (Screens, Widgets, UI Components)                        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   BUSINESS LOGIC LAYER                     │
│  (Providers, Services)                                     │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     REPOSITORY LAYER                       │
│  (Repository Interface + Implementation)                   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     DATA SOURCE LAYER                      │
│  (In-Memory, Database, API, etc.)                         │
└─────────────────────────────────────────────────────────────┘
```

### **Data Flow**
```
User Action → Provider → Repository → Data Source
     ↑                                           ↓
     └────────── UI Update ←─── Response ←──────┘
```

## 🔧 Implementation Details

### **1. Repository Interface**

**Location**: `lib/repository/post_repository.dart`

**Purpose**: Defines the contract for data operations

```dart
abstract class PostRepository {
  // Read operations
  Future<List<Post>> getAllPosts();
  Future<Post?> getPostById(String id);
  Future<List<Post>> getPostsByDate(DateTime date);
  Future<List<Post>> getUpcomingPosts();
  Future<List<Post>> getPostedPosts();
  
  // Write operations
  Future<Post> createPost(Post post);
  Future<Post> updatePost(Post post);
  Future<bool> deletePost(String id);
  Future<Post> togglePostStatus(String id);
}
```

**Key Points**:
- **Abstract class**: Cannot be instantiated directly
- **Future-based**: All operations are asynchronous
- **Clear contract**: Defines exactly what operations are available
- **Domain-focused**: Methods use business terminology

### **3. Rich Content Example**

**New AI-Focused Post**: The repository now includes an example of rich content posts with emojis, hashtags, and media:

```dart
Post(
  id: '13',
  title: '🚀 Are you working on the cutting edge of AI?',
  content: 'We\'re looking for speakers ready to share their insights, demos, or lessons learned in:\n\n🧠 GenAI • LLMs • Multimodal apps • AI agents • MLOps • Ethics • And more!\n\n👉 Apply to speak: https://lnkd.in/egqefzA2\n\n🙌 Prefer to join the audience and soak it all in?\n🎟️ Grab your ticket: https://lnkd.in/efcRfi9T\n\nLet\'s shape the future of AI together.',
  imageUrl: 'https://media.licdn.com/dms/image/v2/D4D22AQF4bmFDeBjbEw/feedshare-shrink_800/B4DZhXExOdG8Ag-/0/1753807525207?e=1759363200&v=beta&t=SUWIq0O4gtEoNcywD3bkoQI2y1TY5oQztJ8ABoO-fv0',
  tags: ['AI', 'GenAI', 'LLMs', 'MLOps', 'speakers', 'GoogleIO'],
  platforms: [SocialPlatform.linkedin, SocialPlatform.twitter, SocialPlatform.facebook],
  additionalLinks: [
    'https://lnkd.in/egqefzA2',
    'https://lnkd.in/efcRfi9T',
    'https://www.linkedin.com/feed/update/urn:li:activity:7356001921347858432'
  ],
  campaign: 'Google I/O Extended London',
)
```

**Features Demonstrated**:
- **Emojis**: 🚀🧠👉🙌🎟️ in title and content
- **Formatted Text**: Line breaks and bullet points
- **Media**: External LinkedIn image URL
- **Hashtags**: AI-related tags for categorization
- **Multiple Links**: Speaker application and ticket purchase URLs
- **Campaign**: Event-specific campaign organization

### **2. Repository Implementation**

**Location**: `lib/repository/post_repository.dart`

**Purpose**: Concrete implementation of the repository interface

```dart
class PostRepositoryImpl implements PostRepository {
  // Private data storage
  final List<Post> _posts = [];
  int _nextId = 1;

  // Constructor with initialization
  PostRepositoryImpl() {
    _initializeDummyData();
  }

  // Initialize with sample data
  void _initializeDummyData() {
    _posts.addAll([
      Post(
        id: '1',
        title: 'Welcome to Our Platform',
        content: 'We are excited to launch our new social media management platform...',
        date: DateTime.now().add(const Duration(days: 1)),
        isPosted: false,
        postedBy: 'John Doe',
        tags: ['announcement', 'launch'],
        platforms: [SocialPlatform.linkedin, SocialPlatform.twitter],
        additionalLinks: [],
        campaign: 'Platform Launch',
      ),
      Post(
        id: '2',
        title: 'Best Practices for Social Media',
        content: 'Here are some tips to improve your social media presence...',
        date: DateTime.now().add(const Duration(days: 2)),
        isPosted: false,
        postedBy: 'Jane Smith',
        tags: ['tips', 'marketing'],
        platforms: [SocialPlatform.facebook, SocialPlatform.instagram],
        additionalLinks: ['https://example.com/guide'],
        campaign: 'Educational Content',
      ),
    ]);
    _nextId = 3;
  }

  // Implementation of interface methods
  @override
  Future<List<Post>> getAllPosts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_posts);
  }

  @override
  Future<Post?> getPostById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Post>> getPostsByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _posts.where((post) {
      return post.date.year == date.year &&
             post.date.month == date.month &&
             post.date.day == date.day;
    }).toList();
  }

  @override
  Future<Post> createPost(Post post) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Create new post with generated ID
    final newPost = post.copyWith(
      id: _nextId.toString(),
    );
    
    _posts.add(newPost);
    _nextId++;
    
    return newPost;
  }

  @override
  Future<Post> updatePost(Post post) async {
    await Future.delayed(const Duration(milliseconds: 350));
    
    final index = _posts.indexWhere((p) => p.id == post.id);
    if (index == -1) {
      throw Exception('Post not found');
    }
    
    _posts[index] = post;
    return post;
  }

  @override
  Future<bool> deletePost(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final initialLength = _posts.length;
    _posts.removeWhere((post) => post.id == id);
    
    return _posts.length < initialLength;
  }

  @override
  Future<Post> togglePostStatus(String id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    
    final post = _posts.firstWhere((p) => p.id == id);
    final updatedPost = post.copyWith(
      isPosted: !post.isPosted,
      postedAt: !post.isPosted ? DateTime.now() : null,
    );
    
    final index = _posts.indexWhere((p) => p.id == id);
    _posts[index] = updatedPost;
    
    return updatedPost;
  }
}
```

**Key Features**:
- **Implements interface**: Must provide all methods defined in `PostRepository`
- **Private data storage**: `_posts` list for in-memory storage
- **ID management**: Auto-incrementing IDs for new posts
- **Simulated delays**: Mimics real network operations
- **Error handling**: Proper exception handling for edge cases
- **Data validation**: Ensures data integrity

## 🔄 Integration with Provider

### **Provider Usage**

**Location**: `lib/providers/post_provider.dart`

**Purpose**: Business logic layer that uses the repository

```dart
class PostProvider extends ChangeNotifier {
  // Repository dependency
  final PostRepository _repository;
  
  // State variables
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  // Constructor with dependency injection
  PostProvider({PostRepository? repository}) 
    : _repository = repository ?? PostRepositoryImpl();

  // Public getters
  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  PostRepository get repository => _repository;

  // Business logic methods
  Future<void> loadPosts() async {
    _setLoading(true);
    _clearError();
    
    try {
      final posts = await _repository.getAllPosts();
      _posts = posts;
    } catch (e) {
      _error = 'Failed to load posts: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addPost(Post post) async {
    _setLoading(true);
    _clearError();
    
    try {
      final newPost = await _repository.createPost(post);
      _posts.add(newPost);
    } catch (e) {
      _error = 'Failed to create post: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> togglePostStatus(String id) async {
    try {
      final updatedPost = await _repository.togglePostStatus(id);
      final index = _posts.indexWhere((post) => post.id == id);
      if (index != -1) {
        _posts[index] = updatedPost;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update post status: $e';
      notifyListeners();
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
```

**Key Points**:
- **Repository injection**: Provider receives repository in constructor
- **Default implementation**: Falls back to `PostRepositoryImpl` if none provided
- **State management**: Manages loading, error, and data states
- **Error handling**: Catches and stores repository errors
- **UI updates**: Calls `notifyListeners()` to update UI

## 🧪 Testing with Repository Pattern

### **Mock Repository**

**Location**: `test/mocks/mock_post_repository.dart`

**Purpose**: Test double for repository in unit tests

```dart
class MockPostRepository extends Mock implements PostRepository {
  // Override methods for testing
  @override
  Future<List<Post>> getAllPosts() async {
    return [
      Post(
        id: '1',
        title: 'Test Post 1',
        content: 'Test content 1',
        date: DateTime.now(),
        isPosted: false,
        postedBy: 'Test User',
        tags: ['test'],
        platforms: [SocialPlatform.linkedin],
        additionalLinks: [],
      ),
      Post(
        id: '2',
        title: 'Test Post 2',
        content: 'Test content 2',
        date: DateTime.now().add(const Duration(days: 1)),
        isPosted: true,
        postedBy: 'Test User',
        tags: ['test'],
        platforms: [SocialPlatform.twitter],
        additionalLinks: [],
      ),
    ];
  }

  @override
  Future<Post?> getPostById(String id) async {
    final posts = await getAllPosts();
    try {
      return posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Post> createPost(Post post) async {
    return post.copyWith(id: 'new_id');
  }

  @override
  Future<Post> updatePost(Post post) async {
    return post;
  }

  @override
  Future<bool> deletePost(String id) async {
    return true;
  }

  @override
  Future<Post> togglePostStatus(String id) async {
    final post = await getPostById(id);
    if (post == null) {
      throw Exception('Post not found');
    }
    return post.copyWith(
      isPosted: !post.isPosted,
      postedAt: !post.isPosted ? DateTime.now() : null,
    );
  }
}
```

### **Provider Testing**

**Location**: `test/providers/post_provider_test.dart`

**Purpose**: Test provider logic with mock repository

```dart
void main() {
  group('PostProvider', () {
    late PostProvider postProvider;
    late MockPostRepository mockRepository;

    setUp(() {
      mockRepository = MockPostRepository();
      postProvider = PostProvider(repository: mockRepository);
    });

    test('should load posts successfully', () async {
      // Act
      await postProvider.loadPosts();

      // Assert
      expect(postProvider.posts.length, equals(2));
      expect(postProvider.isLoading, isFalse);
      expect(postProvider.error, isNull);
    });

    test('should handle errors when loading posts', () async {
      // Arrange
      when(mockRepository.getAllPosts()).thenThrow('Network error');

      // Act
      await postProvider.loadPosts();

      // Assert
      expect(postProvider.error, contains('Network error'));
      expect(postProvider.isLoading, isFalse);
    });

    test('should create post successfully', () async {
      // Arrange
      final newPost = Post(
        id: '',
        title: 'New Post',
        content: 'New content',
        date: DateTime.now(),
        isPosted: false,
        postedBy: 'User',
        tags: [],
        platforms: [],
        additionalLinks: [],
      );

      // Act
      await postProvider.addPost(newPost);

      // Assert
      expect(postProvider.posts.length, equals(3));
      expect(postProvider.posts.last.title, equals('New Post'));
    });

    test('should toggle post status', () async {
      // Arrange
      await postProvider.loadPosts();
      final initialPost = postProvider.posts.first;
      final initialStatus = initialPost.isPosted;

      // Act
      await postProvider.togglePostStatus(initialPost.id);

      // Assert
      final updatedPost = postProvider.posts.first;
      expect(updatedPost.isPosted, equals(!initialStatus));
    });
  });
}
```

## 🔮 Future Repository Implementations

### **Database Repository**

**Purpose**: Persistent storage using SQLite or similar

```dart
class DatabasePostRepository implements PostRepository {
  final Database _database;
  
  DatabasePostRepository(this._database);

  @override
  Future<List<Post>> getAllPosts() async {
    final results = await _database.query('posts');
    return results.map((row) => Post.fromMap(row)).toList();
  }

  @override
  Future<Post> createPost(Post post) async {
    final id = await _database.insert('posts', post.toMap());
    return post.copyWith(id: id.toString());
  }

  // ... other methods
}
```

### **API Repository**

**Purpose**: Remote data storage using REST API

```dart
class ApiPostRepository implements PostRepository {
  final http.Client _httpClient;
  final String _baseUrl;
  
  ApiPostRepository(this._httpClient, this._baseUrl);

  @override
  Future<List<Post>> getAllPosts() async {
    final response = await _httpClient.get(Uri.parse('$_baseUrl/posts'));
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Post> createPost(Post post) async {
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(post.toJson()),
    );
    
    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create post');
    }
  }

  // ... other methods
}
```

### **Hybrid Repository**

**Purpose**: Combine local and remote storage

```dart
class HybridPostRepository implements PostRepository {
  final PostRepository _localRepository;
  final PostRepository _remoteRepository;
  final bool _isOnline;
  
  HybridPostRepository(this._localRepository, this._remoteRepository, this._isOnline);

  @override
  Future<List<Post>> getAllPosts() async {
    if (_isOnline) {
      try {
        final posts = await _remoteRepository.getAllPosts();
        // Cache locally
        await _cachePostsLocally(posts);
        return posts;
      } catch (e) {
        // Fallback to local
        return await _localRepository.getAllPosts();
      }
    } else {
      return await _localRepository.getAllPosts();
    }
  }

  // ... other methods with similar offline-first logic
}
```

## 📚 Best Practices

### **1. Interface Design**
- **Keep interfaces focused**: One repository per domain entity
- **Use meaningful names**: Method names should reflect business operations
- **Consistent patterns**: Similar operations should have similar signatures
- **Error handling**: Define how errors are communicated

### **2. Implementation**
- **Single responsibility**: Each repository handles one entity type
- **Data validation**: Validate data before storage
- **Error handling**: Provide meaningful error messages
- **Performance**: Consider caching and optimization strategies

### **3. Testing**
- **Mock repositories**: Use test doubles for unit testing
- **Test edge cases**: Cover error scenarios and boundary conditions
- **Integration tests**: Test with real data sources
- **Performance tests**: Ensure acceptable response times

### **4. Error Handling**
```dart
@override
Future<Post> getPostById(String id) async {
  try {
    final post = await _dataSource.getPost(id);
    if (post == null) {
      throw PostNotFoundException('Post with id $id not found');
    }
    return post;
  } catch (e) {
    if (e is PostNotFoundException) {
      rethrow;
    }
    throw RepositoryException('Failed to retrieve post: $e');
  }
}
```

## 🔧 Advanced Patterns

### **1. Repository Factory**

**Purpose**: Create appropriate repository based on configuration

```dart
class RepositoryFactory {
  static PostRepository createPostRepository(RepositoryType type) {
    switch (type) {
      case RepositoryType.memory:
        return PostRepositoryImpl();
      case RepositoryType.database:
        return DatabasePostRepository(DatabaseHelper.instance);
      case RepositoryType.api:
        return ApiPostRepository(http.Client(), 'https://api.example.com');
      default:
        throw ArgumentError('Unknown repository type: $type');
    }
  }
}

enum RepositoryType { memory, database, api }
```

### **2. Repository Decorator**

**Purpose**: Add functionality without modifying existing repositories

```dart
class CachingPostRepository implements PostRepository {
  final PostRepository _repository;
  final Map<String, Post> _cache = {};
  
  CachingPostRepository(this._repository);

  @override
  Future<Post?> getPostById(String id) async {
    if (_cache.containsKey(id)) {
      return _cache[id];
    }
    
    final post = await _repository.getPostById(id);
    if (post != null) {
      _cache[id] = post;
    }
    
    return post;
  }

  // ... other methods with caching logic
}
```

### **3. Repository Observer**

**Purpose**: Notify interested parties of data changes

```dart
class ObservablePostRepository implements PostRepository {
  final PostRepository _repository;
  final List<RepositoryObserver> _observers = [];
  
  ObservablePostRepository(this._repository);

  void addObserver(RepositoryObserver observer) {
    _observers.add(observer);
  }

  void removeObserver(RepositoryObserver observer) {
    _observers.remove(observer);
  }

  void _notifyObservers(RepositoryEvent event) {
    for (final observer in _observers) {
      observer.onRepositoryEvent(event);
    }
  }

  @override
  Future<Post> createPost(Post post) async {
    final newPost = await _repository.createPost(post);
    _notifyObservers(RepositoryEvent.postCreated(newPost));
    return newPost;
  }

  // ... other methods with notification logic
}

abstract class RepositoryObserver {
  void onRepositoryEvent(RepositoryEvent event);
}

class RepositoryEvent {
  final RepositoryEventType type;
  final dynamic data;
  
  RepositoryEvent(this.type, this.data);
  
  factory RepositoryEvent.postCreated(Post post) {
    return RepositoryEvent(RepositoryEventType.postCreated, post);
  }
}

enum RepositoryEventType { postCreated, postUpdated, postDeleted }
```

## 📖 Additional Resources

### **Official Documentation**
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Dart Testing](https://dart.dev/guides/testing)
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)

### **Community Resources**
- [Flutter Architecture Samples](https://github.com/flutter/samples)
- [Clean Architecture in Flutter](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

*The Repository Pattern in SocialShare provides a clean, testable, and maintainable approach to data access. By abstracting data operations behind interfaces, the application becomes more flexible and easier to extend with new data sources in the future.*
