# App Flow & Navigation

## 🎯 Overview

This document explains the complete user journey and navigation flow in the SocialShare application. Understanding the app flow helps developers see how different screens connect and how users navigate through the application.

## 🔄 User Journey Flow

### **Complete User Journey**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   App Launch    │───▶│   Home Screen   │───▶│  Browse Posts   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Authentication │    │  Calendar View  │    │  Post Details   │
│   (Future)      │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Dashboard     │    │  Date Selection │    │   Edit Post     │
│                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Create Post    │    │  View Posts     │    │  Save Changes   │
│                 │    │  for Date       │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Post Form      │    │  Post Actions   │    │  Navigation     │
│  Completion     │    │  (Edit/Delete)  │    │  Back to Home   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🏠 Screen-by-Screen Flow

### **1. App Launch & Initialization**

```
App Launch
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│                    Main App Entry                           │
├─────────────────────────────────────────────────────────────┤
│ 1. Initialize Flutter app                                  │
│ 2. Set up Provider (PostProvider)                          │
│ 3. Configure GoRouter                                      │
│ 4. Load initial theme and settings                         │
│ 5. Navigate to initial route ('/')                         │
└─────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│                    Home Screen                              │
├─────────────────────────────────────────────────────────────┤
│ • CustomNavigationRail (left sidebar)                      │
│ • OrganizationHeader (top banner)                          │
│ • Post Grid/List (main content)                            │
│ • Floating Action Button (Create Post)                     │
└─────────────────────────────────────────────────────────────┘
```

**User Actions Available**:
- Navigate to Calendar view
- Navigate to Create Post
- View post details
- Search posts
- Toggle between grid/list view

### **2. Home Screen Navigation**

```
Home Screen
    │
    ├─── Navigate to Calendar ──┐
    │                           │
    ├─── Navigate to Create ────┤
    │                           │
    ├─── View Post Details ─────┤
    │                           │
    └─── Search & Filter ───────┘
```

**Navigation Options**:
- **Left Sidebar**: Navigation rail with main sections
- **Post Cards**: Tap to view post details
- **FAB**: Quick access to create new post
- **Search Bar**: Filter posts by content

### **3. Calendar Screen Flow**

```
Calendar Screen
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│                    Calendar Layout                          │
├─────────────────────────────────────────────────────────────┤
│  Left Panel (2/5 width)    │  Right Panel (3/5 width)    │
│  ┌─────────────────────┐   │  ┌─────────────────────────┐ │
│  │   Month Calendar    │   │  │   Posts for Selected    │ │
│  │                     │   │  │   Date                  │ │
│  │ • Month Navigation  │   │  │                         │ │
│  │ • Calendar Grid     │   │  │ • Date Header           │ │
│  │ • Date Selection    │   │  │ • Post List             │ │
│  │ • Post Indicators   │   │  │ • Post Cards            │ │
│  └─────────────────────┘   │  └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

**User Interactions**:
1. **Month Navigation**: Previous/Next month buttons
2. **Date Selection**: Tap on calendar dates
3. **Post Viewing**: See posts for selected date
4. **Post Navigation**: Tap posts to view details

**Calendar Features**:
- Visual calendar grid (6 weeks × 7 days)
- Post indicators on dates with scheduled content
- Color-coded borders (green for posts, gray for empty)
- Selected date highlighting

### **4. Create Post Screen Flow**

```
Create Post Screen
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│                    Post Creation Form                       │
├─────────────────────────────────────────────────────────────┤
│ • Back Navigation (to previous screen)                     │
│ • Form Sections:                                           │
│   ├── Basic Information (Title, Posted By, Campaign)      │
│   ├── Content (Post text, Media URLs)                     │
│   ├── Platforms (Social media selection)                  │
│   ├── Tags (Categorization)                               │
│   ├── Additional Links (External resources)                │
│ • Action Buttons (Cancel, Create Post)                     │
└─────────────────────────────────────────────────────────────┘
```

**Form Flow**:
1. **Basic Info**: Title, author, campaign, date
2. **Content**: Main post text and media
3. **Platforms**: Select social media networks
4. **Organization**: Tags and links
5. **Review & Submit**: Validate and create post

**Navigation**:
- **Back Button**: Return to previous screen
- **Cancel Button**: Return to home without saving
- **Create Button**: Save post and return to home

### **5. Post Detail Screen Flow**

```
Post Detail Screen
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│                    Post Detail Layout                       │
├─────────────────────────────────────────────────────────────┤
│ • Header: Back button, title, actions (Edit, Toggle)       │
│ • Content: Title, text, campaign badge, status            │
│ • Media: Images, videos (if available)                     │
│ • Details: Date, author, URL, posted time                  │
│ • Tags & Platforms: Categorization and social networks     │
│ • Links: Additional resources and references               │
└─────────────────────────────────────────────────────────────┘
```

**User Actions**:
- **View Content**: Read post details
- **Copy Content**: Copy text to clipboard
- **Edit Post**: Navigate to edit mode
- **Toggle Status**: Mark as posted/scheduled
- **Navigate Back**: Return to previous screen

## 🧭 Navigation Structure

### **Navigation Hierarchy**

```
Root (/)
├── Home (/)
│   ├── Post Detail (/post/:id)
│   │   └── Edit Post (/create?edit=true)
│   └── Search Results (/search?q=query)
├── Calendar (/calendar)
│   └── Post Detail (/post/:id)
├── Create Post (/create)
│   └── Edit Mode (/create?edit=true)
├── Analytics (/analytics) [Future]
└── Settings (/settings) [Future]
```

### **Navigation Patterns**

#### **1. Forward Navigation**
```dart
// Navigate to new screen
context.go('/calendar');

