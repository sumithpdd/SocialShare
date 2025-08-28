import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../models/post.dart';

class PostMediaWidget extends StatelessWidget {
  final Post post;

  const PostMediaWidget({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    if (post.imageUrl == null && post.videoUrl == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Media',
          style: AppTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        if (post.imageUrl != null) _buildImageSection(),
        if (post.videoUrl != null) ...[
          if (post.imageUrl != null) const SizedBox(height: 12),
          _buildVideoSection(),
        ],
      ],
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          post.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.image, size: 60, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoSection() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
            ),
            const Icon(Icons.video_library, size: 60, color: Colors.grey),
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Video Content',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
