import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/features/ocr/presentation/controllers/ocr_controller.dart';
import 'package:notes/features/ocr/presentation/controllers/ocr_tour_controller.dart';
import 'package:notes/features/ocr/presentation/widgets/ocr_image_source_sheet.dart';

class OcrTab extends ConsumerWidget {
  final GlobalKey? addFabKey;
  final GlobalKey? scanButtonKey;
  final GlobalKey? copyButtonKey;

  const OcrTab({
    super.key,
    this.addFabKey,
    this.scanButtonKey,
    this.copyButtonKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ocrState = ref.watch(ocrControllerProvider);
    final ocrTour = ref.watch(ocrTourProvider);
    final colors = Theme.of(context).colorScheme;

    Future<void> pickImage() async {
      final isTour = ocrTour == OcrTourStep.tapAddImageFab;
      if (isTour) {
        ref
            .read(ocrTourProvider.notifier)
            .advanceTo(OcrTourStep.selectImageSource);
      }

      final source = await showOcrImageSourceSheet(
        context,
        highlightSource: isTour,
        onSkipTour: () => ref.read(ocrTourProvider.notifier).stop(),
      );

      if (source == null) {
        if (isTour) ref.read(ocrTourProvider.notifier).stop();
        return;
      }

      final pickerSource = source == OcrImageSource.camera
          ? ImageSource.camera
          : ImageSource.gallery;

      try {
        await ref.read(ocrControllerProvider.notifier).pickImage(pickerSource);
        final hasImage = ref.read(ocrControllerProvider).imagePath != null;
        if (isTour) {
          if (hasImage) {
            ref
                .read(ocrTourProvider.notifier)
                .advanceTo(OcrTourStep.tapScanButton);
          } else {
            ref.read(ocrTourProvider.notifier).stop();
          }
        }
      } catch (e) {
        if (isTour) ref.read(ocrTourProvider.notifier).stop();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }

    Future<void> performScan() async {
      if (ocrState.imagePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppTexts.uploadImageFirst)),
        );
        return;
      }
      try {
        await ref.read(ocrControllerProvider.notifier).scanImage();
        if (ref.read(ocrTourProvider) == OcrTourStep.tapScanButton) {
          ref
              .read(ocrTourProvider.notifier)
              .advanceTo(OcrTourStep.tapCopyOrClear);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }

    Future<void> copyText() async {
      final text = ocrState.scannedText;
      if (text == null || text.isEmpty) return;
      await Clipboard.setData(ClipboardData(text: text));
      if (ref.read(ocrTourProvider) == OcrTourStep.tapCopyOrClear) {
        ref.read(ocrTourProvider.notifier).stop();
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppTexts.copiedToClipboard)),
        );
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 16, 12),
          child: Row(
            children: [
              Text(
                AppTexts.imageToText,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: colors.onSurface,
                ),
              ),
              const Spacer(),
              IconButton(
                key: copyButtonKey,
                icon: Icon(
                  Icons.content_copy_outlined,
                  color: colors.onSurface,
                  size: 24,
                ),
                onPressed: copyText,
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                      border: ocrState.imagePath != null
                          ? null
                          : Border.all(color: colors.outline, width: 1),
                    ),
                    child: ocrState.imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              File(ocrState.imagePath!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : Center(
                            child: Text(
                              AppTexts.uploadImagePrompt,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: colors.onSurface,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colors.outline, width: 1),
                    ),
                    child: ocrState.isScanning
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : ocrState.scannedText != null
                            ? SingleChildScrollView(
                                child: SelectableText(
                                  ocrState.scannedText!.isEmpty
                                      ? AppTexts.noTextDetected
                                      : ocrState.scannedText!,
                                  style: TextStyle(
                                    fontSize: 17,
                                    height: 1.5,
                                    color: colors.onSurface,
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  AppTexts.clickScanPrompt,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: colors.onSurface,
                                  ),
                                ),
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 16, 18),
          child: Row(
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.onSurface,
                  side: BorderSide(color: colors.outline, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                onPressed: () =>
                    ref.read(ocrControllerProvider.notifier).clear(),
                child: Text(
                  AppTexts.clearImage,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                key: scanButtonKey,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                onPressed: ocrState.isScanning ? null : performScan,
                child: Text(
                  AppTexts.scanImage,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Spacer(),
              FloatingActionButton(
                key: addFabKey,
                heroTag: 'ocr_add_fab',
                shape: const CircleBorder(),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                onPressed: pickImage,
                child: const Icon(Icons.add, size: 32),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
