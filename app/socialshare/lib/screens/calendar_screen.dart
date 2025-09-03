import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/post_provider.dart';
import '../providers/tag_provider.dart';
import '../providers/campaign_provider.dart';
import '../providers/team_member_provider.dart';
import '../widgets/organization_header.dart';
import '../widgets/navigation_rail.dart';
import '../widgets/post_card.dart';
import '../utils/theme.dart';
import '../models/post.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isGridView = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Pagination and filtering
  final int _pageSize = 9; // 3x3 grid
  int _currentPage = 0;
  String _selectedFilter = 'All';
  String? _selectedCampaign;
  String? _selectedTag;
  String? _selectedTeamMember;
  final List<String> _filterOptions = [
    'All',
    'Posted',
    'Draft',
    'Today',
    'This Week',
    'This Month',
    'By Campaign',
    'By Tag',
    'By Team Member'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Post Calendar',
                              style: AppTheme.headlineLarge,
                            ),
                            ElevatedButton.icon(
                              onPressed: () => context.go('/create'),
                              icon: const Icon(Icons.add),
                              label: const Text('Create Post'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Search, filter, and toggle section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search posts...',
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon: _searchQuery.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(Icons.clear),
                                              onPressed: () {
                                                setState(() {
                                                  _searchController.clear();
                                                  _searchQuery = '';
                                                  _currentPage = 0;
                                                });
                                              },
                                            )
                                          : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _searchQuery = value;
                                        _currentPage =
                                            0; // Reset to first page when searching
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Filter dropdown
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            Colors.grey.withValues(alpha: 0.3)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DropdownButton<String>(
                                        value: _selectedFilter,
                                        underline: Container(),
                                        items:
                                            _filterOptions.map((String filter) {
                                          return DropdownMenuItem<String>(
                                            value: filter,
                                            child: Text(filter),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            setState(() {
                                              _selectedFilter = newValue;
                                              _currentPage =
                                                  0; // Reset to first page when filtering
                                            });
                                          }
                                        },
                                      ),
                                      if (_selectedFilter != 'All')
                                        IconButton(
                                          icon:
                                              const Icon(Icons.clear, size: 16),
                                          onPressed: () {
                                            setState(() {
                                              _selectedFilter = 'All';
                                              _currentPage = 0;
                                            });
                                          },
                                          tooltip: 'Clear filter',
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Additional filter controls
                            if (_selectedFilter == 'By Campaign' || 
                                _selectedFilter == 'By Tag' || 
                                _selectedFilter == 'By Team Member')
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    if (_selectedFilter == 'By Campaign')
                                      Expanded(
                                        child: Consumer<CampaignProvider>(
                                          builder: (context, campaignProvider, child) {
                                            return DropdownButtonFormField<String>(
                                              value: _selectedCampaign,
                                              decoration: const InputDecoration(
                                                labelText: 'Select Campaign',
                                                border: OutlineInputBorder(),
                                              ),
                                              items: [
                                                const DropdownMenuItem<String>(
                                                  value: null,
                                                  child: Text('All Campaigns'),
                                                ),
                                                ...campaignProvider.campaigns
                                                    .map((campaign) => DropdownMenuItem(
                                                          value: campaign.id,
                                                          child: Text(campaign.name),
                                                        ))
                                                    .toList(),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedCampaign = value;
                                                  _currentPage = 0;
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    if (_selectedFilter == 'By Tag')
                                      Expanded(
                                        child: Consumer<TagProvider>(
                                          builder: (context, tagProvider, child) {
                                            return DropdownButtonFormField<String>(
                                              value: _selectedTag,
                                              decoration: const InputDecoration(
                                                labelText: 'Select Tag',
                                                border: OutlineInputBorder(),
                                              ),
                                              items: [
                                                const DropdownMenuItem<String>(
                                                  value: null,
                                                  child: Text('All Tags'),
                                                ),
                                                ...tagProvider.tags
                                                    .map((tag) => DropdownMenuItem(
                                                          value: tag.name,
                                                          child: Text(tag.name),
                                                        ))
                                                    .toList(),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedTag = value;
                                                  _currentPage = 0;
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    if (_selectedFilter == 'By Team Member')
                                      Expanded(
                                        child: Consumer<TeamMemberProvider>(
                                          builder: (context, teamProvider, child) {
                                            return DropdownButtonFormField<String>(
                                              value: _selectedTeamMember,
                                              decoration: const InputDecoration(
                                                labelText: 'Select Team Member',
                                                border: OutlineInputBorder(),
                                              ),
                                              items: [
                                                const DropdownMenuItem<String>(
                                                  value: null,
                                                  child: Text('All Team Members'),
                                                ),
                                                ...teamProvider.teamMembers
                                                    .map((member) => DropdownMenuItem(
                                                          value: member.name,
                                                          child: Text(member.name),
                                                        ))
                                                    .toList(),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedTeamMember = value;
                                                  _currentPage = 0;
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Grid View'),
                                Switch(
                                  value: _isGridView,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedDay =
                                          null; // Clear selected day when switching to grid view
                                      _currentPage =
                                          0; // Reset pagination when switching views
                                      _isGridView = value;
                                    });
                                  },
                                ),
                                const Text('Calendar View'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: _isGridView
                              ? _buildGridView()
                              : _buildCalendarView(),
                        ),
                      ],
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

  Widget _buildGridView() {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        if (postProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (postProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
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

        var posts = postProvider.posts;

        // Apply filters
        posts = _applyFilters(posts);

        // Apply search filter if search query exists
        if (_searchQuery.isNotEmpty) {
          posts = posts.where((post) {
            final query = _searchQuery.toLowerCase();
            return post.title.toLowerCase().contains(query) ||
                post.content.toLowerCase().contains(query) ||
                post.tags.any((tag) => tag.toLowerCase().contains(query)) ||
                (post.campaign?.toLowerCase().contains(query) ?? false) ||
                post.postedBy.toLowerCase().contains(query);
          }).toList();
        }

        if (posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isNotEmpty
                      ? 'No posts found for "$_searchQuery"'
                      : 'No posts available',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Calculate pagination
        final totalPages = (posts.length / _pageSize).ceil();
        final startIndex = _currentPage * _pageSize;
        final endIndex = (startIndex + _pageSize).clamp(0, posts.length);
        final currentPagePosts = posts.sublist(startIndex, endIndex);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Showing ${startIndex + 1}-$endIndex of $posts.length posts',
                    style: AppTheme.bodyMedium.copyWith(color: Colors.grey),
                  ),
                  if (totalPages > 1) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _currentPage > 0
                              ? () {
                                  setState(() {
                                    _currentPage--;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${_currentPage + 1} of $totalPages',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        IconButton(
                          onPressed: _currentPage < totalPages - 1
                              ? () {
                                  setState(() {
                                    _currentPage++;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: currentPagePosts.length,
                itemBuilder: (context, index) {
                  final post = currentPagePosts[index];
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalendarView() {
    return Row(
      children: [
        // Calendar
        Expanded(
          flex: 2,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Calendar',
                    style: AppTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildCalendar(),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Posts for selected day
        Expanded(
          flex: 3,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedDay != null
                        ? 'Posts for ${_formatDate(_selectedDay!)}'
                        : 'Select a date to view posts',
                    style: AppTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildPostsForSelectedDay(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedDay = null; // Clear selected day when changing month
                  _currentPage = 0; // Reset pagination when changing month
                  _focusedDay =
                      DateTime(_focusedDay.year, _focusedDay.month - 1);
                });
              },
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              '${_getMonthName(_focusedDay.month)} ${_focusedDay.year}',
              style: AppTheme.headlineMedium,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedDay = null; // Clear selected day when changing month
                  _currentPage = 0; // Reset pagination when changing month
                  _focusedDay =
                      DateTime(_focusedDay.year, _focusedDay.month + 1);
                });
              },
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Calendar grid
        Expanded(
          child: _buildCalendarGrid(),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    return Column(
      children: [
        // Weekday headers
        Row(
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map((day) => Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        // Calendar days
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: 42, // 6 weeks * 7 days
            itemBuilder: (context, index) {
              final dayOffset = index - (firstWeekday - 1);
              final day = dayOffset + 1;

              if (day < 1 || day > daysInMonth) {
                return Container();
              }

              final date = DateTime(_focusedDay.year, _focusedDay.month, day);
              final isSelected = _selectedDay?.year == date.year &&
                  _selectedDay?.month == date.month &&
                  _selectedDay?.day == date.day;

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedDay = date;
                    _currentPage =
                        0; // Reset pagination when selecting a new date
                  });
                  context.read<PostProvider>().selectDate(date);
                },
                child: FutureBuilder<List<Post>>(
                  future: context.read<PostProvider>().getPostsByDate(date),
                  builder: (context, snapshot) {
                    final posts = snapshot.data ?? [];
                    return Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: posts.isNotEmpty
                              ? AppTheme.primaryGreen
                              : Colors.grey.withValues(alpha: 0.3),
                          width: posts.isNotEmpty ? 2 : 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              day.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          if (posts.isNotEmpty)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPostsForSelectedDay() {
    if (_selectedDay == null) {
      return const Center(
        child: Text(
          'Select a date from the calendar to view posts',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return FutureBuilder<List<Post>>(
      future: context.read<PostProvider>().getPostsByDate(_selectedDay!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return const Center(
            child: Text(
              'No posts scheduled for this date',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Apply pagination to calendar view posts
        final totalPages = (posts.length / _pageSize).ceil();
        final startIndex = _currentPage * _pageSize;
        final endIndex = (startIndex + _pageSize).clamp(0, posts.length);
        final currentPagePosts = posts.sublist(startIndex, endIndex);

        return Column(
          children: [
            // Pagination controls
            if (totalPages > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _currentPage > 0
                          ? () {
                              setState(() {
                                _currentPage--;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_currentPage + 1} of $totalPages',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ),
                    IconButton(
                      onPressed: _currentPage < totalPages - 1
                          ? () {
                              setState(() {
                                _currentPage++;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
            // Posts list
            Expanded(
              child: ListView.builder(
                itemCount: currentPagePosts.length,
                itemBuilder: (context, index) {
                  final post = currentPagePosts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PostCard(
                      post: post,
                      onTap: () {
                        context.go('/post/${post.id}');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  List<Post> _applyFilters(List<Post> posts) {
    switch (_selectedFilter) {
      case 'Posted':
        return posts.where((post) => post.isPosted).toList();
      case 'Draft':
        return posts.where((post) => !post.isPosted).toList();
      case 'Today':
        final today = DateTime.now();
        return posts.where((post) {
          return post.date.year == today.year &&
              post.date.month == today.month &&
              post.date.day == today.day;
        }).toList();
      case 'This Week':
        final now = DateTime.now();
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return posts.where((post) {
          return post.date
                  .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              post.date.isBefore(endOfWeek.add(const Duration(days: 1)));
        }).toList();
      case 'This Month':
        final now = DateTime.now();
        return posts.where((post) {
          return post.date.year == now.year && post.date.month == now.month;
        }).toList();
      case 'By Campaign':
        if (_selectedCampaign != null) {
          return posts.where((post) => post.campaign == _selectedCampaign).toList();
        }
        return posts;
      case 'By Tag':
        if (_selectedTag != null) {
          return posts.where((post) => post.tags.contains(_selectedTag)).toList();
        }
        return posts;
      case 'By Team Member':
        if (_selectedTeamMember != null) {
          return posts.where((post) => post.postedBy == _selectedTeamMember).toList();
        }
        return posts;
      default:
        return posts;
    }
  }
}
