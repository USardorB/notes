import 'package:flutter/material.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/core/l10n/app_texts.dart';

/// Styled confirmation dialog for "Log out" and "Exit app".
Future<bool> showHabitConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,
}) async {
  final colors = Theme.of(context).colorScheme;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.onSurfaceVariant,
                          side: BorderSide(color: colors.outlineVariant),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        child: Text(
                          cancelLabel ?? AppTexts.no,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        child: Text(
                          confirmLabel,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  return confirmed ?? false;
}

enum UnsyncedLogoutAction { cancel, syncAndLogout, discardAndLogout }

/// Pre-logout prompt shown when local account or notes have not been synced.
Future<UnsyncedLogoutAction> showUnsyncedLogoutDialog({
  required BuildContext context,
  required bool hasUnsyncedAccount,
  required int unsyncedNotesCount,
}) async {
  final colors = Theme.of(context).colorScheme;
  final details = <String>[
    if (hasUnsyncedAccount) 'local account',
    if (unsyncedNotesCount > 0) '$unsyncedNotesCount unsynced notes',
  ].join(' & ');

  final result = await showDialog<UnsyncedLogoutAction>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.cloud_off_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppTexts.unsyncedDataTitle,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '$details — sync before logging out to avoid data loss.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.onSurfaceVariant,
                          side: BorderSide(color: colors.outlineVariant),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.of(dialogContext)
                            .pop(UnsyncedLogoutAction.cancel),
                        child: Text(
                          AppTexts.no,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.of(dialogContext)
                            .pop(UnsyncedLogoutAction.syncAndLogout),
                        child: Text(
                          AppTexts.syncAndLogOut,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(dialogContext)
                      .pop(UnsyncedLogoutAction.discardAndLogout),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(AppTexts.logOutWithoutSync),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  return result ?? UnsyncedLogoutAction.cancel;
}
