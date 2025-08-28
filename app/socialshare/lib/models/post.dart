import 'package:flutter/material.dart';

class Post {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final bool isPosted;
  final String postedBy;
  final String? imageUrl;
  final String? videoUrl;
  final List<String> tags;
  final List<SocialPlatform> platforms;
  final List<String> additionalLinks;
  final DateTime? postedAt;
  final String? postUrl;
  final String? campaign;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.isPosted,
    required this.postedBy,
    this.imageUrl,
    this.videoUrl,
    required this.tags,
    required this.platforms,
    required this.additionalLinks,
    this.postedAt,
    this.postUrl,
    this.campaign,
  });

  Post copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    bool? isPosted,
    String? postedBy,
    String? imageUrl,
    String? videoUrl,
    List<String>? tags,
    List<SocialPlatform>? platforms,
    List<String>? additionalLinks,
    DateTime? postedAt,
    String? postUrl,
    String? campaign,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      isPosted: isPosted ?? this.isPosted,
      postedBy: postedBy ?? this.postedBy,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      tags: tags ?? this.tags,
      platforms: platforms ?? this.platforms,
      additionalLinks: additionalLinks ?? this.additionalLinks,
      postedAt: postedAt ?? this.postedAt,
      postUrl: postUrl ?? this.postUrl,
      campaign: campaign ?? this.campaign,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'isPosted': isPosted,
      'postedBy': postedBy,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'tags': tags,
      'platforms': platforms.map((p) => p.name).toList(),
      'additionalLinks': additionalLinks,
      'postedAt': postedAt?.toIso8601String(),
      'postUrl': postUrl,
      'campaign': campaign,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      isPosted: json['isPosted'],
      postedBy: json['postedBy'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      tags: List<String>.from(json['tags']),
      platforms: (json['platforms'] as List)
          .map((p) => SocialPlatform.values.firstWhere((sp) => sp.name == p))
          .toList(),
      additionalLinks: List<String>.from(json['additionalLinks']),
      postedAt:
          json['postedAt'] != null ? DateTime.parse(json['postedAt']) : null,
      postUrl: json['postUrl'],
      campaign: json['campaign'],
    );
  }
}

enum SocialPlatform {
  linkedin('LinkedIn', Icons.work),
  twitter('Twitter/X', Icons.flutter_dash),
  facebook('Facebook', Icons.facebook),
  instagram('Instagram', Icons.camera_alt),
  youtube('YouTube', Icons.play_circle),
  meetup('Meetup', Icons.group);

  const SocialPlatform(this.displayName, this.icon);
  final String displayName;
  final IconData icon;
}
