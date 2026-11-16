import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/features/auth/presentation/widgets/habit_logo_mark.dart';

@RoutePage()
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Amber Header with Back Arrow, Title, and Circular Logo
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.only(bottom: 36),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => context.router.maybePop(),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const HabitSplashEmblem(size: 136),
                ],
              ),
            ),
          ),

          // App Metadata Rows
          Padding(
            padding: const EdgeInsets.fromLTRB(44, 32, 44, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _AboutKeyValueRow(
                  label: 'Application',
                  value: 'HaBIT Note',
                ),
                const SizedBox(height: 22),
                const _AboutKeyValueRow(
                  label: 'Version',
                  value: 'V1.0.0',
                ),
                const SizedBox(height: 22),
                InkWell(
                  onTap: () => _showInfoSnackBar(context, 'Privacy Policy'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                InkWell(
                  onTap: () => _showInfoSnackBar(context, 'Terms of Use'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Terms of Use',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoSnackBar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title — HaBIT Note V1.0.0')),
    );
  }
}

class _AboutKeyValueRow extends StatelessWidget {
  final String label;
  final String value;

  const _AboutKeyValueRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.w300,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
