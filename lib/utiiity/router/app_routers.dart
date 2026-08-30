import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:machine_test_court_click/feature/coming_soon/presentation/screen/coming_soon_screen.dart';
import 'package:machine_test_court_click/feature/download/presentation/screen/download_screen.dart';
import 'package:machine_test_court_click/feature/home/presentation/screen/home_screen.dart';
import 'package:machine_test_court_click/feature/more/presentation/screen/more_screen.dart';
import 'package:machine_test_court_click/feature/profile/presentation/screen/profile_select_screen.dart';
import 'package:machine_test_court_click/feature/search/presentation/screen/search_screen.dart';
import 'package:machine_test_court_click/feature/splash/presentation/screen/splash_screen.dart';
import 'package:machine_test_court_click/utiiity/router/app_routes.dart';

// Simple fade transition shared by every route, instead of the platform's
// default slide-in, for a smoother feel when switching bottom-nav tabs.
CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

final GoRouter appRouter = GoRouter(
    initialLocation: AppRoutes.splashPath,
    routes: [
    GoRoute(
      name: AppRoutes.splash,
      path: AppRoutes.splashPath,
      pageBuilder: (context,state)=> _fadePage(state, const SplashScreen())
    ),
    GoRoute(
      name: AppRoutes.profileSelect,
      path: AppRoutes.profileSelectPath,
      pageBuilder: (context,state)=> _fadePage(state, const ProfileSelectScreen())
    ),
    GoRoute(
      name: AppRoutes.home,
      path: AppRoutes.homePath,
      pageBuilder: (context,state)=> _fadePage(state, HomeScreen())
    ),
    GoRoute(
      name: AppRoutes.search,
      path: AppRoutes.searchPath,
      pageBuilder: (context,state)=> _fadePage(state, const SearchScreen())
    ),
    GoRoute(
      name: AppRoutes.comingSoon,
      path: AppRoutes.comingSoonPath,
      pageBuilder: (context,state)=> _fadePage(state, const ComingSoonScreen())
    ),
    GoRoute(
      name: AppRoutes.download,
      path: AppRoutes.downloadPath,
      pageBuilder: (context,state)=> _fadePage(state, const DownloadScreen())
    ),
    GoRoute(
      name: AppRoutes.more,
      path: AppRoutes.morePath,
      pageBuilder: (context,state)=> _fadePage(state, const MoreScreen())
    )
  ]
);
