# Development Guidelines

## 🎯 Overview

This document provides comprehensive development guidelines for the SocialShare application. Following these guidelines ensures code quality, consistency, and maintainability across the project.

## 📋 Table of Contents

1. [Code Style & Standards](#code-style--standards)
2. [Architecture Guidelines](#architecture-guidelines)
3. [State Management Guidelines](#state-management-guidelines)
4. [Widget Development Guidelines](#widget-development-guidelines)
5. [Testing Guidelines](#testing-guidelines)
6. [Performance Guidelines](#performance-guidelines)
7. [Security Guidelines](#security-guidelines)
8. [Documentation Guidelines](#documentation-guidelines)
9. [Git Workflow](#git-workflow)
10. [Code Review Process](#code-review-process)

## 🎨 Code Style & Standards

### **Rich Content Guidelines**

#### **1. Emoji Usage**
```dart
// ✅ GOOD: Use emojis to enhance readability and engagement
title: '🚀 Are you working on the cutting edge of AI?'
content: '🧠 GenAI • LLMs • Multimodal apps • AI agents • MLOps • Ethics • And more!'

// ❌ BAD: Overuse of emojis or inappropriate placement
title: '🚀🧠🤖 Are you working on the cutting edge of AI? 🤖🧠🚀'
```

#### **2. Text Formatting**
```dart
// ✅ GOOD: Use line breaks and bullet points for readability
content: 'We\'re looking for speakers ready to share their insights:\n\n'
         '• GenAI and LLMs\n'
         '• Multimodal applications\n'
         '• AI agents and MLOps\n'
         '• Ethics and responsible AI'

// ❌ BAD: Long unformatted text without breaks
content: 'We\'re looking for speakers ready to share their insights in GenAI and LLMs and multimodal applications and AI agents and MLOps and ethics and responsible AI.'
```

#### **3. Hashtag Management**
```dart
// ✅ GOOD: Relevant, specific hashtags
tags: ['AI', 'GenAI', 'LLMs', 'MLOps', 'speakers', 'GoogleIO']

// ❌ BAD: Generic or irrelevant hashtags
tags: ['tech', 'event', 'post', 'update', 'news']
```

#### **4. Link Organization**
```dart
// ✅ GOOD: Clear call-to-action with descriptive text
'👉 Apply to speak: https://lnkd.in/egqefzA2'
'🎟️ Grab your ticket: https://lnkd.in/efcRfi9T'

// ❌ BAD: Raw URLs without context
'https://lnkd.in/egqefzA2'
'https://lnkd.in/efcRfi9T'
```

### **Dart/Flutter Standards**

#### **1. Naming Conventions**
```dart
// ✅ GOOD: Clear, descriptive names
class PostDetailScreen extends StatelessWidget {}
class PostRepositoryImpl implements PostRepository {}
final List<Post> _posts = [];

// ❌ BAD: Unclear, abbreviated names
class PDS extends StatelessWidget {}
class PostRepoImpl implements PostRepository {}
final List<Post> p = [];
```

#### **2. File Naming**
```
// ✅ GOOD: snake_case for files
post_detail_screen.dart
post_repository.dart
custom_navigation_rail.dart

// ❌ BAD: camelCase or PascalCase for files
postDetailScreen.dart
PostRepository.dart
CustomNavigationRail.dart
```

#### **3. Class Naming**
```dart
// ✅ GOOD: PascalCase for classes
class PostDetailScreen extends StatelessWidget {}
class PostRepositoryImpl implements PostRepository {}
class CustomNavigationRail extends StatefulWidget {}

// ❌ BAD: camelCase for classes
class postDetailScreen extends StatelessWidget {}
class postRepositoryImpl implements PostRepository {}
```

#### **4. Variable Naming**
```dart
// ✅ GOOD: camelCase for variables
final String postTitle = 'Welcome';
final bool isLoading = false;
final List<Post> userPosts = [];

// ❌ BAD: snake_case for variables
final String post_title = 'Welcome';
final bool is_loading = false;
final List<Post> user_posts = [];
```

#### **5. Private Members**
```dart
// ✅ GOOD: Underscore prefix for private members
class PostProvider extends ChangeNotifier {
  final PostRepository _repository;
  List<Post> _posts = [];
  
  void _setLoading(bool loading) {}
}

// ❌ BAD: No underscore for private members
class PostProvider extends ChangeNotifier {
  final PostRepository repository;
  List<Post> posts = [];
  
  void setLoading(bool loading) {}
}
```

### **Code Formatting**

#### **1. Indentation**
```dart
// ✅ GOOD: 2-space indentation
class PostCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(post.title),
            Text(post.content),
          ],
        ),
      ),
    );
  }
}
```

#### **2. Line Length**
```dart
// ✅ GOOD: Break long lines at 80-100 characters
Widget build(BuildContext context) {
  return Consumer<PostProvider>(
    builder: (context, postProvider, child) {
      return ListView.builder(
        itemCount: postProvider.posts.length,
        itemBuilder: (context, index) {
          final post = postProvider.posts[index];
          return PostCard(post: post);
        },
      );
    },
  );
}

// ❌ BAD: Very long lines
Widget build(BuildContext context) { return Consumer<PostProvider>(builder: (context, postProvider, child) { return ListView.builder(itemCount: postProvider.posts.length, itemBuilder: (context, index) { final post = postProvider.posts[index]; return PostCard(post: post); }); }); }
```

#### **3. Spacing**
```dart
// ✅ GOOD: Consistent spacing
class PostProvider extends ChangeNotifier {
  final PostRepository _repository;
  List<Post> _posts = [];
  bool _isLoading = false;

  PostProvider({PostRepository? repository})
      : _repository = repository ?? PostRepositoryImpl();

  Future<void> loadPosts() async {
    _setLoading(true);
    try {
      final posts = await _repository.getAllPosts();
      _posts = posts;
    } catch (e) {
      _error = 'Failed to load posts: $e';
    } finally {
      _setLoading(false);
    }
  }
}
```

## 🏗️ Architecture Guidelines

### **1. Layer Separation**

#### **Presentation Layer**
- **Responsibility**: UI components and user interaction
- **Components**: Screens, widgets, theme
- **Rules**: No business logic, minimal state management

```dart
// ✅ GOOD: UI-only logic
class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Text(post.title),
      ),
    );
  }
}

// ❌ BAD: Business logic in UI
class PostCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        // Business logic here
        final posts = provider.posts.where((p) => p.isPosted).toList();
        return Text('Posted: ${posts.length}');
      },
    );
  }
}
```

#### **Business Logic Layer**
- **Responsibility**: Application state and business rules
- **Components**: Providers, services
- **Rules**: No UI logic, no direct data access

```dart
// ✅ GOOD: Business logic only
class PostProvider extends ChangeNotifier {
  Future<void> togglePostStatus(String id) async {
    try {
      final updatedPost = await _repository.togglePostStatus(id);
      _updatePostInList(updatedPost);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update post status: $e';
      notifyListeners();
    }
  }
}

// ❌ BAD: UI logic in provider
class PostProvider extends ChangeNotifier {
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
```

#### **Data Layer**
- **Responsibility**: Data access and storage
- **Components**: Repositories, models
- **Rules**: No business logic, no UI logic

```dart
// ✅ GOOD: Data access only
class PostRepositoryImpl implements PostRepository {
  @override
  Future<Post> createPost(Post post) async {
    final newPost = post.copyWith(id: _generateId());
    _posts.add(newPost);
    return newPost;
  }
}

// ❌ BAD: Business logic in repository
class PostRepositoryImpl implements PostRepository {
  @override
  Future<Post> createPost(Post post) async {
    // Business validation here
    if (post.title.isEmpty) {
      throw Exception('Title cannot be empty');
    }
    // ... rest of implementation
  }
}
```

### **2. Dependency Injection**

#### **Constructor Injection**
```dart
// ✅ GOOD: Dependencies injected via constructor
class PostProvider extends ChangeNotifier {
  final PostRepository _repository;
  
  PostProvider({PostRepository? repository})
      : _repository = repository ?? PostRepositoryImpl();
}

// ❌ BAD: Dependencies created inside class
class PostProvider extends ChangeNotifier {
  final PostRepository _repository = PostRepositoryImpl();
}
```

#### **Service Locator Pattern**
```dart
// ✅ GOOD: Service locator for global dependencies
class ServiceLocator {
  static final PostRepository _postRepository = PostRepositoryImpl();
  static final PostService _postService = PostServiceImpl(_postRepository);
  
  static PostRepository get postRepository => _postRepository;
  static PostService get postService => _postService;
}

// Usage
final postProvider = PostProvider(
  repository: ServiceLocator.postRepository,
);
```

### **3. Error Handling**

#### **Exception Types**
```dart
// ✅ GOOD: Custom exception types
class PostNotFoundException implements Exception {
  final String message;
  PostNotFoundException(this.message);
  
  @override
  String toString() => 'PostNotFoundException: $message';
}

class RepositoryException implements Exception {
  final String message;
  final dynamic originalError;
  
  RepositoryException(this.message, [this.originalError]);
  
  @override
  String toString() => 'RepositoryException: $message';
}
```

#### **Error Handling in Providers**
```dart
// ✅ GOOD: Proper error handling
Future<void> loadPosts() async {
  _setLoading(true);
  _clearError();
  
  try {
    final posts = await _repository.getAllPosts();
    _posts = posts;
  } catch (e) {
    if (e is PostNotFoundException) {
      _error = 'No posts found';
    } else if (e is RepositoryException) {
      _error = 'Failed to load posts: ${e.message}';
    } else {
      _error = 'An unexpected error occurred';
    }
  } finally {
    _setLoading(false);
  }
}
```

## 📊 State Management Guidelines

### **1. Provider Usage**

#### **When to Use Provider**
```dart
// ✅ GOOD: Shared state across multiple widgets
class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  List<Post> get posts => _posts;
}

// ✅ GOOD: Complex state with multiple properties
class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
}

// ❌ BAD: Simple local state
class PostCard extends StatefulWidget {
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isExpanded = false; // Simple local state
  
  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>( // Unnecessary provider usage
      builder: (context, provider, child) {
        return Text(widget.post.title);
      },
    );
  }
}
```

#### **Provider Organization**
```dart
// ✅ GOOD: One provider per domain
class PostProvider extends ChangeNotifier {
  // Post-related state only
}

class UserProvider extends ChangeNotifier {
  // User-related state only
}

// ❌ BAD: Multiple domains in one provider
class AppProvider extends ChangeNotifier {
  // Posts, users, settings, theme, etc.
  List<Post> _posts = [];
  User? _currentUser;
  ThemeData _theme;
  AppSettings _settings;
}
```

### **2. State Updates**

#### **Efficient Updates**
```dart
// ✅ GOOD: Only notify when state actually changes
void updatePost(Post updatedPost) {
  final index = _posts.indexWhere((p) => p.id == updatedPost.id);
  if (index != -1 && _posts[index] != updatedPost) {
    _posts[index] = updatedPost;
    notifyListeners(); // Only if something changed
  }
}

// ❌ BAD: Always notifying
void updatePost(Post updatedPost) {
  _posts[0] = updatedPost;
  notifyListeners(); // Always calls, even if no change
}
```

#### **Batch Updates**
```dart
// ✅ GOOD: Batch multiple updates
void loadPosts() async {
  _setLoading(true);
  _clearError();
  
  try {
    final posts = await _repository.getAllPosts();
    _posts = posts;
    _lastUpdated = DateTime.now();
  } catch (e) {
    _error = 'Failed to load posts: $e';
  } finally {
    _setLoading(false);
    // Single notifyListeners() call
  }
}

// ❌ BAD: Multiple notifyListeners() calls
void loadPosts() async {
  _isLoading = true;
  notifyListeners(); // First call
  
  try {
    final posts = await _repository.getAllPosts();
    _posts = posts;
    notifyListeners(); // Second call
  } catch (e) {
    _error = 'Failed to load posts: $e';
    notifyListeners(); // Third call
  } finally {
    _isLoading = false;
    notifyListeners(); // Fourth call
  }
}
```

## 🧩 Widget Development Guidelines

### **1. Widget Composition**

#### **Break Down Large Widgets**
```dart
// ✅ GOOD: Small, focused widgets
class PostDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PostHeaderWidget(post: post),
        PostContentWidget(post: post),
        PostMediaWidget(post: post),
        PostDetailsGridWidget(post: post),
        PostTagsPlatformsWidget(post: post),
        PostLinksWidget(links: post.additionalLinks),
      ],
    );
  }
}

// ❌ BAD: One large widget
class PostDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 100+ lines of widget code
      ],
    );
  }
}
```

#### **Reusable Components**
```dart
// ✅ GOOD: Reusable widget
class StatusChip extends StatelessWidget {
  final bool isPosted;
  final String label;
  
  const StatusChip({
    super.key,
    required this.isPosted,
    required this.label,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPosted ? AppTheme.primaryGreen : AppTheme.primaryYellow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Usage
StatusChip(
  isPosted: post.isPosted,
  label: post.isPosted ? 'Posted' : 'Scheduled',
)
```

### **2. Performance Optimization**

#### **Const Constructors**
```dart
// ✅ GOOD: Use const when possible
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: const [
          Text('Title'), // const
          SizedBox(height: 8), // const
          Icon(Icons.star), // const
        ],
      ),
    );
  }
}
```

#### **ListView.builder for Large Lists**
```dart
// ✅ GOOD: Efficient list rendering
ListView.builder(
  itemCount: posts.length,
  itemBuilder: (context, index) {
    final post = posts[index];
    return PostCard(post: post);
  },
)

// ❌ BAD: Inefficient for large lists
Column(
  children: posts.map((post) => PostCard(post: post)).toList(),
)
```

### **3. Responsive Design**

#### **Breakpoint System**
```dart
// ✅ GOOD: Responsive breakpoints
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  
  if (screenWidth < ResponsiveBreakpoints.mobile) {
    return _buildMobileLayout();
  } else if (screenWidth < ResponsiveBreakpoints.tablet) {
    return _buildTabletLayout();
  } else {
    return _buildDesktopLayout();
  }
}
```

## 🧪 Testing Guidelines

### **1. Testing Strategy**

#### **Test Pyramid**
```
┌─────────────────────────────────────────────────────────────┐
│                    E2E Tests (Few)                          │
│                 Integration Tests                           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   Widget Tests (Some)                       │
│                 Component Tests                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   Unit Tests (Many)                         │
│                 Business Logic Tests                        │
└─────────────────────────────────────────────────────────────┘
```

#### **Test Coverage Goals**
- **Unit Tests**: 80%+ coverage
- **Widget Tests**: 60%+ coverage
- **Integration Tests**: 40%+ coverage

### **2. Unit Testing**

#### **Provider Testing**
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
      // Arrange
      final posts = [Post(id: '1', title: 'Test Post')];
      when(mockRepository.getAllPosts()).thenAnswer((_) async => posts);

      // Act
      await postProvider.loadPosts();

      // Assert
      expect(postProvider.posts, equals(posts));
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
  });
}
```

#### **Repository Testing**
```dart
void main() {
  group('PostRepositoryImpl', () {
    late PostRepositoryImpl repository;

    setUp(() {
      repository = PostRepositoryImpl();
    });

    test('should return all posts', () async {
      // Act
      final posts = await repository.getAllPosts();

      // Assert
      expect(posts, isNotEmpty);
      expect(posts.first, isA<Post>());
    });

    test('should create new post with generated ID', () async {
      // Arrange
      final post = Post(
        id: '',
        title: 'Test Post',
        content: 'Test content',
        date: DateTime.now(),
        isPosted: false,
        postedBy: 'Test User',
        tags: [],
        platforms: [],
        additionalLinks: [],
      );

      // Act
      final createdPost = await repository.createPost(post);

      // Assert
      expect(createdPost.id, isNotEmpty);
      expect(createdPost.title, equals('Test Post'));
    });
  });
}
```

### **3. Widget Testing**

#### **Basic Widget Test**
```dart
void main() {
  group('PostCard Widget', () {
    testWidgets('should display post information correctly', (tester) async {
      // Arrange
      final post = Post(
        id: '1',
        title: 'Test Post',
        content: 'Test content',
        date: DateTime.now(),
        isPosted: false,
        postedBy: 'Test User',
        tags: ['test'],
        platforms: [SocialPlatform.linkedin],
        additionalLinks: [],
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: PostCard(
            post: post,
            onTap: () {},
          ),
        ),
      );

      // Assert
      expect(find.text('Test Post'), findsOneWidget);
      expect(find.text('Test content'), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      // Arrange
      bool tapped = false;
      final post = Post(/* ... */);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: PostCard(
            post: post,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(PostCard));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, isTrue);
    });
  });
}
```

### **4. Integration Testing**

#### **Navigation Testing**
```dart
void main() {
  group('App Integration Tests', () {
    testWidgets('should navigate through app screens', (tester) async {
      // Arrange
      await tester.pumpWidget(const SocialShareApp());
      await tester.pumpAndSettle();

      // Act & Assert: Navigate to calendar
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      expect(find.byType(CalendarScreen), findsOneWidget);

      // Act & Assert: Navigate to create post
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.byType(CreateEditPostScreen), findsOneWidget);

      // Act & Assert: Navigate back to home
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
```

## 🚀 Performance Guidelines

### **1. Widget Optimization**

#### **Minimize Rebuilds**
```dart
// ✅ GOOD: Use Selector for specific state
Selector<PostProvider, int>(
  selector: (context, provider) => provider.posts.length,
  builder: (context, count, child) {
    return Text('Post Count: $count');
  },
)

// ❌ BAD: Consumer rebuilds on any state change
Consumer<PostProvider>(
  builder: (context, provider, child) {
    return Text('Post Count: ${provider.posts.length}');
  },
)
```

#### **Lazy Loading**
```dart
// ✅ GOOD: Lazy load expensive widgets
class PostDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PostHeaderWidget(post: post),
        PostContentWidget(post: post),
        if (post.hasMedia) PostMediaWidget(post: post),
        PostDetailsGridWidget(post: post),
        if (post.tags.isNotEmpty) PostTagsWidget(post: post),
      ],
    );
  }
}
```

### **2. Memory Management**

#### **Dispose Resources**
```dart
// ✅ GOOD: Proper resource disposal
class PostDetailScreen extends StatefulWidget {
  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
```

## 🔒 Security Guidelines

### **1. Input Validation**

#### **Form Validation**
```dart
// ✅ GOOD: Validate all inputs
class PostForm extends StatefulWidget {
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    if (value.length > 100) {
      return 'Title must be less than 100 characters';
    }
    return null;
  }

  String? _validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Content is required';
    }
    if (value.length > 1000) {
      return 'Content must be less than 1000 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            validator: _validateTitle,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextFormField(
            controller: _contentController,
            validator: _validateContent,
            decoration: const InputDecoration(labelText: 'Content'),
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}
```

### **2. URL Security**

#### **Safe URL Launching**
```dart
// ✅ GOOD: Validate URLs before launching
Future<void> _launchUrl(String url) async {
  try {
    final uri = Uri.parse(url);
    
    // Validate URL scheme
    if (!['http', 'https', 'mailto', 'tel'].contains(uri.scheme)) {
      throw Exception('Unsupported URL scheme: ${uri.scheme}');
    }
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Cannot launch URL: $url');
    }
  } catch (e) {
    // Handle errors gracefully
    print('Error launching URL: $e');
  }
}
```

## 📚 Documentation Guidelines

### **1. Code Documentation**

#### **Class Documentation**
```dart
/// A provider that manages post-related state and operations.
///
/// This provider handles:
/// - Loading posts from the repository
/// - Creating, updating, and deleting posts
/// - Managing loading and error states
/// - Notifying listeners of state changes
///
/// Example usage:
/// ```dart
/// Consumer<PostProvider>(
///   builder: (context, provider, child) {
///     return ListView.builder(
///       itemCount: provider.posts.length,
///       itemBuilder: (context, index) {
///         return PostCard(post: provider.posts[index]);
///       },
///     );
///   },
/// )
/// ```
class PostProvider extends ChangeNotifier {
  // Implementation...
}
```

#### **Method Documentation**
```dart
/// Loads all posts from the repository.
///
/// This method:
/// 1. Sets the loading state to true
/// 2. Clears any previous errors
/// 3. Fetches posts from the repository
/// 4. Updates the posts list
/// 5. Sets the loading state to false
///
/// Throws a [RepositoryException] if the repository fails to load posts.
/// The error is caught and stored in the [error] property.
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
```

### **2. README Documentation**

#### **Project README**
```markdown
# SocialShare

A social media content management application built with Flutter.

## Features

- Create and schedule social media posts
- Multi-platform support (LinkedIn, Twitter, Facebook, Instagram)
- Calendar view for post scheduling
- Campaign organization and tagging
- Responsive design for desktop and mobile

## Getting Started

1. Clone the repository
2. Install dependencies: `flutter pub get`
3. Run the app: `flutter run`

## Architecture

The app follows Clean Architecture principles with:
- Repository pattern for data access
- Provider pattern for state management
- GoRouter for navigation
- Separation of concerns across layers

## Testing

Run tests with:
- Unit tests: `flutter test`
- Widget tests: `flutter test test/widget_test.dart`
- Integration tests: `flutter test test/integration_test.dart`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request
```

## 🔄 Git Workflow

### **1. Branch Naming**

#### **Feature Branches**
```
feature/user-authentication
feature/post-scheduling
feature/analytics-dashboard
```

#### **Bug Fix Branches**
```
fix/login-validation-error
fix/calendar-navigation-issue
fix/post-creation-crash
```

#### **Hotfix Branches**
```
hotfix/security-vulnerability
hotfix/critical-bug
hotfix/performance-issue
```

### **2. Commit Messages**

#### **Conventional Commits**
```
feat: add user authentication system
fix: resolve calendar navigation issue
docs: update API documentation
style: format code according to style guide
refactor: extract post validation logic
test: add unit tests for PostProvider
chore: update dependencies
```

#### **Commit Message Structure**
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### **3. Pull Request Process**

#### **PR Template**
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No console errors
- [ ] No lint warnings
```

## 👥 Code Review Process

### **1. Review Checklist**

#### **Code Quality**
- [ ] Code follows style guidelines
- [ ] No lint warnings or errors
- [ ] Proper error handling
- [ ] Input validation implemented
- [ ] Performance considerations addressed

#### **Testing**
- [ ] Unit tests added for new functionality
- [ ] Widget tests for UI components
- [ ] Integration tests for user flows
- [ ] Test coverage maintained or improved

#### **Documentation**
- [ ] Code documented with clear comments
- [ ] README updated if needed
- [ ] API documentation updated
- [ ] Architecture decisions documented

### **2. Review Process**

#### **Review Steps**
1. **Automated Checks**: CI/CD pipeline runs tests and linting
2. **Code Review**: Team member reviews the PR
3. **Testing**: Manual testing of the changes
4. **Approval**: PR approved by at least one team member
5. **Merge**: Changes merged to main branch

#### **Review Comments**
```markdown
## Code Review

### ✅ Good
- Clean separation of concerns
- Proper error handling
- Good test coverage

### 🔧 Suggestions
- Consider extracting validation logic to a separate class
- Add more specific error messages
- Consider caching for performance

### ❌ Issues
- Missing null check on line 45
- Unused import on line 12
- Hardcoded string should be localized

### 📝 Questions
- Why was this approach chosen over alternatives?
- How does this handle edge cases?
- What's the performance impact of this change?
```

---

*Following these development guidelines ensures consistent, high-quality code that is maintainable, testable, and follows Flutter best practices. Regular code reviews and adherence to these standards help maintain the quality of the SocialShare application.*
