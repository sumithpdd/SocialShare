import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/theme.dart';

class CustomNavigationRail extends StatefulWidget {
  const CustomNavigationRail({super.key});

  @override
  State<CustomNavigationRail> createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
        _navigateToRoute(index);
      },
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          selectedIcon: Icon(Icons.home, color: AppTheme.primaryBlue),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.calendar_today),
          selectedIcon: Icon(Icons.calendar_today, color: AppTheme.primaryBlue),
          label: Text('Calendar'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.add),
          selectedIcon: Icon(Icons.add, color: AppTheme.primaryBlue),
          label: Text('Create'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.label),
          selectedIcon: Icon(Icons.label, color: AppTheme.primaryBlue),
          label: Text('Tags'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.campaign),
          selectedIcon: Icon(Icons.campaign, color: AppTheme.primaryBlue),
          label: Text('Campaigns'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.people),
          selectedIcon: Icon(Icons.people, color: AppTheme.primaryBlue),
          label: Text('Team'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          selectedIcon: Icon(Icons.settings, color: AppTheme.primaryBlue),
          label: Text('Settings'),
        ),
      ],
      selectedLabelTextStyle: const TextStyle(
        color: AppTheme.primaryBlue,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: const TextStyle(
        color: Colors.grey,
      ),
      backgroundColor: Colors.white,
      selectedIconTheme: const IconThemeData(color: AppTheme.primaryBlue),
      unselectedIconTheme: const IconThemeData(color: Colors.grey),
      useIndicator: true,
      indicatorColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
    );
  }

  void _navigateToRoute(int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/calendar');
        break;
      case 2:
        context.go('/create');
        break;
      case 3:
        context.go('/tags');
        break;
      case 4:
        context.go('/campaigns');
        break;
      case 5:
        context.go('/team');
        break;
      case 6:
        // Settings route - can be implemented later
        break;
    }
  }
}
