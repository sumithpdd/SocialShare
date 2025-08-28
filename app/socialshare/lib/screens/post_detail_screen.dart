import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/post_provider.dart';
import '../models/post.dart';
import '../widgets/organization_header.dart';
import '../widgets/navigation_rail.dart';
import '../widgets/post_header_widget.dart';
import '../widgets/post_content_widget.dart';
import '../widgets/post_media_widget.dart';
import '../widgets/post_details_grid_widget.dart';
import '../widgets/post_tags_platforms_widget.dart';
import '../widgets/post_links_widget.dart';
import '../widgets/loading_error_widget.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Post? _post;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  Future<void> _loadPost() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final postProvider = context.read<PostProvider>();
      final post = await postProvider.repository.getPostById(widget.postId);
      if (mounted) {
        setState(() {
          _post = post;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load post: $e';
          _isLoading = false;
        });
      }
    }
  }

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
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Consumer<PostProvider>(
                      builder: (context, postProvider, child) {
                        // Show loading/error states
                        if (_isLoading) {
                          return const LoadingErrorWidget(isLoading: true);
                        }

                        if (_error != null) {
                          return LoadingErrorWidget(
                            isLoading: false,
                            error: _error,
                            onRetry: _loadPost,
                          );
                        }

                        // Try to get post from provider first, then from local state
                        Post? post = postProvider.posts.firstWhere(
                          (p) => p.id == widget.postId,
                          orElse: () =>
                              _post ??
                              Post(
                                id: 'not_found',
                                title: 'Post Not Found',
                                content:
                                    'The requested post could not be found.',
                                date: DateTime.now(),
                                isPosted: false,
                                postedBy: 'Unknown',
                                tags: [],
                                platforms: [],
                                additionalLinks: [],
                              ),
                        );

                        return _buildPostDetail(context, post, postProvider);
                      },
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

  Widget _buildPostDetail(
      BuildContext context, Post post, PostProvider postProvider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with back button and actions
          PostHeaderWidget(
            post: post,
            onEdit: () {
              context.go('/create', extra: {'editPost': post});
            },
            onToggleStatus: () async {
              final currentContext = context;
              try {
                await postProvider.togglePostStatus(post.id);
                // Refresh the post data
                await _loadPost();
              } catch (e) {
                if (currentContext.mounted) {
                  ScaffoldMessenger.of(currentContext).showSnackBar(
                    SnackBar(content: Text('Failed to update post status: $e')),
                  );
                }
              }
            },
          ),
          const SizedBox(height: 24),

          // Post content
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post content section
                  PostContentWidget(post: post),
                  const SizedBox(height: 24),

                  // Media section
                  PostMediaWidget(post: post),
                  if (post.imageUrl != null || post.videoUrl != null) ...[
                    const SizedBox(height: 24),
                  ],

                  // Post details grid
                  PostDetailsGridWidget(post: post),
                  const SizedBox(height: 24),

                  // Tags and platforms
                  PostTagsPlatformsWidget(post: post),
                  const SizedBox(height: 24),

                  // Additional links
                  PostLinksWidget(links: post.additionalLinks),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
