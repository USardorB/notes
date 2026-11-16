import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/core/widgets/tour_spotlight_overlay.dart';

enum OcrImageSource { camera, gallery }

/// "New" modal bottom sheet for OCR ("Take photo" / "Choose from gallery").
Future<OcrImageSource?> showOcrImageSourceSheet(
  BuildContext context, {
  bool highlightSource = false,
  VoidCallback? onSkipTour,
}) {
  final colors = Theme.of(context).colorScheme;

  return showModalBottomSheet<OcrImageSource>(
    context: context,
    backgroundColor: colors.surfaceContainerLow,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return HookBuilder(
        builder: (hookContext) {
          final sourceOptionsKey = useMemoized(GlobalKey.new);

          useEffect(
            () {
              if (!highlightSource) return null;
              final entry = OverlayEntry(
                builder: (_) => TourSpotlightOverlay(
                  targetKey: sourceOptionsKey,
                  stepLabel: AppTexts.tourStepLabel(2, 4),
                  title: AppTexts.ocrTourStep2Title,
                  description: AppTexts.ocrTourStep2Desc,
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
            [highlightSource],
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
                  Column(
                    key: sourceOptionsKey,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.camera_alt,
                          color: colors.onSurface,
                          size: 28,
                        ),
                        title: Text(
                          AppTexts.takePhoto,
                          style: TextStyle(
                            fontSize: 19,
                            color: colors.onSurface,
                          ),
                        ),
                        onTap: () => Navigator.of(sheetContext)
                            .pop(OcrImageSource.camera),
                      ),
                      const SizedBox(height: 6),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.collections,
                          color: colors.onSurface,
                          size: 28,
                        ),
                        title: Text(
                          AppTexts.chooseFromGallery,
                          style: TextStyle(
                            fontSize: 19,
                            color: colors.onSurface,
                          ),
                        ),
                        onTap: () => Navigator.of(sheetContext)
                            .pop(OcrImageSource.gallery),
                      ),
                    ],
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
