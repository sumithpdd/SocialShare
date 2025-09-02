# AI Post Creator Widget

## Overview

The `AIPostCreator` widget is a comprehensive, multi-screen interface for creating AI-powered social media posts. It provides an intuitive workflow for generating, selecting, and saving posts with AI assistance.

## Features

- **Multi-Screen Workflow**: Step-by-step post creation process
- **AI Content Generation**: 3 variants for titles, content, tags, and mentions
- **Image Upload**: Firebase Storage integration with web compatibility
- **Variant Selection**: Interactive selection interface with live preview
- **Final Review**: Complete post preview before creation
- **Error Handling**: Graceful error handling and user feedback
- **Responsive Design**: Works on web, mobile, and desktop

## Workflow

### Screen 1: Input & Image Upload
- **Topic Input**: Required field for post subject
- **Style Input**: Optional writing style (Professional, Casual, Technical, etc.)
- **Additional Context**: Optional extra details for better AI generation
- **Image Upload**: Optional image selection and Firebase Storage upload
- **Generate Button**: Triggers AI content generation

### Screen 2: AI Generation (Automatic)
- **Loading State**: Shows progress while AI generates content
- **Error Handling**: Displays errors if generation fails
- **Auto-advance**: Moves to variant selection when complete

### Screen 3: Variant Selection
- **Title Selection**: Choose from 3 generated title variants
- **Content Selection**: Choose from 3 generated content variants
- **Tags Selection**: Choose from 3 generated hashtag sets
- **Mentions Selection**: Choose from 3 generated mention sets
- **Live Preview**: See selected content in real-time
- **Navigation**: Back to input or forward to review

### Screen 4: Final Review
- **Complete Preview**: Full post with image, title, content, tags, and mentions
- **Final Edit**: Option to go back and modify selections
- **Create Post**: Save the final post to assets/posts folder

## Usage

### Basic Integration

```dart
import 'package:go_router/go_router.dart';
import '../widgets/ai_post_creator.dart';

// In your router
GoRoute(
  path: '/ai-create',
  builder: (context, state) => const AIPostCreator(),
),

// Navigation
context.go('/ai-create');
```

### Navigation Integration

The widget is accessible via:
- **Home Screen**: "AI Post Creator ✨" button in Quick Actions
- **Navigation Rail**: "AI Creator" option in the left sidebar
- **Direct Route**: `/ai-create` path

## API Integration

### AIService Methods Used

- `generatePostTitles()` - Creates 3 title variants
- `generatePostContent()` - Creates 3 content variants
- `generatePostTags()` - Creates 3 tag sets
- `generatePostMentions()` - Creates 3 mention sets
- `uploadImage()` - Handles image uploads

### State Management

The widget manages its own state for:
- Form inputs (topic, style, context)
- Selected image and upload status
- Generated content variants
- Selected variant indices
- Current workflow step
- Error states and loading indicators

## UI Components

### Input Fields
- **TextFormField**: For topic, style, and context
- **Validation**: Required field validation for topic
- **Icons**: Visual indicators for each field type

### Image Upload
- **Image Picker**: Gallery selection with quality settings
- **Upload Button**: Firebase Storage integration
- **Preview**: Selected image display with rounded corners
- **Status**: Success/error feedback for uploads

### Variant Selection
- **SegmentedButton**: Easy switching between variants
- **Live Preview**: Selected content display
- **Conditional Rendering**: Only shows sections with content

### Navigation
- **Step Navigation**: Forward/backward between screens
- **Reset Option**: "Start Over" button in app bar
- **Progress Indication**: Visual feedback for current step

## Error Handling

### Generation Errors
- **API Failures**: Firebase AI Logic API errors
- **Network Issues**: Connectivity problems
- **Empty Results**: No content generated
- **User Feedback**: Clear error messages with recovery options

### Upload Errors
- **File Issues**: Invalid image formats or sizes
- **Storage Errors**: Firebase Storage problems
- **Web Limitations**: Graceful fallback for web platform

