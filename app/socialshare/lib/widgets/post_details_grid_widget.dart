import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../models/post.dart';

class PostDetailsGridWidget extends StatelessWidget {
  final Post post;

  const PostDetailsGridWidget({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Post Details',
          style: AppTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                icon: Icons.calendar_today,
                label: 'Scheduled Date',
                value: _formatDate(post.date),
              ),
            ),
            Expanded(
              child: _buildDetailItem(
                icon: Icons.person,
                label: 'Posted By',
                value: post.postedBy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (post.postedAt != null)
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.check_circle,
                  label: 'Posted At',
                  value: _formatDateTime(post.postedAt!),
                ),
              ),
              if (post.postUrl != null)
                Expanded(
                  child: _buildDetailItem(
                    icon: Icons.link,
                    label: 'Post URL',
                    value: post.postUrl!,
                    isLink: true,
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isLink)
            InkWell(
              onTap: () => _launchUrl(value),
              child: Text(
                value,
                style: const TextStyle(
                  color: AppTheme.primaryBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          else
            Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _launchUrl(String url) async {
    // Implementation for launching URLs
    // This would typically use url_launcher package
  }
}
