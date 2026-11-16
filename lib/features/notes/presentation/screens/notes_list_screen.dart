import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/features/notes/presentation/controllers/notes_tour_controller.dart';
import 'package:notes/features/notes/presentation/widgets/habit_bottom_nav_bar.dart';
import 'package:notes/features/notes/presentation/widgets/habit_dialogs.dart';
import 'package:notes/features/notes/presentation/widgets/help_tab.dart';
import 'package:notes/features/notes/presentation/widgets/notes_home_tab.dart';
import 'package:notes/features/notes/presentation/widgets/ocr_tab.dart';
import 'package:notes/features/notes/presentation/widgets/profile_tab.dart';
import 'package:notes/features/notes/presentation/widgets/tour_spotlight_overlay.dart';

@RoutePage()
class NotesListScreen extends HookConsumerWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = useState(0);
    final tourStep = ref.watch(notesTourProvider);
    final addFabKey = useMemoized(GlobalKey.new);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (tourStep != NotesTourStep.inactive) {
          ref.read(notesTourProvider.notifier).stop();
          return;
        }
        final shouldExit = await showHabitConfirmDialog(
          context: context,
          title: 'Exit app',
          message: 'Are you sure you want to exit the app?',
          confirmLabel: 'Exit',
        );
        if (shouldExit) {
          await SystemNavigator.pop();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: IndexedStack(
              index: selectedTab.value,
              children: [
                const SafeArea(bottom: false, child: NotesHomeTab()),
                const SafeArea(bottom: false, child: OcrTab()),
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
              stepLabel: 'Step 1 of 6',
              title: 'Create Your First Note',
              description:
                  'Tap the + button to choose between creating a Note or a To-do list.',
              onSkip: () => ref.read(notesTourProvider.notifier).stop(),
            ),
        ],
      ),
    );
  }
}