### UI Errors
- **Empty Lists**: Prevents SegmentedButton assertion errors
- **State Issues**: Handles incomplete data gracefully
- **Navigation**: Prevents invalid state transitions

## Platform Compatibility

### Web
- **Image Upload**: Simulated with placeholder URLs
- **Firebase Storage**: Not available, uses fallback
- **UI**: Full functionality with responsive design

### Mobile
- **Image Picker**: Native gallery access
- **Firebase Storage**: Full upload functionality
- **Performance**: Optimized for touch interfaces

### Desktop
- **File Picker**: Native file selection
- **Firebase Storage**: Full upload functionality
- **Keyboard Navigation**: Enhanced keyboard support

## Customization

### Styling
- **Theme Integration**: Uses app's Material Design theme
- **Color Scheme**: Adapts to primary/secondary colors
- **Typography**: Consistent with app's text styles
- **Spacing**: Responsive padding and margins

### Content
- **AI Prompts**: Customizable via AIService
- **Style Options**: Extensible style categories
- **Validation Rules**: Configurable input requirements
- **Error Messages**: Localizable error text

## Best Practices

### User Experience
1. **Clear Workflow**: Step-by-step progression
2. **Visual Feedback**: Loading states and progress indicators
3. **Error Recovery**: Easy ways to fix issues
4. **Content Preview**: See results before committing

### Performance
1. **Lazy Loading**: Only generate content when needed
2. **Image Optimization**: Compress images before upload
3. **State Management**: Efficient state updates
4. **Memory Management**: Dispose of controllers properly

### Accessibility
1. **Screen Readers**: Proper labels and descriptions
2. **Keyboard Navigation**: Full keyboard support
3. **Color Contrast**: Accessible color combinations
4. **Focus Management**: Clear focus indicators

## Troubleshooting

### Common Issues

1. **"Segments.length > 0" Error**
   - Caused by empty variant lists
   - Fixed with safety checks in `_buildVariantSection`

2. **Image Upload Failures**
   - Check Firebase Storage rules
   - Verify image format and size
   - Ensure proper authentication

3. **AI Generation Errors**
   - Enable Firebase AI Logic API
   - Check API quotas and limits
   - Verify topic descriptions

4. **Navigation Issues**
   - Ensure proper route configuration
   - Check provider availability
   - Verify state management

### Debug Information

Enable debug logging by checking:
- Console output for API errors
- Network tab for upload issues
- State changes in widget lifecycle
- Provider availability in widget tree

## Future Enhancements

### Planned Features
- **Template System**: Pre-defined post templates
- **Batch Generation**: Multiple posts at once
- **Content Scheduling**: Plan posts for future dates
- **Analytics Integration**: Track post performance

### Technical Improvements
- **Offline Support**: Cache generated content
- **Real-time Collaboration**: Multi-user editing
- **Advanced AI Models**: Support for additional models
- **Performance Optimization**: Faster generation times

## Support

For issues related to:
- **Widget Functionality**: Check error logs and state management
- **AI Integration**: Refer to AIService documentation
- **Firebase Issues**: Check Firebase Console and logs
- **UI Problems**: Verify theme and provider setup

## Examples

### Complete Workflow
```dart
// 1. Navigate to AI Post Creator
context.go('/ai-create');

// 2. User fills out form and uploads image
// 3. AI generates 3 variants for each content type
// 4. User selects preferred variants
// 5. User reviews final post
// 6. Post is saved to assets/posts folder
```

### Custom Integration
```dart
class CustomAIPostCreator extends AIPostCreator {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom AI Creator'),
        backgroundColor: Colors.purple,
      ),
      body: super.build(context),
    );
  }
}
```

The AI Post Creator widget provides a professional, user-friendly interface for creating AI-powered social media content, making it easy for users to generate engaging posts with minimal effort.
