import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/core/l10n/app_texts.dart';

enum LegalDocumentType { privacyPolicy, termsOfUse }

@RoutePage()
class LegalDocumentScreen extends StatelessWidget {
  final LegalDocumentType type;

  const LegalDocumentScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final title = type == LegalDocumentType.privacyPolicy
        ? AppTexts.privacyPolicy
        : AppTexts.termsOfUse;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.router.maybePop(),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              '${AppTexts.appName} — $title',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              type == LegalDocumentType.privacyPolicy
                  ? 'HaBIT Note stores your notes, to-dos, and local account metadata on your device using encrypted-at-rest OS storage and local SQLite (Drift). Image-to-Text (OCR) processing runs 100% on-device without uploading your photos to third-party servers.\n\nWhen you choose to sign in or synchronize with the cloud, only your account credentials and note payloads are transmitted over HTTPS.'
                  : 'By using HaBIT Note, you retain full ownership of all notes, to-dos, and extracted OCR text created on your device. Local accounts created offline remain on your device until synced with a cloud account.\n\nPlease ensure you synchronize local notes before logging out to avoid permanent loss of unsynced device data.',
              style: TextStyle(
                fontSize: 15.5,
                height: 1.6,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
