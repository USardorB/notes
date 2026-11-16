import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/features/notes/presentation/controllers/ocr_controller.dart';
import 'package:notes/features/notes/presentation/widgets/habit_dialogs.dart';

class OcrTab extends ConsumerWidget {
  const OcrTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ocrState = ref.watch(ocrControllerProvider);

    Future<void> pickImage() async {
      final source = await showOcrImageSourceSheet(context);
      if (source == null) return;

      final pickerSource = source == OcrImageSource.camera
          ? ImageSource.camera
          : ImageSource.gallery;

      try {
        await ref.read(ocrControllerProvider.notifier).pickImage(pickerSource);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not pick image: $e')),
          );
        }
      }
    }

    Future<void> performScan() async {
      if (ocrState.imagePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload an image first.')),
        );
        return;
      }
      try {
        await ref.read(ocrControllerProvider.notifier).scanImage();
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scanned text copied to clipboard.')),
        );
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 16, 12),
          child: Row(
            children: [
              const Text(
                'Image to Text',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Copy scanned text',
                icon: const Icon(
                  Icons.content_copy_outlined,
                  color: Colors.black,
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: ocrState.imagePath != null
                          ? null
                          : Border.all(color: Colors.black87, width: 1),
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
                        : const Center(
                            child: Text(
                              'Upload an image\nusing the “+”\nbutton',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black87, width: 1),
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
                                  ? 'No text detected in this image.'
                                  : ocrState.scannedText!,
                              style: const TextStyle(
                                fontSize: 17,
                                height: 1.5,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : const Center(
                            child: Text(
                              'Click the “Scan Image”\nbutton to perform scan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
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
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black87, width: 1),
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
                child: const Text(
                  'Clear Image',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
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
                child: const Text(
                  'Scan Image',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ),
              const Spacer(),
              FloatingActionButton(
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
