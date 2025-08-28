import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/dummy_data_service.dart';
import '../utils/theme.dart';

class OrganizationHeader extends StatelessWidget {
  const OrganizationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final organization = DummyDataService.gdgLondon;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 120,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/logo/gdgLondon_while_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.white,
                    child: const Icon(
                      Icons.groups,
                      size: 30,
                      color: AppTheme.primaryBlue,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Organization Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  organization.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  organization.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  organization.location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),

          // Social Links
          Row(
            children: [
              _buildSocialButton(
                icon: Icons.link,
                label: 'LinkedIn',
                onTap: () => _launchUrl(organization.linkedinUrl),
                color: const Color(0xFF0077B5),
              ),
              const SizedBox(width: 12),
              _buildSocialButton(
                icon: Icons.flutter_dash,
                label: 'Twitter/X',
                onTap: () => _launchUrl(organization.twitterUrl),
                color: const Color(0xFF1DA1F2),
              ),
              if (organization.websiteUrl != null) ...[
                const SizedBox(width: 12),
                _buildSocialButton(
                  icon: Icons.language,
                  label: 'Website',
                  onTap: () => _launchUrl(organization.websiteUrl!),
                  color: Colors.white,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color:
                  color == Colors.white ? AppTheme.primaryBlue : Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color:
                    color == Colors.white ? AppTheme.primaryBlue : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
