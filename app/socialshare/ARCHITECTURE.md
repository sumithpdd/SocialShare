# SocialShare App Architecture

## Overview
This document describes the refactored architecture of the SocialShare Flutter application, which implements proper separation of concerns, repository pattern, and provider-based state management.

## Architecture Layers

### 1. Models Layer (`lib/models/`)
- **Post Model**: Contains the data structure for social media posts
- **SocialPlatform Enum**: Defines supported social media platforms
- Includes JSON serialization/deserialization methods
- Implements `copyWith` for immutable updates

### 2. Repository Layer (`lib/repository/`)
- **PostRepository Interface**: Defines the contract for data operations
- **PostRepositoryImpl**: Concrete implementation with in-memory storage
- Handles CRUD operations for posts
- Simulates network delays for realistic testing
- Provides data persistence abstraction

### 3. Service Layer (`lib/services/`)
- **PostService Interface**: Business logic abstraction
- **PostServiceImpl**: Concrete service implementation
- Acts as an intermediary between repository and provider
- Enables dependency injection and testing
- Handles business rules and data transformation

### 4. Provider Layer (`lib/providers/`)
- **PostProvider**: State management using Provider pattern
- Manages loading states, error handling, and data caching
- Communicates with service layer for data operations
- Notifies UI of state changes
- Handles async operations properly

### 5. Widgets Layer (`lib/widgets/`)
- **PostHeaderWidget**: Handles post header with actions
- **PostContentWidget**: Manages post title, content, and campaign
- **PostMediaWidget**: Displays images and videos
- **PostDetailsGridWidget**: Shows post metadata in grid format
- **PostTagsPlatformsWidget**: Renders tags and platform badges
- **PostLinksWidget**: Displays additional links
- **LoadingErrorWidget**: Handles loading states and errors

### 6. Screens Layer (`lib/screens/`)
- **PostDetailScreen**: Main screen that orchestrates widgets
- Manages local state for loading and errors
- Coordinates between provider and UI components
- Handles navigation and user interactions

## Key Benefits

### Separation of Concerns
- Each widget has a single responsibility
- Business logic is separated from UI logic
- Data access is abstracted through repository pattern

### Testability
- Interfaces allow for easy mocking
- Dependencies can be injected
- Business logic is isolated from UI

### Maintainability
- Code is organized into logical layers
- Changes in one layer don't affect others
- Clear separation of responsibilities

### Scalability
- Easy to add new data sources
- Simple to implement new features
- Architecture supports growth

## Data Flow

```
UI (Widgets) → Provider → Service → Repository → Data Source
     ↑           ↓         ↓         ↓
     ←──────────←─────────←─────────←
```

1. **UI Layer**: User interactions trigger actions
2. **Provider Layer**: Manages state and coordinates operations
3. **Service Layer**: Handles business logic and validation
4. **Repository Layer**: Manages data access and persistence
5. **Data Source**: In-memory storage (can be replaced with API/database)

## Usage Examples

### Creating a Post
```dart
final postProvider = context.read<PostProvider>();
await postProvider.addPost(newPost);
```

### Updating Post Status
```dart
await postProvider.togglePostStatus(postId);
```

### Loading Posts
```dart
final posts = await postProvider.getPostsByDate(selectedDate);
```

## Future Enhancements

1. **API Integration**: Replace repository with real API calls
2. **Database**: Add local database for offline support
3. **Authentication**: Implement user authentication
4. **Real-time Updates**: Add WebSocket support
5. **Analytics**: Track user interactions and post performance

## Testing Strategy

- **Unit Tests**: Test individual components in isolation
- **Widget Tests**: Test UI components
- **Integration Tests**: Test complete user flows
- **Mocking**: Use interfaces for dependency injection

## Dependencies

- **provider**: State management
- **go_router**: Navigation
- **flutter**: Core framework

## Getting Started

1. Ensure all dependencies are installed
2. Run the app with `flutter run`
3. Navigate to post details to see the new architecture in action
4. Check the console for repository operation logs

## Contributing

When adding new features:
1. Follow the existing architecture patterns
2. Create appropriate interfaces and implementations
3. Update this documentation
4. Add tests for new functionality