// Navigate with parameters
context.go('/post/123');

// Navigate with data
context.go('/create', extra: {'editPost': existingPost});
```

#### **2. Backward Navigation**
```dart
// Go back to previous screen
context.pop();

// Navigate to specific screen
context.go('/');

// Navigate to home and clear stack
context.go('/', extra: {'clearStack': true});
```

#### **3. Deep Navigation**
```dart
// Navigate directly to post from anywhere
context.go('/post/123');

// Navigate to calendar with specific date
context.go('/calendar?date=2024-12-25');
```

## 🔄 State Flow Between Screens

### **Data Sharing Patterns**

#### **1. Provider-Based State**
```dart
// All screens share the same PostProvider
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        // Access shared state
        final posts = postProvider.posts;
        // ... rest of the screen
      },
    );
  }
}
```

#### **2. Navigation with Data**
```dart
// Pass data through navigation
context.go('/create', extra: {'editPost': post});

// Access data in destination
class CreateEditPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editPost = GoRouterState.of(context).extra as Post?;
    // Use editPost data
  }
}
```

#### **3. URL Parameters**
```dart
// Pass data through URL
context.go('/post/123');

// Access in destination
class PostDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postId = GoRouterState.of(context).pathParameters['id']!;
    // Use postId
  }
}
```

## 📱 Responsive Navigation

### **Desktop/Tablet Layout**
```
┌─────────────────────────────────────────────────────────────┐
│                    Desktop Layout                           │
├─────────────────────────────────────────────────────────────┤
│ Navigation Rail │  Header  │  Main Content                │
│ (Left Sidebar)  │  (Top)   │  (Center/Right)              │
│                 │          │                               │
│ • Home         │  Logo     │  • Post Grid                  │
│ • Calendar     │  Title    │  • Calendar View              │
│ • Create       │  Social   │  • Forms                      │
│ • Analytics    │  Links    │  • Details                    │
│ • Settings     │          │                               │
└─────────────────────────────────────────────────────────────┘
```

### **Mobile Layout (Future)**
```
┌─────────────────────────────────────────────────────────────┐
│                    Mobile Layout                            │
├─────────────────────────────────────────────────────────────┤
│ Header (Top)                                               │
│ • Logo, Title, Menu Button                                │
├─────────────────────────────────────────────────────────────┤
│ Main Content                                               │
│ • Full-width content                                       │
│ • Bottom navigation bar                                    │
│ • Swipe gestures                                           │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 User Experience Flow

### **Primary User Journeys**

