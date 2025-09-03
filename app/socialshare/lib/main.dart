import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/json_post_provider.dart';
import 'providers/post_provider.dart';
import 'providers/tag_provider.dart';
import 'providers/campaign_provider.dart';
import 'providers/team_member_provider.dart';
import 'repository/firebase_post_repository.dart';
import 'utils/router.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SocialShareApp());
}

class SocialShareApp extends StatelessWidget {
  const SocialShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JsonPostProvider()),
        ChangeNotifierProvider(
          create: (_) => PostProvider(
            repository: FirebasePostRepository(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => TagProvider()),
        ChangeNotifierProvider(create: (_) => CampaignProvider()),
        ChangeNotifierProvider(create: (_) => TeamMemberProvider()),
      ],
      child: MaterialApp.router(
        title: 'SocialShare - GDG London',
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
