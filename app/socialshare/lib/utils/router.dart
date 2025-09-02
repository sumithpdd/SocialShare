import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/post_detail_screen.dart';
import '../screens/create_edit_post_screen.dart';
import '../widgets/ai_post_creator.dart';
import '../models/post.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/post/:id',
      builder: (context, state) {
        final postId = state.pathParameters['id']!;
        return PostDetailScreen(postId: postId);
      },
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final editPost = extra?['editPost'] as Post?;
        return CreateEditPostScreen(postToEdit: editPost);
      },
    ),
    GoRoute(
      path: '/ai-create',
      builder: (context, state) => const AIPostCreator(),
    ),
  ],
);
