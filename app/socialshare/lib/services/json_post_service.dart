import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import '../models/post.dart';
import '../models/organization.dart';

class JsonPostService {
  static final Organization gdgLondon = Organization(
    id: '1',
    name: 'GDG London',
    description:
        'Google Developer Group in London. Follow us to find out about London meetups for all things Google',
    linkedinUrl: 'https://www.linkedin.com/company/google-developers-london/',
    twitterUrl: 'https://x.com/gdg_london',
    websiteUrl: 'https://gdg.community.dev/gdg-london/',
    logoUrl: 'https://via.placeholder.com/150x150/4285F4/FFFFFF?text=GDG',
    location: 'London, England',
  );

  static List<Post> _posts = [];
  static bool _isLoaded = false;
  static final Map<String, String> _idToFilePath = {};

  /// Loads all posts from the assets/posts folder
  static Future<List<Post>> loadPosts() async {
    if (_isLoaded) {
      return _posts;
    }

    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Filter for JSON files in the posts folder
      final postFiles = manifestMap.keys
          .where((String key) =>
              key.startsWith('assets/posts/') && key.endsWith('.json'))
          .toList();

      _posts.clear();
      _idToFilePath.clear();

      for (final filePath in postFiles) {
        try {
          final jsonString = await rootBundle.loadString(filePath);
          final jsonData = json.decode(jsonString) as Map<String, dynamic>;

          final post = _parsePostFromJson(jsonData);
          if (post != null) {
            _posts.add(post);
            if (post.id.isNotEmpty) {
              _idToFilePath[post.id] = filePath;
            }
          }
        } catch (e) {
          print('Error loading post from $filePath: $e');
        }
      }

      // Sort posts by date (newest first)
      _posts.sort((a, b) => b.date.compareTo(a.date));
      _isLoaded = true;

      print('Loaded ${_posts.length} posts from assets/posts folder');
      return _posts;
    } catch (e) {
      print('Error loading posts: $e');
      return [];
    }
  }

  /// Refreshes posts from the assets/posts folder
  static Future<List<Post>> refreshPosts() async {
    _isLoaded = false;
    return await loadPosts();
  }

  /// Parses a JSON object into a Post object
  static Post? _parsePostFromJson(Map<String, dynamic> json) {
    try {
      return Post(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        date: DateTime.parse(json['date'] as String),
        isPosted: json['isPosted'] as bool? ?? false,
        postedBy: json['postedBy'] as String,
        imageUrl: json['imageUrl'] as String?,
        tags: List<String>.from(json['tags'] ?? []),
        platforms: _parsePlatforms(json['platforms']),
        additionalLinks: List<String>.from(json['additionalLinks'] ?? []),
        campaign: json['campaign'] as String?,
        mentions: List<String>.from(json['mentions'] ?? []),
        postedAt: json['postedAt'] != null
            ? DateTime.parse(json['postedAt'] as String)
            : null,
        postUrl: json['postUrl'] as String?,
      );
    } catch (e) {
      print('Error parsing post JSON: $e');
      return null;
    }
  }

  /// Converts string platform names to SocialPlatform enum values
  static List<SocialPlatform> _parsePlatforms(List<dynamic> platforms) {
    return platforms.map((platform) {
      switch (platform.toString().toLowerCase()) {
        case 'linkedin':
          return SocialPlatform.linkedin;
        case 'twitter':
          return SocialPlatform.twitter;
        case 'facebook':
          return SocialPlatform.facebook;
        case 'instagram':
          return SocialPlatform.instagram;
        case 'meetup':
          return SocialPlatform.meetup;
        case 'youtube':
          return SocialPlatform.youtube;
        default:
          return SocialPlatform.linkedin; // Default fallback
      }
    }).toList();
  }

  /// Gets posts by date
  static List<Post> getPostsByDate(DateTime date) {
    return _posts
        .where((post) =>
            post.date.year == date.year &&
            post.date.month == date.month &&
            post.date.day == date.day)
        .toList();
  }

  /// Gets upcoming posts
  static List<Post> getUpcomingPosts() {
    final now = DateTime.now();
    return _posts.where((post) => post.date.isAfter(now)).toList();
  }

  /// Gets posted posts
  static List<Post> getPostedPosts() {
    return _posts.where((post) => post.isPosted).toList();
  }

  /// Gets recent posts
  static List<Post> getRecentPosts() {
    return _posts.take(6).toList();
  }

  /// Gets posts by platform
  static List<Post> getPostsByPlatform(SocialPlatform platform) {
    return _posts.where((post) => post.platforms.contains(platform)).toList();
  }

  /// Gets posts by tag
  static List<Post> getPostsByTag(String tag) {
    return _posts.where((post) => post.tags.contains(tag)).toList();
  }

  /// Gets posts by campaign
  static List<Post> getPostsByCampaign(String campaign) {
    return _posts.where((post) => post.campaign == campaign).toList();
  }

  /// Gets available campaigns
  static List<String> getAvailableCampaigns() {
    return _posts
        .where((post) => post.campaign != null)
        .map((post) => post.campaign!)
        .toSet()
        .toList();
  }

  /// Gets all posts
  static List<Post> getAllPosts() {
    return List.from(_posts);
  }

  /// Gets post by ID
  static Post? getPostById(String id) {
    try {
      return _posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }

  /// New filename convention: yyyy_MM_dd_<first 15 chars of title>.json
  static String createFilename(DateTime date, String title) {
    final yyyy = date.year.toString().padLeft(4, '0');
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    final sanitized = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final head =
        sanitized.substring(0, sanitized.length > 15 ? 15 : sanitized.length);
    return 'assets/posts/${yyyy}_${mm}_${dd}_${head}.json';
  }

  /// Create a unique filename if conflict exists (appends _2, _3, ...)
  static String _resolveConflict(String basePath) {
    var candidate = basePath;
    var idx = 2;
    while (File(candidate).existsSync()) {
      final dot = candidate.lastIndexOf('.');
      if (dot > -1) {
        candidate =
            candidate.substring(0, dot) + '_${idx}' + candidate.substring(dot);
      } else {
        candidate = '${candidate}_${idx}';
      }
      idx += 1;
    }
    return candidate;
  }

  /// Saves a post as JSON file (desktop/dev only). Returns the file path or null on failure.
  static Future<String?> createPostFile(Post post) async {
    if (kIsWeb) {
      print(
          'Create not supported on web runtime. Please run on desktop or manage files outside the app.');
      return null;
    }
    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      print('Create not supported for assets on this platform at runtime.');
      return null;
    }
    try {
      final basePath = createFilename(post.date, post.title);
      final resolvedPath = _resolveConflict(basePath);
      final file = File(resolvedPath);
      await file.parent.create(recursive: true);
      final jsonData = _postToJson(post);
      await file
          .writeAsString(const JsonEncoder.withIndent('  ').convert(jsonData));

      // Update in-memory state
      _idToFilePath[post.id] = resolvedPath.replaceAll('\\', '/');
      _posts.add(post);
      _posts.sort((a, b) => b.date.compareTo(a.date));
      return resolvedPath;
    } catch (e) {
      print('Error creating post file: $e');
      return null;
    }
  }

  /// Updates the file for a post. Renames the file if the filename changes.
  static Future<bool> updatePostFile(Post post) async {
    if (kIsWeb) {
      print(
          'Update not supported on web runtime. Please run on desktop or manage files outside the app.');
      return false;
    }
    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      print('Update not supported for assets on this platform at runtime.');
      return false;
    }
    try {
      final currentPath = _idToFilePath[post.id];
      final desiredPath = createFilename(post.date, post.title);

      String targetPath = desiredPath;
      if (currentPath == null) {
        // No mapping, treat like create
        final created = await createPostFile(post);
        return created != null;
      } else {
        // If filename changed, rename
        if (currentPath != desiredPath) {
          final resolvedPath = _resolveConflict(desiredPath);
          await File(currentPath).rename(resolvedPath);
          _idToFilePath[post.id] = resolvedPath;
          targetPath = resolvedPath;
        } else {
          targetPath = currentPath;
        }
      }

      // Write updated content
      final file = File(targetPath);
      final jsonData = _postToJson(post);
      await file
          .writeAsString(const JsonEncoder.withIndent('  ').convert(jsonData));

      // Update in-memory list
      final index = _posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        _posts[index] = post;
        _posts.sort((a, b) => b.date.compareTo(a.date));
      }
      return true;
    } catch (e) {
      print('Error updating post file: $e');
      return false;
    }
  }

  /// Deletes the file for a post by id.
  static Future<bool> deletePostFileById(String id) async {
    if (kIsWeb) {
      print(
          'Delete not supported on web runtime. Please run on desktop or manage files outside the app.');
      return false;
    }
    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      print('Delete not supported for assets on this platform at runtime.');
      return false;
    }
    try {
      final path = _idToFilePath[id];
      if (path == null) {
        print('No file mapping found for post id: $id');
        return false;
      }
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      _idToFilePath.remove(id);
      _posts.removeWhere((p) => p.id == id);
      return true;
    } catch (e) {
      print('Error deleting post file: $e');
      return false;
    }
  }

  /// Converts a Post object to JSON
  static Map<String, dynamic> _postToJson(Post post) {
    return {
      'id': post.id,
      'title': post.title,
      'content': post.content,
      'date': post.date.toIso8601String(),
      'isPosted': post.isPosted,
      'postedBy': post.postedBy,
      'imageUrl': post.imageUrl,
      'tags': post.tags,
      'platforms': post.platforms.map((p) => p.name).toList(),
      'additionalLinks': post.additionalLinks,
      'campaign': post.campaign,
      'mentions': post.mentions,
      'postedAt': post.postedAt?.toIso8601String(),
      'postUrl': post.postUrl,
    };
  }
}
