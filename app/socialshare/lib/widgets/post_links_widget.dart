import 'package:flutter/material.dart';
import '../utils/theme.dart';

class PostLinksWidget extends StatelessWidget {
  final List<String> links;

  const PostLinksWidget({
    super.key,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    if (links.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Links',
          style: AppTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        ...links.map((link) => _buildLinkItem(link)),
      ],
    );
  }

  Widget _buildLinkItem(String link) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _launchUrl(link),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.link, color: AppTheme.primaryBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  link,
                  style: const TextStyle(
                    color: AppTheme.primaryBlue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Icon(Icons.open_in_new, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    // Implementation for launching URLs
    // This would typically use url_launcher package
  }
}
