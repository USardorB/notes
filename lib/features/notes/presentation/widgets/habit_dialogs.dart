import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/core/widgets/tour_spotlight_overlay.dart';

enum NewNoteAction { addNote, addTodo }

/// "New" modal bottom sheet ("Add note" / "Add to-do").
Future<NewNoteAction?> showNewNoteTypeSheet(
  BuildContext context, {
  bool highlightAddNote = false,
  VoidCallback? onSkipTour,
}) {
  final colors = Theme.of(context).colorScheme;

  return showModalBottomSheet<NewNoteAction>(
    context: context,
    backgroundColor: colors.surfaceContainerLow,
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
                  stepLabel: AppTexts.tourStepLabel(2, 6),
                  title: AppTexts.tourStep2Title,
                  description: AppTexts.tourStep2Desc,
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
                  Text(
                    AppTexts.newItem,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ListTile(
                    key: addNoteKey,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.keyboard,
                      color: colors.onSurface,
                      size: 28,
                    ),
                    title: Text(
                      AppTexts.addNote,
                      style: TextStyle(
                        fontSize: 19,
                        color: colors.onSurface,
                      ),
                    ),
                    onTap: () =>
                        Navigator.of(sheetContext).pop(NewNoteAction.addNote),
                  ),
                  const SizedBox(height: 6),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.check_box,
                      color: colors.onSurface,
                      size: 28,
                    ),
                    title: Text(
                      AppTexts.addTodo,
                      style: TextStyle(
                        fontSize: 19,
                        color: colors.onSurface,
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
