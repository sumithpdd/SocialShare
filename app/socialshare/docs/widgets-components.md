# Widgets & UI Components

## 🎯 Overview

This document provides a comprehensive guide to all the widgets and UI components used in the SocialShare application. Understanding these components helps developers maintain consistency, reuse code, and extend the application effectively.

## 🏗️ Widget Architecture

### **Widget Hierarchy**

```
App
├── MaterialApp.router
│   ├── Theme (AppTheme.lightTheme)
│   └── Router (GoRouter)
│       ├── HomeScreen
│       │   ├── CustomNavigationRail
│       │   ├── OrganizationHeader
│       │   └── PostList (PostCard widgets)
│       ├── CalendarScreen
│       │   ├── CustomNavigationRail
│       │   ├── OrganizationHeader
│       │   └── CalendarView
│       ├── CreateEditPostScreen
│       │   ├── CustomNavigationRail
│       │   ├── OrganizationHeader
│       │   └── PostForm
│       └── PostDetailScreen
│           ├── CustomNavigationRail
│           ├── OrganizationHeader
│           └── PostDetailContent
│               ├── PostHeaderWidget
│               ├── PostContentWidget
│               ├── PostMediaWidget
│               ├── PostDetailsGridWidget
│               ├── PostTagsPlatformsWidget
│               └── PostLinksWidget
```

## 🧩 Core Widgets

### **1. Rich Content Support**

**Overview**: The application now supports rich content creation including emojis, hashtags, formatted text, and media integration.

**Features**:
- **Emoji Support**: Full emoji support in titles and content (🚀🧠👉🙌🎟️)
- **Hashtag Management**: Visual tag chips with add/remove functionality
- **Formatted Text**: Multi-line content with bullet points and line breaks
- **Media Integration**: External image URLs and video links
- **Link Management**: Multiple additional links for call-to-action content

**Example Rich Content Post**:
```
🚀 Are you working on the cutting edge of AI?
We're looking for speakers ready to share their insights, demos, or lessons learned in:

🧠 GenAI • LLMs • Multimodal apps • AI agents • MLOps • Ethics • And more!

👉 Apply to speak: https://lnkd.in/egqefzA2

🙌 Prefer to join the audience and soak it all in?
🎟️ Grab your ticket: https://lnkd.in/efcRfi9T

Let's shape the future of AI together.
#GDGLondon #GoogleIOExtended #BuildWithAI
```

### **2. CustomNavigationRail**

**Location**: `lib/widgets/navigation_rail.dart`

**Purpose**: Left-side navigation sidebar for desktop/tablet layouts

**Features**:
- Navigation destinations (Home, Calendar, Create, Analytics, Settings)
- Selected state indication
- Icon and label for each destination
- Responsive design

**Implementation**:
```dart
class CustomNavigationRail extends StatefulWidget {
  @override
  _CustomNavigationRailState createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  int _selectedIndex = 0;

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
        // ... more destinations
      ],
    );
  }

  void _navigateToRoute(int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/calendar');
        break;
      // ... other routes
    }
  }
}
```

**Usage**:
- Present in all main screens
- Provides consistent navigation across the app
- Adapts to different screen sizes

### **2. OrganizationHeader**

**Location**: `lib/widgets/organization_header.dart`

**Purpose**: Top banner displaying organization information and social links

**Features**:
- Organization logo and name
- Description and location
- Social media links (LinkedIn, Twitter, Website)
- Responsive design with proper spacing

**Implementation**:
```dart
class OrganizationHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final organization = DummyDataService.gdgLondon;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                organization.logoUrl ?? 'https://via.placeholder.com/60x60/4285F4/FFFFFF?text=GDG',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.white,
                    child: const Icon(
                      Icons.groups,
                      size: 30,
                      color: AppTheme.primaryBlue,
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Organization Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  organization.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  organization.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  organization.location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          
          // Social Links
          Row(
            children: [
              _buildSocialButton(
                icon: Icons.link,
                label: 'LinkedIn',
                onTap: () => _launchUrl(organization.linkedinUrl),
                color: const Color(0xFF0077B5),
              ),
              // ... more social buttons
            ],
          ),
        ],
      ),
    );
  }
}
```

**Usage**:
- Present at the top of all main screens
- Provides brand consistency
- Offers quick access to social media

## 📱 Screen Widgets

### **3. HomeScreen**

**Location**: `lib/screens/home_screen.dart`

**Purpose**: Main landing page displaying all posts in a grid/list format

**Features**:
- Post grid/list view with toggle
- Search functionality
- Floating action button for creating posts
- Responsive layout

