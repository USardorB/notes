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
    final authActionState = ref.watch(authControllerProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final isUnsyncedAccount = user != null && user.syncStatus.needsSync;

    ref.listen<AsyncValue<void>>(authControllerProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

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
                        if (isUnsyncedAccount) ...[
                          const SizedBox(height: 8),
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: authActionState.isLoading
                                ? null
                                : () => ref
                                    .read(authControllerProvider.notifier)
                                    .syncAccountNow(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1,
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.cloud_off_outlined,
                                    size: 14,
                                    color: Colors.black87,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Local Account • Not Synced',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
              onPressed: authActionState.isLoading
                  ? null
                  : () => _handleLogout(context, ref),
              icon: const Icon(Icons.logout, size: 26),
              label: authActionState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
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

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(authControllerProvider.notifier);
    final summary = await notifier.checkUnsyncedData();

    if (!context.mounted) return;

    if (summary.hasAnyUnsynced) {
      final action = await showUnsyncedLogoutDialog(
        context: context,
        hasUnsyncedAccount: summary.hasUnsyncedAccount,
        unsyncedNotesCount: summary.unsyncedNotesCount,
      );
      if (!context.mounted) return;

      switch (action) {
        case UnsyncedLogoutAction.cancel:
          return;
        case UnsyncedLogoutAction.syncAndLogout:
          final synced = await notifier.syncAndSignOut();
          if (synced && context.mounted) {
            await context.router.replaceAll([const OnboardingRoute()]);
          }
        case UnsyncedLogoutAction.discardAndLogout:
          await notifier.signOut();
          if (context.mounted) {
            await context.router.replaceAll([const OnboardingRoute()]);
          }
      }
      return;
    }

    final confirmed = await showHabitConfirmDialog(
      context: context,
      title: 'Log out',
      message: 'Are you sure you want to log out?',
      confirmLabel: 'Log out',
    );
    if (!confirmed) return;

    await notifier.signOut();
    if (context.mounted) {
      await context.router.replaceAll([const OnboardingRoute()]);
    }
  }
}
