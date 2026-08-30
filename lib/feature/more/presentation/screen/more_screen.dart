import 'package:flutter/material.dart';
import 'package:machine_test_court_click/utiiity/widgets/app_bottom_nav_bar.dart';

const _loremIpsum =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit quam dui, vivamus '
    'bibendum mi tortor ut felis non accumsan accumsan quis. Massa,';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProfile('Emenalo', 'assets/icons/Rectangle 2.png'),
                _buildProfile('Onyeka', 'assets/icons/Rectangle 3.png'),
                _buildProfile('Thelma', 'assets/icons/Rectangle 4.png'),
                _buildProfile('Kids', 'assets/icons/Rectangle 5.png'),
                _buildAddProfile(),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined, color: Colors.white70, size: 18),
                label: Text('Manage Profiles', style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade900, height: 32, thickness: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Tell friends about Netflix.', style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_loremIpsum, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  const Text(
                    'Terms & Conditions',
                    style: TextStyle(color: Colors.white70, decoration: TextDecoration.underline),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(0, 44),
                        ),
                        child: const Text('Copy Link', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildSocialIcon(Icons.chat, const Color(0xFF25D366)),
                      const SizedBox(width: 12),
                      _buildSocialIcon(Icons.facebook, const Color(0xFF1877F2)),
                      const SizedBox(width: 12),
                      _buildSocialIcon(Icons.email, Colors.white, iconColor: const Color(0xFFEA4335)),
                      const SizedBox(width: 12),
                      Container(width: 1, height: 40, color: Colors.grey.shade800),
                      const SizedBox(width: 12),
                      _buildSocialIcon(Icons.more_horiz, const Color(0xFF2A2A2A)),
                      const SizedBox(width: 8),
                      Text('More', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade900, height: 1),
            _buildMenuRow(context, Icons.check, 'My List'),
            Divider(color: Colors.grey.shade900, height: 1),
            _buildMenuRow(context, null, 'App Settings'),
            _buildMenuRow(context, null, 'Account'),
            _buildMenuRow(context, null, 'Help'),
            _buildMenuRow(context, null, 'Sign Out'),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildProfile(String name, String imageAsset) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(imageAsset, width: 56, height: 56, fit: BoxFit.cover),
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ],
    );
  }

  Widget _buildAddProfile() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white54),
      ),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color background, {Color iconColor = Colors.white}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget _buildMenuRow(BuildContext context, IconData? icon, String label) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
            ],
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