**Key Components**:
- `PostCard` widgets for each post
- Search bar with filtering
- View toggle (Grid/List)
- Navigation integration

### **4. CalendarScreen**

**Location**: `lib/screens/calendar_screen.dart`

**Purpose**: Calendar view for scheduling and viewing posts by date

**Features**:
- Month navigation (previous/next)
- Calendar grid with post indicators
- Date selection
- Posts list for selected date
- Grid/Calendar view toggle

**Key Components**:
- Month navigation controls
- Calendar grid builder
- Date selection logic
- Posts display for selected dates

### **5. CreateEditPostScreen**

**Location**: `lib/screens/create_edit_post_screen.dart`

**Purpose**: Form for creating and editing social media posts with rich content support

**Features**:
- Comprehensive post creation form with rich content support
- Form validation for required fields
- Media URL inputs (images and videos)
- Platform selection with visual chips
- Tag management with add/remove functionality
- Campaign organization and naming
- **Rich Content Support**: Emojis, formatted text, line breaks
- **Hashtag Management**: Visual tag chips with copy functionality
- **Link Management**: Multiple additional links for CTAs
- **Copy Functionality**: Copy buttons for all form fields

**Key Components**:
- Form sections (Basic Info, Content, Media, Platforms, Tags, Links)
- Input validation with error messages
- Copy-to-clipboard functionality for all fields
- Form submission handling with success feedback
- Rich text support in content area
- Visual platform selection with FilterChips

### **6. PostDetailScreen**

**Location**: `lib/screens/post_detail_screen.dart`

**Purpose**: Detailed view of individual posts with all information

**Features**:
- Complete post information display
- Edit and toggle actions
- Media display
- Copy functionality
- Navigation to edit mode

**Key Components**:
- `PostHeaderWidget`
- `PostContentWidget`
- `PostMediaWidget`
- `PostDetailsGridWidget`
- `PostTagsPlatformsWidget`
- `PostLinksWidget`

## 🎨 Specialized Widgets

### **7. PostCard**

**Location**: `lib/widgets/post_card.dart`

**Purpose**: Compact display of post information for lists and grids

**Features**:
- Post title and content preview with rich text support
- Status indicator (Posted/Scheduled)
- Campaign badge
- **Media Preview**: Image thumbnails with error handling
- **Rich Content Display**: Emojis, formatted text, and line breaks
- Tags display with visual chips
- Action menu (Edit, Delete, Copy)
- Platform icons with brand colors
- **Copy Functionality**: Copy post content to clipboard

**Implementation**:
```dart
class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      post.title,
                      style: AppTheme.headlineMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(),
                  // Action menu
                ],
              ),
              
              // Campaign badge
              if (post.campaign != null) _buildCampaignBadge(),
              
              // Content preview
              Text(
                post.content,
                style: AppTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Media preview
              if (post.imageUrl != null || post.videoUrl != null)
                _buildMediaPreview(),
              
              // Tags
              if (post.tags.isNotEmpty) _buildTags(),
              
              // Footer with date, author, and platforms
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Usage**:
- Home screen post grid/list
- Calendar screen post lists
- Search results
- Any place where post summaries are needed

### **8. PostHeaderWidget**

**Location**: `lib/widgets/post_header_widget.dart`

**Purpose**: Header section of post detail screen with actions

**Features**:
- Back navigation
- Post title
- Edit button
- Toggle status button
- Responsive layout

### **9. PostContentWidget**

**Location**: `lib/widgets/post_content_widget.dart`

**Purpose**: Display post content with copy functionality

**Features**:
- Post title with copy button
- Content text with copy button
- Status chip (Posted/Scheduled)
- Campaign badge
- Proper spacing and typography

### **10. PostMediaWidget**

**Location**: `lib/widgets/post_media_widget.dart`

**Purpose**: Display images and videos associated with posts

**Features**:
- Image display with error handling
- Video placeholder with content indicator
- Responsive sizing
- Proper aspect ratios

### **11. PostDetailsGridWidget**

**Location**: `lib/widgets/post_details_grid_widget.dart`

**Purpose**: Display post metadata in an organized grid

**Features**:
- Scheduled date
- Posted by information
- Posted at timestamp
- Post URL (if available)
- Grid layout for organization

### **12. PostTagsPlatformsWidget**

**Location**: `lib/widgets/post_tags_platforms_widget.dart`

**Purpose**: Display post tags and social media platforms

**Features**:
- Tag chips with consistent styling
- Platform indicators with colors and icons
- Responsive wrapping
- Visual distinction between tags and platforms

### **13. PostLinksWidget**

**Location**: `lib/widgets/post_links_widget.dart`

**Purpose**: Display additional links related to posts

**Features**:
- Link list with icons
- Clickable links (placeholder for URL launching)
- Consistent styling
- Empty state handling

### **14. LoadingErrorWidget**

**Location**: `lib/widgets/loading_error_widget.dart`

**Purpose**: Reusable widget for loading and error states

**Features**:
- Loading indicator
- Error message display
- Retry button functionality
- Consistent styling across the app

## 🎨 UI Components

### **15. AppTheme**

**Location**: `lib/utils/theme.dart`

**Purpose**: Centralized theme system for consistent styling

**Features**:
- Color palette (primary, secondary, success, warning, error)
- Text styles (headlines, body, caption, label)
- Component themes (cards, buttons, inputs, chips)
- Material Design 3 compliance

**Implementation**:
```dart
class AppTheme {
  // Primary colors
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color primaryGreen = Color(0xFF34A853);
  static const Color primaryYellow = Color(0xFFFBBC04);
  static const Color primaryRed = Color(0xFFEA4335);
  
