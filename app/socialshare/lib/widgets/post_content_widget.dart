import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/theme.dart';
import '../models/post.dart';

class PostContentWidget extends StatelessWidget {
  final Post post;

  const PostContentWidget({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and status
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      post.title,
                      style: AppTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () =>
                        _copyToClipboard(context, post.title, 'Title'),
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy title',
                    color: AppTheme.primaryBlue,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _buildStatusChip(post),
          ],
        ),
        const SizedBox(height: 16),

        // Campaign badge (if available)
        if (post.campaign != null) ...[
          _buildCampaignBadge(post.campaign!),
          const SizedBox(height: 16),
        ],

        // Content with copy button
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                post.content,
                style: AppTheme.bodyLarge.copyWith(height: 1.6),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () =>
                  _copyToClipboard(context, post.content, 'Content'),
              icon: const Icon(Icons.copy),
              tooltip: 'Copy content',
              color: AppTheme.primaryBlue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(Post post) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: post.isPosted ? AppTheme.primaryGreen : AppTheme.primaryYellow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            post.isPosted ? Icons.check_circle : Icons.schedule,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            post.isPosted ? 'Posted' : 'Scheduled',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignBadge(String campaign) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryBlue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.campaign,
            size: 16,
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(width: 8),
          Text(
            campaign,
            style: const TextStyle(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyToClipboard(
      BuildContext context, String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label copied to clipboard')),
      );
    }
  }
}
