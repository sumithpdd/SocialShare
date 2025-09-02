import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/organization_header.dart';
import '../widgets/navigation_rail.dart';
import '../widgets/post_card.dart';
import '../providers/post_provider.dart';
import '../utils/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const CustomNavigationRail(),
          Expanded(
            child: Column(
              children: [
                const OrganizationHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeSection(),
                          const SizedBox(height: 32),
                          _buildQuickActions(context),
                          const SizedBox(height: 32),
                          _buildStatsCards(),
                          const SizedBox(height: 32),
                          _buildRecentPostsSection(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to SocialShare',
          style: AppTheme.headlineLarge,
        ),
        SizedBox(height: 16),
        Text(
          'Manage your social media posts for GDG London across multiple platforms.',
          style: AppTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: AppTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => context.go('/create'),
              icon: const Icon(Icons.add),
              label: const Text('Create New Post'),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => context.go('/ai-create'),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('AI Post Creator ✨'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => context.go('/calendar'),
              icon: const Icon(Icons.calendar_today),
              label: const Text('View Calendar'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: AppTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 40,
                        color: AppTheme.primaryBlue,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Upcoming Posts',
                        style: AppTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '7',
                        style: AppTheme.headlineLarge.copyWith(
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 40,
                        color: AppTheme.primaryGreen,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Posted',
                        style: AppTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '3',
                        style: AppTheme.headlineLarge.copyWith(
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.share,
                        size: 40,
                        color: AppTheme.primaryYellow,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Platforms',
                        style: AppTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '6',
                        style: AppTheme.headlineLarge.copyWith(
                          color: AppTheme.primaryYellow,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentPostsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Posts',
              style: AppTheme.headlineMedium,
            ),
            TextButton(
              onPressed: () => context.go('/calendar'),
              child: const Text('View All Posts'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Consumer<PostProvider>(
          builder: (context, postProvider, child) {
            if (postProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (postProvider.error != null) {
              return Center(
                child: Column(
                  children: [
                    Text(
                      'Error: ${postProvider.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: () => postProvider.refreshPosts(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final posts = postProvider.posts;
            if (posts.isEmpty) {
              return const Center(
                child: Text(
                  'No posts available',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            final recentPosts = posts.take(6).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Showing ${recentPosts.length} of ${posts.length} total posts',
                  style: AppTheme.bodySmall.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: recentPosts.length,
                  itemBuilder: (context, index) {
                    final post = recentPosts[index];
                    return PostCard(
                      post: post,
                      onTap: () => context.go('/post/${post.id}'),
                      onEdit: () {
                        context.go('/create', extra: {'editPost': post});
                      },
                      onDelete: () {
                        // TODO: Implement delete functionality
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
