import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/core/error/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ocr_service.g.dart';

/// Encapsulates on-device offline OCR (`google_mlkit_text_recognition`)
/// and camera/gallery image selection (`image_picker`).
class OcrService {
  final ImagePicker _picker;
  final TextRecognizer _recognizer;

  OcrService({
    ImagePicker? picker,
    TextRecognizer? recognizer,
  }) : _picker = picker ?? ImagePicker(),
       _recognizer =
           recognizer ?? TextRecognizer(script: TextRecognitionScript.latin);

  Future<String?> pickImagePath(ImageSource source) async {
    final file = await _picker.pickImage(source: source);
    return file?.path;
  }

  Future<String> recognizeText(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognized = await _recognizer.processImage(inputImage);
      return recognized.text.trim();
    } catch (e) {
      throw DatabaseException('Failed to scan text from image: $e');
    }
  }

  Future<void> dispose() => _recognizer.close();
}

@riverpod
OcrService ocrService(Ref ref) {
  final service = OcrService();
  ref.onDispose(service.dispose);
  return service;
}
