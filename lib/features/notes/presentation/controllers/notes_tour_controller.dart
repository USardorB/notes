import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_tour_controller.g.dart';

enum NotesTourStep {
  inactive,
  tapAddFab,
  selectAddNote,
  editPrefilledNote,
  tapMoreMenu,
  explainOptions,
  tapBackToSave,
}

@Riverpod(keepAlive: true)
class NotesTour extends _$NotesTour {
  @override
  NotesTourStep build() => NotesTourStep.inactive;

  void start() => state = NotesTourStep.tapAddFab;

  void advanceTo(NotesTourStep step) => state = step;

  void stop() => state = NotesTourStep.inactive;
}
