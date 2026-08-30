import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:machine_test_court_click/utiiity/app_theme/app_theme.dart';
import 'package:machine_test_court_click/utiiity/router/app_routes.dart';

class ProfileSelectScreen extends StatelessWidget {
  const ProfileSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  const Spacer(),
                  SvgPicture.asset('assets/icons/logos_netflix.svg', width: 110),
                  const Spacer(),
                  const Icon(Icons.edit_outlined, color: Colors.white),
                ],
              ),
              const Spacer(flex: 3),
              Wrap(
                spacing: 32,
                runSpacing: 32,
                alignment: WrapAlignment.center,
                children: [
                  _buildProfile(context, 'Emenalo', 'assets/icons/Rectangle 2.png'),
                  _buildProfile(context, 'Onyeka', 'assets/icons/Rectangle 3.png'),
                  _buildProfile(context, 'Thelma', 'assets/icons/Rectangle 4.png'),
                  _buildProfile(context, 'Kids', 'assets/icons/Rectangle 5.png'),
                ],
              ),
              const Spacer(flex: 2),
              _buildAddProfile(context),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context, String name, String imageAsset) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.homePath),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imageAsset, width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(name, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildAddProfile(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add Profile not implemented')),
        );
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text('Add Profile', style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
