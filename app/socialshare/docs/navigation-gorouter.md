# Navigation with GoRouter

## 🎯 What is GoRouter?

**GoRouter** is Flutter's official routing solution that provides a declarative way to handle navigation in your app. It's designed to be simple, powerful, and easy to use, making it perfect for both simple and complex navigation scenarios.

Think of GoRouter as a **navigation manager** that:
- Defines all the routes (screens) in your app
- Handles navigation between screens
- Manages URL-based navigation (for web)
- Provides deep linking capabilities
- Handles navigation state and history

## 🔍 Why GoRouter Instead of Navigator?

### **Traditional Navigator Approach**
```dart
// ❌ OLD WAY: Manual navigation
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PostDetailScreen(postId: '123'),
  ),
);

// ❌ Hard to manage complex navigation
// ❌ No URL support for web
// ❌ Difficult to handle deep links
// ❌ Navigation state is scattered
```

### **GoRouter Approach**
```dart
// ✅ NEW WAY: Declarative routing
context.go('/post/123');

// ✅ Clean and simple
// ✅ URL support for web
// ✅ Easy deep linking
// ✅ Centralized navigation logic
```

## 🏗️ GoRouter Architecture in SocialShare

### **Router Configuration**

```dart
// lib/utils/router.dart
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/calendar',
      name: 'calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/create',
      name: 'create',
              builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final editPost = extra?['editPost'] as Post?;
          return CreateEditPostScreen(postToEdit: editPost);
        },
    ),
    GoRoute(
      path: '/post/:id',
      name: 'post',
      builder: (context, state) {
        final postId = state.pathParameters['id']!;
        return PostDetailScreen(postId: postId);
      },
    ),
  ],
);
```

### **App Integration**

```dart
// lib/main.dart
class SocialShareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router, // Use GoRouter instead of routes
      title: 'SocialShare',
      theme: AppTheme.lightTheme,
    );
  }
}
```

## 🧩 Route Definitions

### **Basic Route Structure**

```dart
GoRoute(
  path: '/path',           // URL path
  name: 'routeName',       // Route identifier
  builder: (context, state) => Widget(), // Screen builder
)
```

### **Route Types in SocialShare**

#### **1. Static Routes**
```dart
GoRoute(
  path: '/',
  name: 'home',
  builder: (context, state) => const HomeScreen(),
),
```

#### **2. Parameter Routes**
```dart
GoRoute(
  path: '/post/:id',
  name: 'post',
  builder: (context, state) {
    final postId = state.pathParameters['id']!;
    return PostDetailScreen(postId: postId);
  },
),
```

#### **3. Query Parameter Routes**
```dart
GoRoute(
  path: '/search',
  name: 'search',
  builder: (context, state) {
    final query = state.queryParameters['q'] ?? '';
    return SearchScreen(query: query);
  },
),
```

#### **4. Nested Routes**
```dart
GoRoute(
  path: '/admin',
  name: 'admin',
  builder: (context, state) => const AdminLayout(),
  routes: [
    GoRoute(
      path: 'users',
      name: 'admin.users',
      builder: (context, state) => const UserManagementScreen(),
    ),
    GoRoute(
      path: 'posts',
      name: 'admin.posts',
      builder: (context, state) => const PostManagementScreen(),
    ),
  ],
),
```

## 🚀 Navigation Methods

### **1. Basic Navigation**

```dart
// Navigate to a new screen
context.go('/calendar');

// Navigate and replace current screen (no back button)
context.go('/home');

// Navigate and clear navigation stack
context.go('/home', extra: {'clearStack': true});
```

### **2. Named Navigation**

```dart
// Navigate using route names
context.goNamed('calendar');

// Navigate with parameters
context.goNamed('post', pathParameters: {'id': '123'});

// Navigate with query parameters
context.goNamed('search', queryParameters: {'q': 'flutter'});
```

### **3. Navigation with Data**

