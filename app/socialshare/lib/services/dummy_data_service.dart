import '../models/post.dart';
import '../models/organization.dart';

class DummyDataService {
  static final Organization gdgLondon = Organization(
    id: '1',
    name: 'GDG London',
    description:
        'Google Developer Group in London. Follow us to find out about London meetups for all things Google',
    linkedinUrl: 'https://www.linkedin.com/company/google-developers-london/',
    twitterUrl: 'https://x.com/gdg_london',
    websiteUrl: 'https://gdg.community.dev/gdg-london/',
    logoUrl: 'https://via.placeholder.com/150x150/4285F4/FFFFFF?text=GDG',
    location: 'London, England',
  );

  static final List<Post> dummyPosts = [
    Post(
      id: '1',
      title: 'Google I/O Extended London 2025',
      content:
          '🚀 The countdown is on! Google I/O Extended London is happening on 13th September at 01Founders - and you won\'t want to miss it. This is your chance to be part of a day packed with inspiring talks, live demos, and real conversations about the future of AI.',
      date: DateTime(2025, 8, 27), // Starting from 27/08/2025
      isPosted: false,
      postedBy: 'GDG London Team',
      imageUrl:
          'https://via.placeholder.com/800x400/4285F4/FFFFFF?text=Google+I/O+Extended',
      tags: ['Google I/O', 'AI', 'London', 'Tech Event'],
      platforms: [SocialPlatform.linkedin, SocialPlatform.twitter],
      additionalLinks: ['https://lnkd.in/efcRfi9T', 'https://01founders.com'],
      campaign: 'IO Extended 2025',
    ),
    Post(
      id: '2',
      title: 'The Android Circuit - New Event Series',
      content:
          'All aboard! Announcing The Android Circuit, a brand new event series for London\'s Android developers! Building on the Android Workshop Wednesdays series, GDG London and Tom Colvin are launching the next chapter of community-driven events.',
      date: DateTime(2025, 8, 28), // Next day
      isPosted: false,
      postedBy: 'GDG London Team',
      imageUrl:
          'https://via.placeholder.com/800x400/3DDC84/FFFFFF?text=Android+Circuit',
      tags: ['Android', 'Workshop', 'London', 'Developer Events'],
      platforms: [
        SocialPlatform.linkedin,
        SocialPlatform.twitter,
        SocialPlatform.facebook
      ],
      additionalLinks: ['https://lnkd.in/e5YtkwWG', 'https://marshmallow.com'],
      campaign: 'Android Circuit Series',
    ),
    Post(
      id: '3',
      title: 'Breaking Barriers: Pathways into Tech',
      content:
          'What\'s the one piece of advice you wish you had when you were first breaking into tech? We\'re excited to share our latest podcast episode, moderated by Stefan C.!',
      date: DateTime(2025, 8, 29), // Next day
      isPosted: true,
      postedBy: 'GDG London Team',
      imageUrl:
          'https://via.placeholder.com/800x400/FF6B6B/FFFFFF?text=Breaking+Barriers',
      tags: ['Tech Careers', 'Diversity', 'Podcast', 'Community'],
      platforms: [SocialPlatform.linkedin, SocialPlatform.twitter],
      additionalLinks: ['https://lnkd.in/ecrGNpWS', 'https://www.youtube.com/'],
      postedAt: DateTime(2025, 8, 29, 10, 0),
      postUrl: 'https://www.linkedin.com/posts/gdg-london-breaking-barriers',
      campaign: 'Breaking Barriers Podcast',
    ),
    Post(
      id: '4',
      title: 'Flutter DevCamp - India Edition',
      content:
          '🚀 We\'re excited to launch Flutter DevCamp - India Edition 🎉 In collaboration with Career Katta, Garja Maarthi, and Sakpal Knowledge Hub, we\'re bringing Flutter learning to 1,500+ students across Indian colleges.',
      date: DateTime(2025, 8, 30), // Next day
      isPosted: true,
      postedBy: 'Renuka Kelkar',
      imageUrl:
          'https://via.placeholder.com/800x400/02569B/FFFFFF?text=Flutter+DevCamp',
      tags: ['Flutter', 'India', 'Education', 'Community'],
      platforms: [SocialPlatform.linkedin, SocialPlatform.twitter],
      additionalLinks: ['https://careerkatta.com', 'https://garjamaarthi.com'],
      postedAt: DateTime(2025, 8, 30, 14, 30),
      postUrl: 'https://www.linkedin.com/posts/gdg-london-flutter-devcamp',
      campaign: 'Flutter DevCamp India',
    ),
    Post(
      id: '5',
      title: 'Google I/O Connect Berlin Highlights',
      content:
          '🌟 Day 2 – All About Community! From insightful sessions to spontaneous ideas, Day 2 at Google I/O Connect Berlin was packed with deep dives into community building and fresh workshop ideas from the team.',
      date: DateTime(2025, 8, 31), // Next day
      isPosted: true,
      postedBy: 'GDG London Team',
      imageUrl:
          'https://via.placeholder.com/800x400/4285F4/FFFFFF?text=Google+I/O+Connect',
      tags: ['Google I/O', 'Berlin', 'Community', 'Workshops'],
      platforms: [
        SocialPlatform.linkedin,
        SocialPlatform.twitter,
        SocialPlatform.instagram
      ],
      additionalLinks: [
        'https://io.google/connect/',
        'https://www.linkedin.com/posts/gdg-london-google-io-connect'
      ],
      postedAt: DateTime(2025, 8, 31, 16, 0),
      postUrl: 'https://www.linkedin.com/posts/gdg-london-google-io-connect',
      campaign: 'IO Connect Berlin 2025',
    ),
    Post(
      id: '6',
      title: 'Women Techmakers London Meetup',
      content:
          'Join us for an inspiring evening with Women Techmakers London! We\'ll be discussing career growth, technical skills, and building inclusive tech communities. All genders welcome!',
      date: DateTime(2025, 9, 1), // Next day
      isPosted: false,
      postedBy: 'Women Techmakers London',
      imageUrl:
          'https://via.placeholder.com/800x400/E91E63/FFFFFF?text=Women+Techmakers',
      tags: ['Women in Tech', 'Career Growth', 'Networking', 'London'],
      platforms: [
        SocialPlatform.linkedin,
        SocialPlatform.twitter,
        SocialPlatform.instagram
      ],
      additionalLinks: [
        'https://women.techmakers.com',
        'https://meetup.com/wtm-london'
      ],
      campaign: 'Women Techmakers London',
    ),
    Post(
      id: '7',
      title: 'Cloud Next London 2025',
      content:
          '☁️ Get ready for Cloud Next London! Experience the latest in cloud technology, AI, and machine learning. Early bird tickets available now with exclusive GDG London discount.',
      date: DateTime(2025, 9, 2), // Next day
      isPosted: false,
      postedBy: 'GDG London Team',
      imageUrl:
          'https://via.placeholder.com/800x400/00BCD4/FFFFFF?text=Cloud+Next',
      tags: ['Cloud', 'AI/ML', 'Google Cloud', 'Conference'],
      platforms: [
        SocialPlatform.linkedin,
        SocialPlatform.twitter,
        SocialPlatform.facebook
      ],
      additionalLinks: [
        'https://cloudnext.withgoogle.com',
        'https://gdg.community.dev/events'
      ],
      campaign: 'Cloud Next London 2025',
    ),
    Post(
      id: '8',
      title: 'Flutter London Monthly Meetup',
      content:
          '📱 Flutter developers unite! Our monthly meetup is back with talks on Flutter 3.0, state management, and building beautiful UIs. Pizza and networking included!',
      date: DateTime(2025, 9, 3), // Next day
      isPosted: false,
      postedBy: 'Flutter London',
      imageUrl:
          'https://via.placeholder.com/800x400/02569B/FFFFFF?text=Flutter+London',
      tags: ['Flutter', 'Mobile Development', 'UI/UX', 'Networking'],
      platforms: [
        SocialPlatform.linkedin,
        SocialPlatform.twitter,
        SocialPlatform.meetup
      ],
      additionalLinks: [
        'https://meetup.com/flutter-london',
        'https://flutter.dev'
      ],
      campaign: 'Flutter London Monthly',
    ),
    Post(
      id: '9',
      title: 'DevFest London 2025',
      content:
          '🎉 DevFest London is back and bigger than ever! Join us for a full day of technical sessions, workshops, and networking. Early bird registration opens next week!',
      date: DateTime(2025, 9, 4), // Next day
      isPosted: false,
      postedBy: 'GDG London Team',
      imageUrl:
          'https://via.placeholder.com/800x400/FF9800/FFFFFF?text=DevFest+London',
      tags: ['DevFest', 'Conference', 'Workshops', 'Networking'],
      platforms: [
        SocialPlatform.linkedin,
        SocialPlatform.twitter,
        SocialPlatform.facebook,
        SocialPlatform.instagram
      ],
      additionalLinks: [
        'https://devfest.gdglondon.org',
        'https://devfest.withgoogle.com'
      ],
      campaign: 'DevFest London 2025',
    ),
    Post(
      id: '10',
      title: 'AI & Machine Learning Workshop',
      content:
          '🤖 Dive deep into AI and ML with hands-on workshops covering TensorFlow, Google Cloud AI, and practical applications. Perfect for developers at all levels.',
      date: DateTime(2025, 9, 5), // Next day
      isPosted: false,
      postedBy: 'AI London Community',
      imageUrl:
          'https://via.placeholder.com/800x400/9C27B0/FFFFFF?text=AI+Workshop',
      tags: ['AI/ML', 'TensorFlow', 'Workshop', 'Hands-on'],
      platforms: [SocialPlatform.linkedin, SocialPlatform.twitter],
      additionalLinks: ['https://ai.google', 'https://cloud.google.com/ai'],
      campaign: 'AI/ML Workshop Series',
    ),
  ];

  static List<Post> getPostsByDate(DateTime date) {
    return dummyPosts
        .where((post) =>
            post.date.year == date.year &&
            post.date.month == date.month &&
            post.date.day == date.day)
        .toList();
  }

  static List<Post> getUpcomingPosts() {
    final now = DateTime.now();
    return dummyPosts.where((post) => post.date.isAfter(now)).toList();
  }

  static List<Post> getPostedPosts() {
    return dummyPosts.where((post) => post.isPosted).toList();
  }

  static List<Post> getRecentPosts() {
    return dummyPosts.take(6).toList();
  }

  static List<Post> getPostsByPlatform(SocialPlatform platform) {
    return dummyPosts
        .where((post) => post.platforms.contains(platform))
        .toList();
  }

  static List<Post> getPostsByTag(String tag) {
    return dummyPosts.where((post) => post.tags.contains(tag)).toList();
  }

  static List<Post> getPostsByCampaign(String campaign) {
    return dummyPosts.where((post) => post.campaign == campaign).toList();
  }

  static List<String> getAvailableCampaigns() {
    return dummyPosts
        .where((post) => post.campaign != null)
        .map((post) => post.campaign!)
        .toSet()
        .toList();
  }
}
