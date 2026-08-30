import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:machine_test_court_click/utiiity/router/app_routes.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _onTap(context, index),
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(
          icon: _buildBadgedIcon(Icons.video_library_outlined, count: 4),
          label: 'Coming Soon',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.download_outlined), label: 'Downloads'),
        const BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'More'),
      ],
    );
  }

  Widget _buildBadgedIcon(IconData icon, {required int count}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        Positioned(
          right: -6,
          top: -4,
          child: Container(
            padding: const EdgeInsets.all(2),
            constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.homePath);
      case 1:
        context.go(AppRoutes.searchPath);
      case 2:
        context.go(AppRoutes.comingSoonPath);
      case 3:
        context.go(AppRoutes.downloadPath);
      case 4:
        context.go(AppRoutes.morePath);
      default:
        break;
    }
  }
}
