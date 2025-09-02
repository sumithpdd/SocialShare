# AI Service Usage Guide

## Overview

The AI Service (`AIService`) provides AI-powered content generation for social media posts using Firebase AI Logic (Gemini API). It generates multiple variants of titles, content, tags, and mentions to help create engaging social media content.

## Features

- **Multi-variant Generation**: Creates 3 different variants for each content type
- **Style Customization**: Supports different writing styles (Professional, Casual, Technical, etc.)
- **Web Compatibility**: Works on web, mobile, and desktop platforms
- **Image Upload Support**: Firebase Storage integration for image handling
- **Error Handling**: Graceful fallbacks and user-friendly error messages

## Available Methods

### 1. Generate Post Titles
```dart
Future<List<String>> generatePostTitles(String topic, {String? style})
```

**Parameters:**
- `topic`: The main subject or theme for the post
- `style`: Optional writing style (e.g., "Professional", "Casual", "Technical")

**Returns:** List of 3 different title variants

**Example:**
```dart
final aiService = AIService();
final titles = await aiService.generatePostTitles(
  'Flutter Development Tips',
  style: 'Professional'
);
// Returns: ["5 Essential Flutter Tips Every Developer Should Know", ...]
```

### 2. Generate Post Content
```dart
Future<List<String>> generatePostContent(String topic, {String? style})
```

**Parameters:**
- `topic`: The main subject or theme for the post
- `style`: Optional writing style

**Returns:** List of 3 different content variants

**Example:**
```dart
final contents = await aiService.generatePostContent(
  'Flutter Development Tips',
  style: 'Educational'
);
// Returns: ["Discover the power of Flutter...", ...]
```

### 3. Generate Post Tags
```dart
Future<List<List<String>>> generatePostTags(String topic)
```

**Parameters:**
- `topic`: The main subject or theme for the post

**Returns:** List of 3 different tag sets, each containing multiple hashtags

**Example:**
```dart
final tags = await aiService.generatePostTags('Flutter Development');
// Returns: [["flutter", "dart", "mobile"], ["appdev", "coding"], ...]
```

### 4. Generate Post Mentions
```dart
Future<List<List<String>>> generatePostMentions(String topic)
```

**Parameters:**
- `topic`: The main subject or theme for the post

**Returns:** List of 3 different mention sets, each containing relevant accounts/communities

**Example:**
```dart
final mentions = await aiService.generatePostMentions('Flutter Development');
// Returns: [["flutter", "google"], ["dartlang", "gdg"], ...]
```

### 5. Generate Complete Post Suggestions
```dart
Future<List<Post>> generateCompletePostSuggestions({
  required String topic,
  required DateTime date,
  required String postedBy,
  String? imageUrl,
  String? additionalContext,
})
```

**Parameters:**
- `topic`: The main subject or theme for the post
- `date`: When the post will be published
- `postedBy`: Who is posting (e.g., "GDG London Team")
- `imageUrl`: Optional image URL for the post
- `additionalContext`: Optional additional context or details

**Returns:** List of 3 complete Post objects with different variants

### 6. Generate Creative Post
```dart
Future<Post?> generateCreativePost(String topic, {String? style})
```

**Parameters:**
- `topic`: The main subject or theme for the post
- `style`: Optional writing style

**Returns:** A single creative Post object or null if generation fails

### 7. Upload Image
```dart
Future<String?> uploadImage(Uint8List imageBytes, String filename)
```

**Parameters:**
- `imageBytes`: Raw image data
- `filename`: Name for the uploaded file

**Returns:** Download URL or placeholder URL (on web)

**Platform Behavior:**
- **Web**: Returns placeholder URL (simulated upload)
- **Mobile/Desktop**: Uploads to Firebase Storage and returns download URL

## Usage Examples

### Basic Title Generation
```dart
final aiService = AIService();
try {
  final titles = await aiService.generatePostTitles(
    'AI in Mobile Development',
    style: 'Professional'
  );
  
  for (int i = 0; i < titles.length; i++) {
    print('Title ${i + 1}: ${titles[i]}');
  }
} catch (e) {
  print('Error generating titles: $e');
}
```

### Complete Post Generation
```dart
final posts = await aiService.generateCompletePostSuggestions(
  topic: 'Tech Meetup Announcement',
  date: DateTime.now(),
  postedBy: 'GDG London Team',
  additionalContext: 'Focus on AI and Machine Learning'
);

for (final post in posts) {
  print('Title: ${post.title}');
  print('Content: ${post.content}');
  print('Tags: ${post.tags.join(', ')}');
  print('---');
}
```

### Image Upload
```dart
final imageBytes = await imageFile.readAsBytes();
final filename = 'post_${DateTime.now().millisecondsSinceEpoch}.jpg';

final imageUrl = await aiService.uploadImage(imageBytes, filename);
if (imageUrl != null) {
  print('Image uploaded: $imageUrl');
}
```

## Error Handling

The service includes comprehensive error handling:

- **API Errors**: Catches and reports Firebase AI API errors
- **Network Issues**: Handles connectivity problems gracefully
- **Empty Results**: Provides fallback content when generation fails
- **Platform Differences**: Adapts behavior for web vs. mobile/desktop

## Best Practices

1. **Always use try-catch**: Wrap AI service calls in error handling
2. **Check for empty results**: Verify generated content before using
3. **Provide context**: Use the `style` parameter for better results
4. **Handle loading states**: Show progress indicators during generation
5. **Validate input**: Ensure topics are descriptive and relevant

## Configuration

### Firebase Setup
Ensure your Firebase project has:
- Firebase AI Logic API enabled
- Proper authentication configured
- Firebase Storage rules set up (for image uploads)

### API Limits
- Rate limits apply based on your Firebase plan
- Consider implementing retry logic for production use
- Monitor API usage in Firebase Console

## Troubleshooting

### Common Issues

1. **"Firebase AI Logic API not enabled"**
   - Enable the API in Google Cloud Console
   - Wait a few minutes for activation

2. **Empty generation results**
   - Check topic description clarity
   - Verify API quota and limits
   - Review error logs for details

3. **Image upload failures**
   - Check Firebase Storage rules
   - Verify image format and size
   - Ensure proper authentication

### Debug Mode
Enable debug logging by checking console output for detailed error information.

## Integration with UI

The AI Service is designed to work seamlessly with the `AIPostCreator` widget, which provides:
- Multi-step workflow (Input → Generation → Selection → Review)
- Real-time content preview
- Variant selection interface
- Error handling and user feedback
- Image upload integration

For more details on the UI implementation, see the `AIPostCreator` widget documentation.
