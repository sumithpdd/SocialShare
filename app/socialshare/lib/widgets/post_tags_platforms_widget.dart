import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../models/post.dart';

class PostTagsPlatformsWidget extends StatelessWidget {
  final Post post;

  const PostTagsPlatformsWidget({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tags
        if (post.tags.isNotEmpty) ...[
          const Text(
            'Tags',
            style: AppTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: post.tags
                .map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor:
                          AppTheme.primaryBlue.withValues(alpha: 0.1),
                    ))
                .toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Platforms
        const Text(
          'Platforms',
          style: AppTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: post.platforms
              .map((platform) => _buildPlatformChip(platform))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPlatformChip(SocialPlatform platform) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _getPlatformColor(platform),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getPlatformIcon(platform),
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            platform.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPlatformColor(SocialPlatform platform) {
    switch (platform) {
      case SocialPlatform.linkedin:
        return const Color(0xFF0077B5);
      case SocialPlatform.twitter:
        return const Color(0xFF1DA1F2);
      case SocialPlatform.facebook:
        return const Color(0xFF1877F2);
      case SocialPlatform.instagram:
        return const Color(0xFFE4405F);
      case SocialPlatform.youtube:
        return const Color(0xFFFF0000);
      case SocialPlatform.meetup:
        return const Color(0xFFE51937);
    }
  }

  IconData _getPlatformIcon(SocialPlatform platform) {
    return platform.icon;
  }
}