```dart
// Pass data to the next screen
context.go('/create', extra: {'editPost': existingPost});

// Access the data in the destination screen
class CreatePostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editPost = GoRouterState.of(context).extra as Post?;
    
    return Scaffold(
      body: editPost != null 
        ? EditPostForm(post: editPost)
        : CreatePostForm(),
    );
  }
}
```

### **4. Navigation with Parameters**

```dart
// Navigate with path parameters
context.go('/post/123');

// Navigate with query parameters
context.go('/search?q=flutter&category=tech');

// Navigate with both
context.go('/post/123?edit=true');
```

## 📱 Navigation Implementation in SocialShare

### **Navigation Rail Integration**

```dart
// lib/widgets/navigation_rail.dart
class CustomNavigationRail extends StatefulWidget {
  @override
  _CustomNavigationRailState createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  int _selectedIndex = 0;

  void _navigateToRoute(int index) {
    switch (index) {
      case 0:
        context.go('/');           // Home
        break;
      case 1:
        context.go('/calendar');   // Calendar
        break;
      case 2:
        context.go('/create');     // Create Post
        break;
      case 3:
        // Future: Analytics
        break;
      case 4:
        // Future: Settings
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
        _navigateToRoute(index);
      },
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.calendar_today),
          label: Text('Calendar'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.add),
          label: Text('Create'),
        ),
        // ... more destinations
      ],
    );
  }
}
```

### **Screen-to-Screen Navigation**

```dart
// lib/screens/home_screen.dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          return GridView.builder(
            itemBuilder: (context, index) {
              final post = postProvider.posts[index];
              return PostCard(
                post: post,
                onTap: () {
                  // Navigate to post detail
                  context.go('/post/${post.id}');
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create post
          context.go('/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### **Form Navigation with Data**

```dart
// lib/screens/post_detail_screen.dart
class PostDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PostHeaderWidget(
            post: post,
            onEdit: () {
              // Navigate to create screen with edit data
              context.go('/create', extra: {'editPost': post});
            },
          ),
          // ... rest of the screen
        ],
      ),
    );
  }
}
```

## 🔄 Navigation State Management

### **Current Route Detection**

```dart
// Check current route
final currentRoute = GoRouterState.of(context).uri.path;

// Check if on specific route
if (currentRoute == '/calendar') {
  // Update navigation rail selection
  _selectedIndex = 1;
}
```

### **Route Change Listeners**

```dart
// Listen to route changes
GoRouter.of(context).addListener(() {
  final currentRoute = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
  // Handle route change
  _updateNavigationState(currentRoute);
});
```

### **Navigation History**

```dart
// Go back
context.pop();

// Go back to specific route
context.go('/home');

// Check if can go back
if (context.canPop()) {
  context.pop();
}
```

## 🌐 Web Navigation Support

### **URL-Based Navigation**

```dart
// Web URLs automatically work
// /post/123 → PostDetailScreen with id '123'
// /calendar → CalendarScreen
// /create → CreateEditPostScreen (Create or Edit)

