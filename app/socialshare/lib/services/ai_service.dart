// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/post.dart';

class AIService {
  static final GenerativeModel _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
  );

  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Generates 3 different post titles based on a topic
  Future<List<String>> generatePostTitles(String topic, {String? style}) async {
    try {
      final prompt = _buildTitlePrompt(topic, style);
      final response = await _model.generateContent([Content.text(prompt)]);

      if (response.text != null) {
        return _parseVariants(response.text!);
      }
      return [];
    } catch (e) {
      print('Error generating titles: $e');
      return [];
    }
  }

  /// Generates 3 different post content based on a topic
  Future<List<String>> generatePostContent(String topic,
      {String? style}) async {
    try {
      final prompt = _buildContentPrompt(topic, style);
      final response = await _model.generateContent([Content.text(prompt)]);

      if (response.text != null) {
        return _parseVariants(response.text!);
      }
      return [];
    } catch (e) {
      print('Error generating content: $e');
      return [];
    }
  }

  /// Generates 3 different sets of tags based on a topic
  Future<List<List<String>>> generatePostTags(String topic) async {
    try {
      final prompt = _buildTagsPrompt(topic);
      final response = await _model.generateContent([Content.text(prompt)]);

      if (response.text != null) {
        return _parseTagVariants(response.text!);
      }
      return [];
    } catch (e) {
      print('Error generating tags: $e');
      return [];
    }
  }

  /// Generates 3 different sets of mentions based on a topic
  Future<List<List<String>>> generatePostMentions(String topic) async {
    try {
      final prompt = _buildMentionsPrompt(topic);
      final response = await _model.generateContent([Content.text(prompt)]);

      if (response.text != null) {
        return _parseMentionVariants(response.text!);
      }
      return [];
    } catch (e) {
      print('Error generating mentions: $e');
      return [];
    }
  }

  /// Uploads an image to Firebase Storage and returns the download URL
  /// Supports real uploads on web, mobile, and desktop
  Future<String?> uploadImage(Uint8List imageBytes, String filename) async {
    try {
      // Create a reference to the post_images folder
      final ref = _storage.ref().child('post_images/$filename');

      // Upload the image data
      final uploadTask = ref.putData(
        imageBytes,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploaded_at': DateTime.now().toIso8601String(),
            'platform': kIsWeb ? 'web' : 'mobile_desktop',
          },
        ),
      );

      // Show upload progress (optional)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
      });

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      print('Image uploaded successfully to: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');

      // If upload fails on web, provide a helpful error message
      if (kIsWeb) {
        print('Web upload failed. Common causes:');
        print('- Firebase Storage rules not configured for web');
        print('- Authentication not set up for web');
        print('- CORS issues with Firebase Storage');
        print('- Network connectivity problems');
      }

      return null;
    }
  }

  /// Generates complete post suggestions with 3 variants
  Future<List<Post>> generateCompletePostSuggestions({
    required String topic,
    required DateTime date,
    required String postedBy,
    String? imageUrl,
    String? additionalContext,
  }) async {
    try {
      final titles = await generatePostTitles(topic);
      final contents = await generatePostContent(topic);
      final tags = await generatePostTags(topic);
      final mentions = await generatePostMentions(topic);

      // Create 3 post variants
      final posts = <Post>[];
      for (int i = 0; i < 3; i++) {
        final post = Post(
          id: DateTime.now().millisecondsSinceEpoch.toString() + '_$i',
          title: titles.isNotEmpty
              ? titles[i % titles.length]
              : 'Generated Post ${i + 1}',
          content: contents.isNotEmpty
              ? contents[i % contents.length]
              : 'Generated content for post ${i + 1}',
          date: date,
          isPosted: false,
          postedBy: postedBy,
          imageUrl: imageUrl,
          tags: tags.isNotEmpty ? tags[i % tags.length] : [],
          platforms: [SocialPlatform.linkedin, SocialPlatform.twitter],
          additionalLinks: [],
          campaign: null,
          mentions: mentions.isNotEmpty ? mentions[i % mentions.length] : [],
        );
        posts.add(post);
      }

      return posts;
    } catch (e) {
      print('Error generating complete post suggestions: $e');
      return [];
    }
  }

  /// Generates a single creative post
  Future<Post?> generateCreativePost(String topic, {String? style}) async {
    try {
      final titles = await generatePostTitles(topic, style: style);
      final contents = await generatePostContent(topic, style: style);
      final tags = await generatePostTags(topic);
      final mentions = await generatePostMentions(topic);

      if (titles.isNotEmpty && contents.isNotEmpty) {
        return Post(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: titles.first,
          content: contents.first,
          date: DateTime.now(),
          isPosted: false,
          postedBy: 'AI Generated',
          imageUrl: null,
          tags: tags.isNotEmpty ? tags.first : [],
          platforms: [SocialPlatform.linkedin, SocialPlatform.twitter],
          additionalLinks: [],
          campaign: null,
          mentions: mentions.isNotEmpty ? mentions.first : [],
        );
      }
      return null;
    } catch (e) {
      print('Error generating creative post: $e');
      return null;
    }
  }

  String _buildTitlePrompt(String topic, String? style) {
    final styleText = style != null ? ' in a $style style' : '';
    return '''You are a social media expert for a tech community. Generate 3 different engaging social media post titles for: "$topic"$styleText.

Requirements:
- Each title should be catchy, engaging, and professional
- Maximum 60 characters each
- Include relevant emojis where appropriate
- Make them suitable for professional tech community posts (GDG London, developers, tech enthusiasts)
- Each title should have a different approach (informative, question-based, announcement, etc.)
- Number each title (1., 2., 3.)

Format your response exactly like this:
1. First title here
2. Second title here  
3. Third title here''';
  }

  String _buildContentPrompt(String topic, String? style) {
    final styleText = style != null ? ' in a $style style' : '';
    return '''You are a social media expert for a tech community. Generate 3 different social media post contents for: "$topic"$styleText.

Requirements:
- Each content should be engaging, informative, and professional
- Maximum 280 characters each
- Include relevant emojis where appropriate
- Make them suitable for professional tech community posts (GDG London, developers, tech enthusiasts)
- Each content should have a different tone (informative, conversational, inspirational, etc.)
- Include call-to-action where appropriate
- Number each content (1., 2., 3.)

Format your response exactly like this:
1. First content here
2. Second content here
3. Third content here''';
  }

  String _buildTagsPrompt(String topic) {
    return '''You are a social media expert for a tech community. Generate 3 different sets of hashtags for: "$topic".

Requirements:
- Each set should have 3-5 relevant hashtags
- Make them suitable for professional tech community posts (GDG London, developers, tech enthusiasts)
- Include both broad and specific hashtags
- Each set should target different audiences or aspects
- Number each set (1., 2., 3.)
- Format as comma-separated values

Format your response exactly like this:
1. hashtag1, hashtag2, hashtag3
2. hashtag1, hashtag2, hashtag3, hashtag4
3. hashtag1, hashtag2, hashtag3, hashtag4, hashtag5''';
  }

  String _buildMentionsPrompt(String topic) {
    return '''You are a social media expert for a tech community. Generate 3 different sets of relevant mentions for: "$topic".

Requirements:
- Each set should have 2-4 relevant mentions
- Include tech companies, communities, or individuals relevant to the topic
- Make them suitable for professional tech community posts (GDG London, developers, tech enthusiasts)
- Each set should target different stakeholders or communities
- Number each set (1., 2., 3.)
- Format as comma-separated values

Format your response exactly like this:
1. mention1, mention2
2. mention1, mention2, mention3
3. mention1, mention2, mention3, mention4''';
  }

  List<String> _parseVariants(String response) {
    final lines = response.split('\n');
    final variants = <String>[];

    for (final line in lines) {
      if (line.trim().startsWith(RegExp(r'^\d+\.'))) {
        final content = line.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();
        if (content.isNotEmpty) {
          variants.add(content);
        }
      }
    }

    return variants.take(3).toList();
  }

  List<List<String>> _parseTagVariants(String response) {
    final lines = response.split('\n');
    final variants = <List<String>>[];

    for (final line in lines) {
      if (line.trim().startsWith(RegExp(r'^\d+\.'))) {
        final content = line.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();
        if (content.isNotEmpty) {
          final tags = content.split(',').map((tag) => tag.trim()).toList();
          variants.add(tags);
        }
      }
    }

    return variants.take(3).toList();
  }

  List<List<String>> _parseMentionVariants(String response) {
    final lines = response.split('\n');
    final variants = <List<String>>[];

    for (final line in lines) {
      if (line.trim().startsWith(RegExp(r'^\d+\.'))) {
        final content = line.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();
        if (content.isNotEmpty) {
          final mentions =
              content.split(',').map((mention) => mention.trim()).toList();
          variants.add(mentions);
        }
      }
    }

    return variants.take(3).toList();
  }
}
