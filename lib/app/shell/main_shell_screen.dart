import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/app/shell/habit_bottom_nav_bar.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/core/l10n/locale_controller.dart';
import 'package:notes/core/widgets/habit_confirm_dialog.dart';
import 'package:notes/core/widgets/tour_spotlight_overlay.dart';
import 'package:notes/features/notes/presentation/controllers/notes_tour_controller.dart';
import 'package:notes/features/notes/presentation/widgets/habit_dialogs.dart';
import 'package:notes/features/notes/presentation/widgets/notes_home_tab.dart';
import 'package:notes/features/ocr/presentation/controllers/ocr_tour_controller.dart';
import 'package:notes/features/ocr/presentation/widgets/ocr_tab.dart';
import 'package:notes/features/profile/presentation/widgets/help_tab.dart';
import 'package:notes/features/profile/presentation/widgets/profile_tab.dart';

/// Top-level 4-tab Application Shell hosting Notes, OCR, Help, and Profile.
@RoutePage()
class MainShellScreen extends HookConsumerWidget {
  final String? tab;

  const MainShellScreen({
    super.key,
    @QueryParam('tab') this.tab,
  });

  static int _tabIndexFromQuery(String? tab) {
    return switch (tab?.toLowerCase()) {
      'ocr' => 1,
      'help' => 2,
      'me' => 3,
      _ => 0,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appLocaleProvider);

    final selectedTab = useState(_tabIndexFromQuery(tab));

    useEffect(
      () {
        if (tab != null) {
          selectedTab.value = _tabIndexFromQuery(tab);
        }
        return null;
      },
      [tab],
    );

    final tourStep = ref.watch(notesTourProvider);
    final ocrTourStep = ref.watch(ocrTourProvider);
    final addFabKey = useMemoized(GlobalKey.new);
    final ocrFabKey = useMemoized(GlobalKey.new);
    final ocrScanKey = useMemoized(GlobalKey.new);
    final ocrCopyKey = useMemoized(GlobalKey.new);
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (tourStep != NotesTourStep.inactive) {
          ref.read(notesTourProvider.notifier).stop();
          return;
        }
        if (ocrTourStep != OcrTourStep.inactive) {
          ref.read(ocrTourProvider.notifier).stop();
          return;
        }
        final shouldExit = await showHabitConfirmDialog(
          context: context,
          title: AppTexts.exitAppTitle,
          message: AppTexts.exitAppConfirm,
          confirmLabel: AppTexts.exitButton,
        );
        if (shouldExit) {
          await SystemNavigator.pop();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: colors.surface,
            body: IndexedStack(
              index: selectedTab.value,
              children: [
                const SafeArea(bottom: false, child: NotesHomeTab()),
                SafeArea(
                  bottom: false,
                  child: OcrTab(
                    addFabKey: ocrFabKey,
                    scanButtonKey: ocrScanKey,
                    copyButtonKey: ocrCopyKey,
                  ),
                ),
                HelpTab(onSwitchTab: (index) => selectedTab.value = index),
                const SafeArea(bottom: false, child: ProfileTab()),
              ],
            ),
            floatingActionButton: selectedTab.value == 0
                ? FloatingActionButton(
                    key: addFabKey,
                    shape: const CircleBorder(),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    onPressed: () async {
                      final isTour = tourStep == NotesTourStep.tapAddFab;
                      if (isTour) {
                        ref
                            .read(notesTourProvider.notifier)
                            .advanceTo(NotesTourStep.selectAddNote);
                      }

                      final action = await showNewNoteTypeSheet(
                        context,
                        highlightAddNote: isTour,
                        onSkipTour: () =>
                            ref.read(notesTourProvider.notifier).stop(),
                      );

                      if (!context.mounted) return;
                      if (action == null) {
                        if (isTour) {
                          ref.read(notesTourProvider.notifier).stop();
                        }
                        return;
                      }

                      switch (action) {
                        case NewNoteAction.addNote:
                          if (isTour) {
                            ref
                                .read(notesTourProvider.notifier)
                                .advanceTo(NotesTourStep.editPrefilledNote);
                          }
                          await context.router.push(NoteEditorRoute());
                        case NewNoteAction.addTodo:
                          if (isTour) {
                            ref.read(notesTourProvider.notifier).stop();
                          }
                          await context.router.push(TodoEditorRoute());
                      }
                    },
                    child: const Icon(Icons.add, size: 32),
                  )
                : null,
            bottomNavigationBar: HabitBottomNavBar(
              currentIndex: selectedTab.value,
              onTap: (index) => selectedTab.value = index,
            ),
          ),
          if (selectedTab.value == 0 && tourStep == NotesTourStep.tapAddFab)
            TourSpotlightOverlay(
              targetKey: addFabKey,
              stepLabel: AppTexts.tourStepLabel(1, 6),
              title: AppTexts.tourStep1Title,
              description: AppTexts.tourStep1Desc,
              onSkip: () => ref.read(notesTourProvider.notifier).stop(),
            ),
          if (selectedTab.value == 1 &&
              ocrTourStep == OcrTourStep.tapAddImageFab)
            TourSpotlightOverlay(
              targetKey: ocrFabKey,
              stepLabel: AppTexts.tourStepLabel(1, 4),
              title: AppTexts.ocrTourStep1Title,
              description: AppTexts.ocrTourStep1Desc,
              onSkip: () => ref.read(ocrTourProvider.notifier).stop(),
            ),
          if (selectedTab.value == 1 &&
              ocrTourStep == OcrTourStep.tapScanButton)
            TourSpotlightOverlay(
              targetKey: ocrScanKey,
              stepLabel: AppTexts.tourStepLabel(3, 4),
              title: AppTexts.ocrTourStep3Title,
              description: AppTexts.ocrTourStep3Desc,
              onSkip: () => ref.read(ocrTourProvider.notifier).stop(),
            ),
          if (selectedTab.value == 1 &&
              ocrTourStep == OcrTourStep.tapCopyOrClear)
            TourSpotlightOverlay(
              targetKey: ocrCopyKey,
              stepLabel: AppTexts.tourStepLabel(4, 4),
              title: AppTexts.ocrTourStep4Title,
              description: AppTexts.ocrTourStep4Desc,
              primaryActionLabel: AppTexts.done,
              onPrimaryAction: () =>
                  ref.read(ocrTourProvider.notifier).stop(),
              onSkip: () => ref.read(ocrTourProvider.notifier).stop(),
            ),
        ],
      ),
    );
  }
}
