import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ocr_tour_controller.g.dart';

enum OcrTourStep {
  inactive,
  tapAddImageFab,
  selectImageSource,
  tapScanButton,
  tapCopyOrClear,
}

@Riverpod(keepAlive: true)
class OcrTour extends _$OcrTour {
  @override
  OcrTourStep build() => OcrTourStep.inactive;

  void start() => state = OcrTourStep.tapAddImageFab;

  void advanceTo(OcrTourStep step) => state = step;

  void stop() => state = OcrTourStep.inactive;
}
