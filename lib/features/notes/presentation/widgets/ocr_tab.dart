import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/features/notes/presentation/widgets/habit_dialogs.dart';

class OcrTab extends HookConsumerWidget {
  const OcrTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasImage = useState(false);
    final scannedText = useState<String?>(null);

    Future<void> pickImage() async {
      final source = await showOcrImageSourceSheet(context);
      if (source == null) return;
      hasImage.value = true;
      scannedText.value = null;
    }

    void performScan() {
      if (!hasImage.value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload an image first.')),
        );
        return;
      }
      scannedText.value = 'SMALL STEPS\nARE STILL\nPROGRESS';
    }

    void clearImage() {
      hasImage.value = false;
      scannedText.value = null;
    }

    Future<void> copyText() async {
      final text = scannedText.value;
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
                      color: hasImage.value
                          ? const Color(0xFF3A0F09)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: hasImage.value
                          ? null
                          : Border.all(color: Colors.black87, width: 1),
                    ),
                    child: hasImage.value
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                'SMALL STEPS\nARE STILL\nPROGRESS',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 2,
                                  height: 1.4,
                                  color: Colors.white70,
                                ),
                              ),
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
                    child: scannedText.value != null
                        ? Center(
                            child: SelectableText(
                              scannedText.value!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
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
                onPressed: clearImage,
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
                onPressed: performScan,
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
