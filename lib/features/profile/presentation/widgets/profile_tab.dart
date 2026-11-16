import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/app/theme/theme_controller.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/core/l10n/locale_controller.dart';
import 'package:notes/core/widgets/habit_confirm_dialog.dart';
import 'package:notes/features/auth/presentation/controllers/auth_controller.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final authActionState = ref.watch(authControllerProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final appLanguage = ref.watch(appLocaleProvider);
    final isDark = themeMode == ThemeMode.dark;
    final isUnsyncedAccount = user != null && user.syncStatus.needsSync;
    final colors = Theme.of(context).colorScheme;

    ref.listen<AsyncValue<void>>(authControllerProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: colors.error,
          ),
        );
      }
    });

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTexts.navMe,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showEditNameDialog(
                        context,
                        ref,
                        currentName: user?.displayName ?? '',
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: colors.surfaceContainerHigh,
                            child: Icon(
                              Icons.person,
                              color: colors.onSurfaceVariant,
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
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? 'John Doe',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? 'yourmail@gmail.com',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          if (isUnsyncedAccount) ...[
                            const SizedBox(height: 8),
                            Container(
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.cloud_off_outlined,
                                    size: 14,
                                    color: colors.onSurface,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      AppTexts.localAccountNotSynced,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: colors.onSurface,
                                      ),
                                    ),
                                  ),
                                ],
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
          Divider(height: 1, thickness: 1, color: colors.outline),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
            child: Row(
              children: [
                Icon(Icons.dark_mode, color: colors.onSurface, size: 22),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    AppTexts.darkMode,
                    style: TextStyle(fontSize: 16.5, color: colors.onSurface),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
            child: Row(
              children: [
                Icon(Icons.language, color: colors.onSurface, size: 22),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    AppTexts.languageLabel,
                    style: TextStyle(fontSize: 16.5, color: colors.onSurface),
                  ),
                ),
                DropdownButton<AppLanguage>(
                  value: appLanguage,
                  underline: const SizedBox.shrink(),
                  dropdownColor: colors.surfaceContainerHigh,
                  style: TextStyle(fontSize: 15, color: colors.onSurface),
                  items: AppLanguage.values
                      .map(
                        (lang) => DropdownMenuItem(
                          value: lang,
                          child: Text(lang.label),
                        ),
                      )
                      .toList(),
                  onChanged: (lang) {
                    if (lang != null) {
                      ref.read(appLocaleProvider.notifier).setLanguage(lang);
                    }
                  },
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => context.router.push(const ForgotPasswordRoute()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.lock, color: colors.onSurface, size: 22),
                  const SizedBox(width: 24),
                  Text(
                    AppTexts.resetPassword,
                    style: TextStyle(fontSize: 16.5, color: colors.onSurface),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => context.router.push(const AboutRoute()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.info, color: colors.onSurface, size: 22),
                  const SizedBox(width: 24),
                  Text(
                    AppTexts.about,
                    style: TextStyle(fontSize: 16.5, color: colors.onSurface),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
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
                    : Text(
                        AppTexts.logOutUpper,
                        style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditNameDialog(
    BuildContext context,
    WidgetRef ref, {
    required String currentName,
  }) async {
    final controller = TextEditingController(text: currentName);
    final colors = Theme.of(context).colorScheme;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surfaceContainerLow,
        title: Text(AppTexts.editDisplayName),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: AppTexts.displayName,
            filled: true,
            fillColor: colors.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppTexts.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              await ref
                  .read(authControllerProvider.notifier)
                  .updateDisplayName(controller.text);
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text(AppTexts.save),
          ),
        ],
      ),
    );
    controller.dispose();
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
      title: AppTexts.logOutTitle,
      message: AppTexts.logOutConfirm,
      confirmLabel: AppTexts.logOutTitle,
    );
    if (!confirmed) return;

    await notifier.signOut();
    if (context.mounted) {
      await context.router.replaceAll([const OnboardingRoute()]);
    }
  }
}
