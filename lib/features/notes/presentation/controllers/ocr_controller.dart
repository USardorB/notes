import 'package:dart_mappable/dart_mappable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/features/notes/data/ocr_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ocr_controller.g.dart';
part 'ocr_controller.mapper.dart';

@MappableClass()
class OcrState({
  final String? imagePath,
  final String? scannedText,
  final bool isScanning = false,
}) with OcrStateMappable;

@riverpod
class OcrController extends _$OcrController {
  @override
  OcrState build() => OcrState();

  Future<void> pickImage(ImageSource source) async {
    final path = await ref.read(ocrServiceProvider).pickImagePath(source);
    if (path == null) return;
    state = OcrState(imagePath: path, scannedText: null, isScanning: false);
  }

  Future<String?> scanImage() async {
    final path = state.imagePath;
    if (path == null) return null;

    state = state.copyWith(isScanning: true);
    try {
      final text = await ref.read(ocrServiceProvider).recognizeText(path);
      state = state.copyWith(
        scannedText: text,
        isScanning: false,
      );
      return text;
    } catch (e) {
      state = state.copyWith(isScanning: false);
      rethrow;
    }
  }

  void clear() {
    state = OcrState();
  }
}