  // Light theme colors
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color textPrimary = Color(0xFF202124);
  static const Color textSecondary = Color(0xFF5F6368);
  
  // Text styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.5,
  );
  
  // Theme data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        surface: surfaceLight,
      ),
      scaffoldBackgroundColor: backgroundLight,
      // ... more theme configuration
    );
  }
}
```

**Usage**:
- Applied globally to the app
- Referenced in all widgets for consistent styling
- Easy to modify for theme changes

## 🔧 Utility Widgets

### **16. Form Components**

**Location**: Various form screens

**Purpose**: Reusable form input components

**Features**:
- Text input fields
- Date pickers
- Platform selection chips
- Tag input and management
- Form validation

### **17. Action Buttons**

**Location**: Throughout the app

**Purpose**: Consistent button styling and behavior

**Features**:
- Primary action buttons
- Secondary action buttons
- Icon buttons
- Consistent sizing and spacing

## 📱 Responsive Design

### **Layout Adaptations**

**Desktop/Tablet**:
- Navigation rail on the left
- Full-width content area
- Multi-column layouts
- Hover effects and interactions

**Mobile (Future)**:
- Bottom navigation bar
- Full-width content
- Stacked layouts
- Touch-optimized interactions

### **Breakpoint System**

```dart
// Responsive breakpoints
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

// Usage in widgets
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

## 🧪 Widget Testing

### **Testing Strategy**

**Unit Tests**:
- Test individual widget logic
- Mock dependencies
- Test state changes

**Widget Tests**:
- Test widget rendering
- Test user interactions
- Test navigation

**Integration Tests**:
- Test complete user flows
- Test widget interactions
- Test real data flow

### **Test Examples**

```dart
void main() {
  group('PostCard Widget', () {
    testWidgets('should display post information correctly', (tester) async {
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

      await tester.pumpWidget(
        MaterialApp(
          home: PostCard(
            post: post,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Test Post'), findsOneWidget);
      expect(find.text('Test content'), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
    });
  });
}
```

## 📚 Best Practices

### **1. Widget Composition**
- Break large widgets into smaller, focused components
- Use composition over inheritance
- Keep widgets single-purpose

### **2. State Management**
- Use Provider for shared state
- Keep local state minimal
- Separate UI logic from business logic

### **3. Performance**
- Use `const` constructors when possible
- Minimize widget rebuilds
- Use appropriate widgets for lists (ListView.builder, GridView.builder)

### **4. Accessibility**
- Provide meaningful labels
- Use semantic widgets
- Support screen readers
- Maintain proper contrast ratios

### **5. Consistency**
- Use AppTheme for all styling
- Maintain consistent spacing
- Use consistent interaction patterns
- Follow Material Design guidelines

## 🔮 Future Enhancements

### **Planned Widgets**
- **Analytics Dashboard**: Charts and metrics display
- **Settings Panel**: User preferences and configuration
- **Search Results**: Advanced search with filters
- **User Profile**: User information and preferences
- **Notification Center**: System and user notifications

### **Advanced Features**
- **Drag and Drop**: Reorder posts and content
- **Rich Text Editor**: Enhanced content creation
- **Media Gallery**: Image and video management
- **Collaboration Tools**: Team editing and approval
- **Mobile Optimization**: Touch-friendly mobile interface

---

*The widgets and UI components in SocialShare are designed for reusability, maintainability, and consistency. Understanding these components helps developers extend the application while maintaining the established design patterns and user experience.*
