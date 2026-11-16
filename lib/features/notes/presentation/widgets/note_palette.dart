import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/core/widgets/tour_spotlight_overlay.dart';

/// Colors arranged for the 3-column "Filter by colour" sheet.
const List<int> filterGridColors = [
  0xFFFFFFFF, 0xFFFF9E9E, 0xFFFFB347,
  0xFFFFF599, 0xFF91F48F, 0xFF9EFFFF,
  0xFFFF9EFA, 0xFFB69CFF, 0xFF6247EA,
  0xFFFADAE6, 0xFFF0F0F0, 0xFFBDBDBD,
];

/// Colors arranged for the 5-column "Select Colour" sheet.
const List<int> selectColourCircleColors = [
  0xFFFFFFFF, 0xFFFF9E9E, 0xFFFFB347, 0xFFFFF599, 0xFF9EFFFF,
  0xFF91F48F, 0xFFFF9EFA, 0xFFB69CFF, 0xFF6247EA, 0xFFBDBDBD,
  0xFFFADAE6, 0xFFF0F0F0,
];

/// "Filter by colour" modal bottom sheet.
Future<void> showFilterByColourSheet({
  required BuildContext context,
  required int? selectedColor,
  required ValueChanged<int?> onSelectColor,
}) {
  final colors = Theme.of(context).colorScheme;

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surfaceContainerLow,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTexts.filterByColour,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 18),
              InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  onSelectColor(null);
                  Navigator.of(sheetContext).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colors.outline,
                      width: selectedColor == null ? 1.8 : 1.0,
                    ),
                  ),
                  child: Text(
                    AppTexts.reset,
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filterGridColors.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 2.35,
                ),
                itemBuilder: (context, index) {
                  final colorVal = filterGridColors[index];
                  final isSelected = selectedColor == colorVal;
                  final isWhite = colorVal == 0xFFFFFFFF;
                  return InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      onSelectColor(colorVal);
                      Navigator.of(sheetContext).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(colorVal),
                        borderRadius: BorderRadius.circular(24),
                        border: isSelected
                            ? Border.all(color: colors.onSurface, width: 2.4)
                            : isWhite
                                ? Border.all(color: colors.outline, width: 1)
                                : null,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// "Delete note" + "Select Colour" bottom sheet for Note/Todo editors.
Future<void> showNoteOptionsSheet({
  required BuildContext context,
  required int currentColor,
  required ValueChanged<int> onColorSelected,
  required VoidCallback? onDelete,
  bool showTourGuide = false,
  VoidCallback? onSkipTour,
}) {
  final colors = Theme.of(context).colorScheme;

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surfaceContainerLow,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return HookBuilder(
        builder: (hookContext) {
          final sheetContentKey = useMemoized(GlobalKey.new);

          useEffect(
            () {
              if (!showTourGuide) return null;
              final entry = OverlayEntry(
                builder: (_) => TourSpotlightOverlay(
                  targetKey: sheetContentKey,
                  stepLabel: AppTexts.tourStepLabel(5, 6),
                  title: AppTexts.tourStep5Title,
                  description: AppTexts.tourStep5Desc,
                  primaryActionLabel: AppTexts.done,
                  onPrimaryAction: () {
                    if (sheetContext.mounted) {
                      Navigator.of(sheetContext).pop();
                    }
                  },
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
            [showTourGuide],
          );

          return SafeArea(
            child: Column(
              key: sheetContentKey,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onDelete != null || showTourGuide) ...[
                  InkWell(
                    onTap: onDelete == null
                        ? null
                        : () {
                            Navigator.of(sheetContext).pop();
                            onDelete();
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: onDelete == null
                                ? colors.onSurfaceVariant
                                : colors.onSurface,
                            size: 28,
                          ),
                          const SizedBox(width: 22),
                          Text(
                            AppTexts.deleteNote,
                            style: TextStyle(
                              fontSize: 19,
                              color: onDelete == null
                                  ? colors.onSurfaceVariant
                                  : colors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: colors.outlineVariant,
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppTexts.selectColour,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 22),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: selectColourCircleColors.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) {
                          final colorVal = selectColourCircleColors[index];
                          final isSelected = currentColor == colorVal;
                          final isWhite = colorVal == 0xFFFFFFFF;
                          return GestureDetector(
                            onTap: () {
                              onColorSelected(colorVal);
                              Navigator.of(sheetContext).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(colorVal),
                                border: isSelected
                                    ? Border.all(
                                        color: colors.onSurface,
                                        width: 2.5,
                                      )
                                    : isWhite
                                        ? Border.all(
                                            color: colors.outline,
                                            width: 1.2,
                                          )
                                        : null,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.black,
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
