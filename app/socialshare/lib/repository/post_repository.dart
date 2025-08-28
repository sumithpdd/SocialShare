import '../models/post.dart';

abstract class PostRepository {
  Future<List<Post>> getAllPosts();
  Future<Post?> getPostById(String id);
  Future<List<Post>> getPostsByDate(DateTime date);
  Future<List<Post>> getUpcomingPosts();
  Future<List<Post>> getPostedPosts();
  Future<Post> createPost(Post post);
  Future<Post> updatePost(Post post);
  Future<bool> deletePost(String id);
  Future<Post> togglePostStatus(String id);
}

class PostRepositoryImpl implements PostRepository {
  final List<Post> _posts = [];
  int _nextId = 1;

  PostRepositoryImpl() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    // Initialize with some dummy data
    final now = DateTime.now();
    _posts.addAll([
      Post(
        id: '1',
        title: 'Welcome to Our Platform',
        content:
            'We are excited to announce the launch of our new social media management platform.',
        date: DateTime.now().add(const Duration(days: 1)),
        isPosted: false,
        postedBy: 'John Doe',
        tags: ['announcement', 'launch'],
        platforms: [SocialPlatform.linkedin, SocialPlatform.twitter],
        additionalLinks: [],
        campaign: 'Platform Launch',
      ),
      Post(
        id: '2',
        title: 'Best Practices for Social Media',
        content:
            'Learn the top strategies for effective social media marketing.',
        date: DateTime.now().add(const Duration(days: 2)),
        isPosted: false,
        postedBy: 'Jane Smith',
        tags: ['tips', 'marketing'],
        platforms: [SocialPlatform.facebook, SocialPlatform.instagram],
        additionalLinks: ['https://example.com/guide'],
        campaign: 'Educational Content',
      ),
      Post(
        id: '3',
        title: 'Weekly Industry Update',
        content:
            'Stay updated with the latest trends in social media marketing. This week we cover algorithm changes and new features.',
        date: DateTime.now().add(const Duration(days: 3)),
        isPosted: false,
        postedBy: 'Marketing Team',
        tags: ['industry', 'trends', 'weekly'],
        platforms: [
          SocialPlatform.linkedin,
          SocialPlatform.twitter,
          SocialPlatform.facebook
        ],
        additionalLinks: ['https://example.com/trends'],
        campaign: 'Weekly Updates',
      ),
      Post(
        id: '4',
        title: 'Customer Success Story',
        content:
            'How our client increased their engagement by 300% using our platform. Real results from real businesses.',
        date: DateTime.now().add(const Duration(days: 4)),
        isPosted: false,
        postedBy: 'Sarah Johnson',
        tags: ['case-study', 'success', 'customer'],
        platforms: [SocialPlatform.linkedin, SocialPlatform.instagram],
        additionalLinks: ['https://example.com/case-study'],
        campaign: 'Customer Stories',
      ),
      Post(
        id: '5',
        title: 'Product Feature Spotlight',
        content:
            'Discover our new AI-powered content suggestions feature. Save time and improve your content quality.',
        date: DateTime.now().add(const Duration(days: 5)),
        isPosted: false,
        postedBy: 'Product Team',
        tags: ['feature', 'AI', 'product'],
        platforms: [SocialPlatform.twitter, SocialPlatform.linkedin],
        additionalLinks: ['https://example.com/features'],
        campaign: 'Product Marketing',
      ),
      Post(
        id: '6',
        title: 'Community Engagement Tips',
        content:
            'Building a strong community around your brand is crucial. Here are proven strategies to increase engagement.',
        date: DateTime.now().add(const Duration(days: 6)),
        isPosted: false,
        postedBy: 'Community Manager',
        tags: ['community', 'engagement', 'tips'],
        platforms: [
          SocialPlatform.facebook,
          SocialPlatform.instagram,
          SocialPlatform.twitter
        ],
        additionalLinks: ['https://example.com/community'],
        campaign: 'Community Building',
      ),
      Post(
        id: '7',
        title: 'Analytics Deep Dive',
        content:
            'Understanding your social media metrics is key to success. Learn which KPIs matter most for your business.',
        date: DateTime.now().add(const Duration(days: 7)),
        isPosted: false,
        postedBy: 'Analytics Team',
        tags: ['analytics', 'metrics', 'KPIs'],
        platforms: [SocialPlatform.linkedin, SocialPlatform.twitter],
        additionalLinks: ['https://example.com/analytics'],
        campaign: 'Educational Content',
      ),
      Post(
        id: '8',
        title: 'Holiday Campaign Planning',
        content:
            'Start planning your holiday social media campaigns now. Early preparation leads to better results.',
        date: DateTime.now().add(const Duration(days: 8)),
        isPosted: false,
        postedBy: 'Campaign Manager',
        tags: ['holiday', 'campaign', 'planning'],
        platforms: [
          SocialPlatform.facebook,
          SocialPlatform.instagram,
          SocialPlatform.twitter
        ],
        additionalLinks: ['https://example.com/holiday-guide'],
        campaign: 'Holiday Marketing',
      ),
      Post(
        id: '9',
        title: 'Influencer Collaboration Guide',
        content:
            'Partnering with influencers can boost your brand reach. Here\'s how to find and work with the right influencers.',
        date: DateTime.now().add(const Duration(days: 9)),
        isPosted: false,
        postedBy: 'Partnership Team',
        tags: ['influencer', 'collaboration', 'partnership'],
        platforms: [
          SocialPlatform.instagram,
          SocialPlatform.youtube,
          SocialPlatform.facebook
        ],
        additionalLinks: ['https://example.com/influencer-guide'],
        campaign: 'Influencer Marketing',
      ),
      Post(
        id: '10',
        title: 'Content Calendar Template',
        content:
            'Download our free content calendar template to organize your social media posts effectively.',
        date: DateTime.now().add(const Duration(days: 10)),
        isPosted: false,
        postedBy: 'Content Team',
        tags: ['template', 'calendar', 'organization'],
        platforms: [SocialPlatform.linkedin, SocialPlatform.twitter],
        additionalLinks: ['https://example.com/template'],
        campaign: 'Resource Sharing',
      ),
      Post(
        id: '11',
        title: 'Social Media Trends Report',
        content:
            'Our monthly report on the latest social media trends and what they mean for your business.',
        date: DateTime.now().subtract(const Duration(days: 2)),
        isPosted: true,
        postedAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
        postedBy: 'Research Team',
        tags: ['report', 'trends', 'monthly'],
        platforms: [SocialPlatform.linkedin, SocialPlatform.twitter],
        additionalLinks: ['https://example.com/trends-report'],
        campaign: 'Monthly Reports',
      ),
      Post(
        id: '12',
        title: 'Team Building Workshop',
        content:
            'Join our free workshop on building effective social media teams. Learn from industry experts.',
        date: now.subtract(const Duration(days: 4)),
        isPosted: true,
        postedAt: now.subtract(const Duration(days: 4, hours: 2)),
        postedBy: 'Training Team',
        tags: ['workshop', 'training', 'team'],
        platforms: [SocialPlatform.facebook, SocialPlatform.linkedin],
        additionalLinks: ['https://example.com/workshop'],
        campaign: 'Training Programs',
      ),
      Post(
        id: '13',
        title: '🚀 Are you working on the cutting edge of AI?',
        content:
            'We\'re looking for speakers ready to share their insights, demos, or lessons learned in:\n\n🧠 GenAI • LLMs • Multimodal apps • AI agents • MLOps • Ethics • And more!\n\n👉 Apply to speak: https://lnkd.in/egqefzA2\n\n🙌 Prefer to join the audience and soak it all in?\n🎟️ Grab your ticket: https://lnkd.in/efcRfi9T\n\nLet\'s shape the future of AI together.',
        date: now.subtract(const Duration(days: 1)),
        isPosted: true,
        postedAt: now.subtract(const Duration(days: 1, hours: 3)),
        postedBy: 'GDG London Team',
        imageUrl:
            'https://media.licdn.com/dms/image/v2/D4D22AQF4bmFDeBjbEw/feedshare-shrink_800/B4DZhXExOdG8Ag-/0/1753807525207?e=1759363200&v=beta&t=SUWIq0O4gtEoNcywD3bkoQI2y1TY5oQztJ8ABoO-fv0',
        tags: ['AI', 'GenAI', 'LLMs', 'MLOps', 'speakers', 'GoogleIO'],
        platforms: [
          SocialPlatform.linkedin,
          SocialPlatform.twitter,
          SocialPlatform.facebook
        ],
        additionalLinks: [
          'https://lnkd.in/egqefzA2',
          'https://lnkd.in/efcRfi9T',
          'https://www.linkedin.com/feed/update/urn:li:activity:7356001921347858432'
        ],
        campaign: 'Google I/O Extended London',
      ),
      Post(
        id: '14',
        title:
            '🎉 Google I/O Extended London 2025 - Speakers & Sessions Announced!',
        content:
            '🚀 Get ready for an incredible lineup of speakers and sessions at Google I/O Extended London 2025!\n\n🎤 Our amazing speakers will cover:\n• GenAI & LLMs • Multimodal AI • AI Agents • MLOps • Ethics in AI • And much more!\n\n📅 Check out the full schedule: https://ioextended2025.gdg.london/schedule\n👥 Meet our speakers: https://ioextended2025.gdg.london/speakers\n\n🎟️ Tickets are going fast! Don\'t miss out on this cutting-edge AI event.\n\n#GoogleIO #GDGLondon #AI #GenAI #LLMs #MLOps #Speakers #Sessions',
        date: DateTime.now(),
        isPosted: false,
        postedBy:
            'Renuka Kelkar, Sumith Damodaran, Goran Minov, Chris Bouloumpasis, Inès Rigaud, Stefan Cornea, Mihaela Peneva',
        tags: [
          'GoogleIO',
          'GDGLondon',
          'AI',
          'GenAI',
          'LLMs',
          'MLOps',
          'Speakers',
          'Sessions',
          'Event'
        ],
        platforms: [
          SocialPlatform.linkedin,
          SocialPlatform.twitter,
          SocialPlatform.facebook,
          SocialPlatform.instagram
        ],
        additionalLinks: [
          'https://ioextended2025.gdg.london/schedule',
          'https://ioextended2025.gdg.london/speakers'
        ],
        campaign: 'Google I/O Extended London 2025',
      ),
    ]);
    _nextId = 15;
  }

  @override
  Future<List<Post>> getAllPosts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_posts);
  }

  @override
  Future<Post?> getPostById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Post>> getPostsByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _posts.where((post) {
      return post.date.year == date.year &&
          post.date.month == date.month &&
          post.date.day == date.day;
    }).toList();
  }

  @override
  Future<List<Post>> getUpcomingPosts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    return _posts
        .where((post) => post.date.isAfter(now) && !post.isPosted)
        .toList();
  }

  @override
  Future<List<Post>> getPostedPosts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _posts.where((post) => post.isPosted).toList();
  }

  @override
  Future<Post> createPost(Post post) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newPost = post.copyWith(id: _nextId.toString());
    _posts.add(newPost);
    _nextId++;
    return newPost;
  }

  @override
  Future<Post> updatePost(Post post) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _posts.indexWhere((p) => p.id == post.id);
    if (index == -1) {
      throw Exception('Post not found');
    }
    _posts[index] = post;
    return post;
  }

  @override
  Future<bool> deletePost(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final initialLength = _posts.length;
    _posts.removeWhere((post) => post.id == id);
    return _posts.length < initialLength;
  }

  @override
  Future<Post> togglePostStatus(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _posts.indexWhere((post) => post.id == id);
    if (index == -1) {
      throw Exception('Post not found');
    }

    final post = _posts[index];
    final updatedPost = post.copyWith(
      isPosted: !post.isPosted,
      postedAt: !post.isPosted ? DateTime.now() : null,
    );

    _posts[index] = updatedPost;
    return updatedPost;
  }
}