#### **1. Content Creation Journey**
```
1. User opens app → Home Screen
2. User clicks "Create Post" → Create Post Screen
3. User fills out form → Form validation
4. User submits form → Post created
5. User returns to Home → Sees new post in list
6. User clicks on post → Post Detail Screen
7. User edits post → Edit mode
8. User saves changes → Returns to detail view
```

#### **2. Content Discovery Journey**
```
1. User opens app → Home Screen
2. User searches for content → Search results
3. User browses posts → Post list/grid
4. User selects post → Post Detail Screen
5. User views content → Reads post details
6. User navigates to calendar → Calendar Screen
7. User selects date → Views posts for date
8. User returns to home → Home Screen
```

#### **3. Content Management Journey**
```
1. User opens app → Home Screen
2. User navigates to calendar → Calendar Screen
3. User selects date → Views scheduled posts
4. User clicks on post → Post Detail Screen
5. User toggles status → Mark as posted
6. User edits post → Make changes
7. User saves changes → Updates reflected
8. User returns to calendar → Sees updated status
```

## 🔍 Navigation State Management

### **Current Route Tracking**
```dart
class CustomNavigationRail extends StatefulWidget {
  @override
  _CustomNavigationRailState createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final currentRoute = GoRouterState.of(context).uri.path;
    switch (currentRoute) {
      case '/':
        _selectedIndex = 0;
        break;
      case '/calendar':
        _selectedIndex = 1;
        break;
      case '/create':
        _selectedIndex = 2;
        break;
      // ... other routes
    }
  }
}
```

### **Route Change Listeners**
```dart
// Listen to route changes
GoRouter.of(context).addListener(() {
  final currentRoute = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
  _updateNavigationState(currentRoute);
});
```

## 🧪 Testing Navigation Flow

### **Navigation Testing Strategy**
```dart
void main() {
  group('Navigation Flow Tests', () {
    testWidgets('should navigate from home to post detail', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          home: const HomeScreen(),
        ),
      );

      // Verify we're on home screen
      expect(find.byType(HomeScreen), findsOneWidget);

      // Tap on a post card
      await tester.tap(find.byType(PostCard).first);
      await tester.pumpAndSettle();

      // Verify we're on post detail screen
      expect(find.byType(PostDetailScreen), findsOneWidget);
    });

    testWidgets('should navigate through complete flow', (tester) async {
      // Test complete user journey
      await tester.pumpWidget(const SocialShareApp());
      await tester.pumpAndSettle();

      // Navigate to calendar
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      expect(find.byType(CalendarScreen), findsOneWidget);

      // Navigate to create post
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.byType(CreateEditPostScreen), findsOneWidget);

      // Navigate back to home
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
```

## 📚 Best Practices

### **1. Consistent Navigation**
- Use consistent navigation patterns throughout the app
- Provide clear visual feedback for navigation actions
- Maintain consistent back button behavior

### **2. State Preservation**
- Preserve user input when navigating between screens
- Maintain scroll positions in lists
- Cache frequently accessed data

### **3. Error Handling**
- Handle navigation errors gracefully
- Provide fallback routes for invalid navigation
- Show loading states during navigation

### **4. Performance**
- Lazy load screens when possible
- Minimize unnecessary rebuilds during navigation
- Use appropriate transition animations

## 🔮 Future Navigation Enhancements

### **Planned Features**
- **Deep Linking**: Direct navigation to specific content
- **URL Sharing**: Shareable links to posts and screens
- **Navigation History**: Breadcrumb navigation
- **Gesture Navigation**: Swipe gestures for navigation
- **Voice Navigation**: Voice commands for navigation

### **Advanced Navigation Patterns**
- **Tabbed Navigation**: Multiple content areas in one screen
- **Modal Navigation**: Overlay screens for quick actions
- **Stacked Navigation**: Multiple screens in navigation stack
- **Branching Navigation**: Conditional navigation based on user state

---

*Understanding the app flow and navigation structure is crucial for maintaining and extending the SocialShare application. This flow ensures a consistent user experience and provides developers with a clear understanding of how different parts of the app connect and interact.*
