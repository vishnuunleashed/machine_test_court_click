import 'package:flutter/material.dart';
import 'package:machine_test_court_click/utiiity/widgets/app_bottom_nav_bar.dart';

const _loremIpsum =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit quam dui, vivamus '
    'bibendum mi tortor ut felis non accumsan accumsan quis. Massa, '
    'id ut aliquam  enim non posuere pulvinar diam.';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Smart Downloads', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              Text('Introducing Downloads For You', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(_loremIpsum, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade800),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0072F5)),
                  child: const Text('SETUP', style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF2A2A2A),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Text(
                    'Find Something to Download',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }
}