// Deep linking support
// https://yourapp.com/post/123 → Direct navigation to post
```

### **Web-Specific Features**

```dart
// Browser back/forward buttons work automatically
// URL updates as you navigate
// Bookmarkable URLs
// Shareable links
```

## 🧪 Testing Navigation

### **Unit Testing Routes**

```dart
void main() {
  group('Router Tests', () {
    test('should navigate to home route', () {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
        ],
      );
      
      expect(router.routerDelegate.currentConfiguration.uri.path, equals('/'));
    });
  });
}
```

### **Widget Testing Navigation**

```dart
void main() {
  group('Navigation Tests', () {
    testWidgets('should navigate to post detail on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          home: const HomeScreen(),
        ),
      );

      // Tap on a post card
      await tester.tap(find.byType(PostCard));
      await tester.pumpAndSettle();

      // Should be on post detail screen
      expect(find.byType(PostDetailScreen), findsOneWidget);
    });
  });
}
```

## 📚 Best Practices

### **1. Route Organization**

```dart
// ✅ GOOD: Organized by feature
final router = GoRouter(
  routes: [
    // Main app routes
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/calendar', builder: (context, state) => const CalendarScreen()),
    
    // Post management routes
    GoRoute(
  path: '/create', 
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    final editPost = extra?['editPost'] as Post?;
    return CreateEditPostScreen(postToEdit: editPost);
  },
),
    GoRoute(path: '/post/:id', builder: (context, state) => PostDetailScreen(...)),
    
    // Admin routes (nested)
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminLayout(),
      routes: [
        GoRoute(path: 'users', builder: (context, state) => const UserScreen()),
        GoRoute(path: 'settings', builder: (context, state) => const SettingsScreen()),
      ],
    ),
  ],
);
```

### **2. Parameter Validation**

```dart
GoRoute(
  path: '/post/:id',
  builder: (context, state) {
    final postId = state.pathParameters['id'];
    
    // Validate parameter
    if (postId == null || postId.isEmpty) {
      return const ErrorScreen(message: 'Invalid post ID');
    }
    
    return PostDetailScreen(postId: postId);
  },
),
```

### **3. Error Handling**

```dart
final router = GoRouter(
  routes: [
    // ... your routes
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
  redirect: (context, state) {
    // Handle authentication, permissions, etc.
    if (needsAuth && !isAuthenticated) {
      return '/login';
    }
    return null; // No redirect needed
  },
);
```

### **4. Navigation Constants**

```dart
// lib/constants/routes.dart
class AppRoutes {
  static const String home = '/';
  static const String calendar = '/calendar';
  static const String create = '/create';
  static const String post = '/post';
  
  static String postDetail(String id) => '/post/$id';
  static String search(String query) => '/search?q=$query';
}

// Usage
context.go(AppRoutes.calendar);
context.go(AppRoutes.postDetail('123'));
```

## 🔮 Advanced Features

### **1. Route Guards**

```dart
final router = GoRouter(
  redirect: (context, state) {
    // Check authentication
    if (state.matchedLocation.startsWith('/admin') && !isAdmin) {
      return '/unauthorized';
    }
    
    // Check permissions
    if (state.matchedLocation.startsWith('/premium') && !hasPremium) {
      return '/upgrade';
    }
    
    return null; // Allow navigation
  },
  routes: [
    // ... routes
  ],
);
```

### **2. Custom Transitions**

```dart
GoRoute(
  path: '/post/:id',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: PostDetailScreen(postId: state.pathParameters['id']!),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
          ),
          child: child,
        );
      },
    );
  },
),
```

### **3. Nested Navigation**

```dart
GoRoute(
  path: '/dashboard',
  builder: (context, state) => const DashboardLayout(),
  routes: [
    GoRoute(
      path: 'overview',
      builder: (context, state) => const OverviewScreen(),
    ),
    GoRoute(
      path: 'analytics',
      builder: (context, state) => const AnalyticsScreen(),
    ),
  ],
),
```

## 🚀 Performance Considerations

### **Lazy Loading**

```dart
GoRoute(
  path: '/heavy-screen',
  builder: (context, state) => const HeavyScreen(),
  // Consider lazy loading for heavy screens
),
```

### **Route Caching**

```dart
final router = GoRouter(
  routes: [
    // Routes are cached by default
    // Use pageBuilder for custom caching behavior
  ],
);
```

## 📖 Additional Resources

- [Official GoRouter Documentation](https://pub.dev/packages/go_router)
- [GoRouter Examples](https://github.com/flutter/packages/tree/main/packages/go_router/example)
- [Flutter Navigation Guide](https://docs.flutter.dev/development/ui/navigation)

---

*GoRouter provides a modern, powerful, and easy-to-use navigation solution for Flutter applications. It's the official recommendation from the Flutter team and offers excellent support for both mobile and web platforms. The patterns you learn here will help you build robust navigation systems in your Flutter apps.*
