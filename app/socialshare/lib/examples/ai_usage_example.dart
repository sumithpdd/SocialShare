import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../services/ai_service.dart';

/// Example usage of the AI service for generating social media posts
/// This file demonstrates the basic functionality without the UI
class AIUsageExample {
  static Future<void> main() async {
    // Initialize Firebase (this should be done in main.dart)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Create an instance of the AI service
    final aiService = AIService();

    // Example 1: Generate 3 different post titles
    try {
      final titles = await aiService.generatePostTitles(
        'Flutter development tips for beginners',
        style: 'Professional',
      );

      for (int i = 0; i < titles.length; i++) {
        print('Title ${i + 1}: ${titles[i]}');
      }
    } catch (e) {
      print('Error generating titles: $e');
    }

    // Example 2: Generate 3 different content variants
    try {
      final contents = await aiService.generatePostContent(
        'Flutter development tips for beginners',
        style: 'Professional',
      );

      for (int i = 0; i < contents.length; i++) {
        print('Content ${i + 1}: ${contents[i]}');
      }
    } catch (e) {
      print('Error generating content: $e');
    }

    // Example 3: Generate both titles and content in one call
    try {
      final titles = await aiService.generatePostTitles(
        'Tech meetups and networking events',
        style: 'Casual',
      );
      final contents = await aiService.generatePostContent(
        'Tech meetups and networking events',
        style: 'Casual',
      );

      for (int i = 0; i < titles.length; i++) {
        print('Title ${i + 1}: ${titles[i]}');
      }

      for (int i = 0; i < contents.length; i++) {
        print('Content ${i + 1}: ${contents[i]}');
      }
    } catch (e) {
      print('Error generating suggestions: $e');
    }

    // Example 4: Generate a creative post
    try {
      final creativePost = await aiService.generateCreativePost(
        'The future of mobile app development',
      );

      if (creativePost != null) {
        print('Creative Post Title: ${creativePost.title}');
        print('Creative Post Content: ${creativePost.content}');
      }
    } catch (e) {
      print('Error generating creative post: $e');
    }
  }
}

/// Direct usage example without async/await
void directUsageExample() {
  // Initialize Firebase first
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {
    // Create AI service
    final aiService = AIService();

    // Generate titles
    aiService.generatePostTitles('AI in mobile apps').then((titles) {
      for (int i = 0; i < titles.length; i++) {
        print('Title ${i + 1}: ${titles[i]}');
      }
    }).catchError((error) {
      print('Error: $error');
    });

    // Generate content
    aiService.generatePostContent('AI in mobile apps').then((contents) {
      for (int i = 0; i < contents.length; i++) {
        print('Content ${i + 1}: ${contents[i]}');
      }
    }).catchError((error) {
      print('Error: $error');
    });
  });
}

/// Example of using the AI service in a Flutter widget
class ExampleWidget {
  final AIService _aiService = AIService();

  Future<void> generatePost() async {
    try {
      // Show loading state
      // setState(() => _isLoading = true);

      final titles = await _aiService.generatePostTitles(
        'Flutter widgets and UI components',
        style: 'Educational',
      );

      final contents = await _aiService.generatePostContent(
        'Flutter widgets and UI components',
        style: 'Educational',
      );

      // Update UI with results
      // setState(() {
      //   _titles = titles;
      //   _contents = contents;
      //   _isLoading = false;
      // });
    } catch (e) {
      // Handle error
      // setState(() => _isLoading = false);
    }
  }
}
