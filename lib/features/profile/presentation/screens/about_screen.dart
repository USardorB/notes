import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/core/widgets/habit_logo_mark.dart';
import 'package:notes/features/profile/presentation/screens/legal_document_screen.dart';

@RoutePage()
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                      Text(
                        AppTexts.about,
                        style: const TextStyle(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(44, 32, 44, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AboutKeyValueRow(
                  label: AppTexts.application,
                  value: AppTexts.appName,
                ),
                const SizedBox(height: 22),
                _AboutKeyValueRow(
                  label: AppTexts.version,
                  value: AppTexts.appVersion,
                ),
                const SizedBox(height: 22),
                InkWell(
                  onTap: () => context.router.push(
                    LegalDocumentRoute(type: LegalDocumentType.privacyPolicy),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      AppTexts.privacyPolicy,
                      style: TextStyle(
                        fontSize: 18,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                InkWell(
                  onTap: () => context.router.push(
                    LegalDocumentRoute(type: LegalDocumentType.termsOfUse),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      AppTexts.termsOfUse,
                      style: TextStyle(
                        fontSize: 18,
                        color: colors.onSurface,
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
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: colors.onSurface,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.w300,
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
