import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/app/theme/theme_controller.dart';
import 'package:notes/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notes/features/notes/presentation/widgets/habit_dialogs.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final themeMode = ref.watch(appThemeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Me',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFE5E7EB),
                        child: Icon(
                          Icons.person,
                          color: Colors.black54,
                          size: 40,
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'John Doe',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'yourmail@gmail.com',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Colors.black),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
          child: Row(
            children: [
              const Icon(Icons.dark_mode, color: Colors.black, size: 22),
              const SizedBox(width: 24),
              const Expanded(
                child: Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 16.5, color: Colors.black),
                ),
              ),
              Switch(
                value: isDark,
                activeThumbColor: Colors.white,
                activeTrackColor: AppColors.primary,
                onChanged: (val) =>
                    ref.read(appThemeModeProvider.notifier).toggle(val),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => context.router.push(const ForgotPasswordRoute()),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.lock, color: Colors.black, size: 22),
                SizedBox(width: 24),
                Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 16.5, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () => context.router.push(const AboutRoute()),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.black, size: 22),
                SizedBox(width: 24),
                Text(
                  'About',
                  style: TextStyle(fontSize: 16.5, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                final confirmed = await showHabitConfirmDialog(
                  context: context,
                  title: 'Log out',
                  message: 'Are you sure you want to log out?',
                  confirmLabel: 'Log out',
                );
                if (!confirmed) return;

                await ref.read(authControllerProvider.notifier).signOut();
                if (context.mounted) {
                  await context.router.replaceAll([const OnboardingRoute()]);
                }
              },
              icon: const Icon(Icons.logout, size: 26),
              label: const Text(
                'LOG OUT',
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
