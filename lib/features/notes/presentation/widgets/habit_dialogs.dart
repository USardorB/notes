import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/features/notes/presentation/widgets/tour_spotlight_overlay.dart';

enum NewNoteAction { addNote, addTodo }

/// "New" modal bottom sheet ("Add note" / "Add to-do").
Future<NewNoteAction?> showNewNoteTypeSheet(
  BuildContext context, {
  bool highlightAddNote = false,
  VoidCallback? onSkipTour,
}) {
  return showModalBottomSheet<NewNoteAction>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return HookBuilder(
        builder: (hookContext) {
          final addNoteKey = useMemoized(GlobalKey.new);

          useEffect(
            () {
              if (!highlightAddNote) return null;
              final entry = OverlayEntry(
                builder: (_) => TourSpotlightOverlay(
                  targetKey: addNoteKey,
                  stepLabel: 'Step 2 of 6',
                  title: 'Choose Add Note',
                  description:
                      'Tap "Add note" to open the note editor with a sample note.',
                  onSkip: () {
                    onSkipTour?.call();
                    if (sheetContext.mounted) {
                      Navigator.of(sheetContext).pop();
                    }
                  },
                ),
              );
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (hookContext.mounted) {
                  Overlay.of(hookContext).insert(entry);
                }
              });
              return entry.remove;
            },
            [highlightAddNote],
          );

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'New',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ListTile(
                    key: addNoteKey,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.keyboard,
                      color: Colors.black,
                      size: 28,
                    ),
                    title: const Text(
                      'Add note',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () =>
                        Navigator.of(sheetContext).pop(NewNoteAction.addNote),
                  ),
                  const SizedBox(height: 6),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.check_box,
                      color: Colors.black,
                      size: 28,
                    ),
                    title: const Text(
                      'Add to-do',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () =>
                        Navigator.of(sheetContext).pop(NewNoteAction.addTodo),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

enum OcrImageSource { camera, gallery }

/// "New" modal bottom sheet for OCR ("Take photo" / "Choose from gallery").
Future<OcrImageSource?> showOcrImageSourceSheet(BuildContext context) {
  return showModalBottomSheet<OcrImageSource>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'New',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 28,
                ),
                title: const Text(
                  'Take photo',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
                onTap: () =>
                    Navigator.of(sheetContext).pop(OcrImageSource.camera),
              ),
              const SizedBox(height: 6),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.collections,
                  color: Colors.black,
                  size: 28,
                ),
                title: const Text(
                  'Choose from gallery',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
                onTap: () =>
                    Navigator.of(sheetContext).pop(OcrImageSource.gallery),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Styled confirmation dialog for "Log out" and "Exit app".
Future<bool> showHabitConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  String cancelLabel = 'No',
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.white,
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
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black45,
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
                          foregroundColor: Colors.black54,
                          side: const BorderSide(color: Color(0xFFD0D5DD)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        child: Text(
                          cancelLabel,
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
  final details = <String>[
    if (hasUnsyncedAccount) 'your local account',
    if (unsyncedNotesCount > 0)
      '$unsyncedNotesCount unsynced ${unsyncedNotesCount == 1 ? 'note' : 'notes'}',
  ].join(' and ');

  final result = await showDialog<UnsyncedLogoutAction>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.cloud_off_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Unsynced Data',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'You still have $details stored only on this device. Sync with the internet before logging out to avoid losing your data.',
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.black54,
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
                          foregroundColor: Colors.black54,
                          side: const BorderSide(color: Color(0xFFD0D5DD)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.of(dialogContext)
                            .pop(UnsyncedLogoutAction.cancel),
                        child: const Text('No', style: TextStyle(fontSize: 16)),
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
                        child: const Text(
                          'Sync & Log out',
                          style: TextStyle(
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
                  child: const Text('Log out without syncing'),
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
