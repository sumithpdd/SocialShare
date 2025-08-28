import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/theme.dart';
import '../models/post.dart';

class PostHeaderWidget extends StatelessWidget {
  final Post post;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const PostHeaderWidget({
    super.key,
    required this.post,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.go('/calendar'),
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Text(
            'Post Details',
            style: AppTheme.headlineLarge,
          ),
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: onToggleStatus,
              icon: Icon(
                post.isPosted ? Icons.schedule : Icons.check_circle,
              ),
              label: Text(
                post.isPosted ? 'Mark as Scheduled' : 'Mark as Posted',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
