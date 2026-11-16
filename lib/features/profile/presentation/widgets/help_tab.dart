import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/features/notes/presentation/controllers/notes_tour_controller.dart';
import 'package:notes/features/ocr/presentation/controllers/ocr_tour_controller.dart';

class HelpTab extends ConsumerWidget {
  final ValueChanged<int> onSwitchTab;

  const HelpTab({super.key, required this.onSwitchTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(32, 18, 24, 34),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTexts.navHelp,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    AppTexts.userGuide,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(36, 28, 36, 24),
            children: [
              _HelpGuideCard(
                icon: Icons.description,
                title: AppTexts.navNotes,
                onTap: () {
                  ref.read(notesTourProvider.notifier).start();
                  onSwitchTab(0);
                },
              ),
              const SizedBox(height: 22),
              _HelpGuideCard(
                icon: Icons.image_search,
                title: AppTexts.navOcr,
                onTap: () {
                  ref.read(ocrTourProvider.notifier).start();
                  onSwitchTab(1);
                },
              ),
              const SizedBox(height: 22),
              _HelpGuideCard(
                icon: Icons.lock,
                title: AppTexts.resetPassword,
                onTap: () => context.router.push(const ForgotPasswordRoute()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HelpGuideCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _HelpGuideCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 42),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppTexts.tapToView,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w300,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
