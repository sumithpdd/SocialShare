import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/post_provider.dart';
import 'utils/router.dart';
import 'utils/theme.dart';

void main() {
  runApp(const SocialShareApp());
}

class SocialShareApp extends StatelessWidget {
  const SocialShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostProvider(),
      child: MaterialApp.router(
        title: 'SocialShare - GDG London',
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
