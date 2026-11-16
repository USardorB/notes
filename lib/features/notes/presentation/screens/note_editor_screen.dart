import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/core/l10n/app_texts.dart';
import 'package:notes/core/widgets/tour_spotlight_overlay.dart';
import 'package:notes/features/notes/domain/note.dart';
import 'package:notes/features/notes/presentation/controllers/notes_controller.dart';
import 'package:notes/features/notes/presentation/controllers/notes_tour_controller.dart';
import 'package:notes/features/notes/presentation/widgets/note_palette.dart';

@RoutePage()
class NoteEditorScreen extends HookConsumerWidget {
  final Note? existingNote;

  const NoteEditorScreen({super.key, this.existingNote});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tourStep = ref.watch(notesTourProvider);
    final isTourStart =
        existingNote == null && tourStep == NotesTourStep.editPrefilledNote;

    final titleController = useTextEditingController(
      text: existingNote?.title ??
          (isTourStart ? 'My First HaBIT Note' : ''),
    );
    final contentController = useTextEditingController(
      text: existingNote?.content ??
          (isTourStart
              ? 'Tap here to edit this note to anything you like!'
              : ''),
    );
    final selectedColor =
        useState<int>(existingNote?.colorValue ?? 0xFFFFFFFF);
    final hasHandledExit = useRef(false);

    final backButtonKey = useMemoized(GlobalKey.new);
    final moreButtonKey = useMemoized(GlobalKey.new);
    final editorFieldsKey = useMemoized(GlobalKey.new);

    Future<void> saveAndPop() async {
      if (hasHandledExit.value) return;
      hasHandledExit.value = true;

      if (ref.read(notesTourProvider) != NotesTourStep.inactive) {
        ref.read(notesTourProvider.notifier).stop();
      }

      final title = titleController.text.trim();
      final content = contentController.text.trim();
      final hasChanges = title != (existingNote?.title ?? '') ||
          content != (existingNote?.content ?? '') ||
          selectedColor.value != (existingNote?.colorValue ?? 0xFFFFFFFF);

      if ((title.isNotEmpty || content.isNotEmpty) && hasChanges) {
        await ref.read(notesControllerProvider.notifier).saveNote(
              existingNote: existingNote,
              title: title,
              content: content,
              colorValue: selectedColor.value,
              type: NoteType.note,
            );
      }

      if (context.mounted) {
        context.router.maybePop();
      }
    }

    Future<void> deleteAndPop() async {
      hasHandledExit.value = true;
      if (ref.read(notesTourProvider) != NotesTourStep.inactive) {
        ref.read(notesTourProvider.notifier).stop();
      }
      if (existingNote != null) {
        await ref
            .read(notesControllerProvider.notifier)
            .deleteNote(existingNote!.id);
      }
      if (context.mounted) {
        context.router.maybePop();
      }
    }

    Future<void> openOptionsSheet() async {
      final isTour = tourStep == NotesTourStep.tapMoreMenu;
      if (isTour) {
        ref
            .read(notesTourProvider.notifier)
            .advanceTo(NotesTourStep.explainOptions);
      }

      await showNoteOptionsSheet(
        context: context,
        currentColor: selectedColor.value,
        onColorSelected: (color) => selectedColor.value = color,
        onDelete: existingNote != null ? deleteAndPop : null,
        showTourGuide: isTour,
        onSkipTour: () => ref.read(notesTourProvider.notifier).stop(),
      );

      if (isTour &&
          context.mounted &&
          ref.read(notesTourProvider) == NotesTourStep.explainOptions) {
        ref
            .read(notesTourProvider.notifier)
            .advanceTo(NotesTourStep.tapBackToSave);
      }
    }

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isDefaultWhite = selectedColor.value == 0xFFFFFFFF;
    final bgColor =
        isDefaultWhite && isDark ? colors.surface : Color(selectedColor.value);
    final fgColor = isDefaultWhite && isDark ? colors.onSurface : Colors.black;
    final hintColor =
        isDefaultWhite && isDark ? colors.onSurfaceVariant : Colors.black38;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          saveAndPop();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                key: backButtonKey,
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: saveAndPop,
              ),
              title: Text(
                existingNote == null ? AppTexts.addNoteTitle : AppTexts.editNote,
                style: TextStyle(
                  color: fgColor,
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                IconButton(
                  key: moreButtonKey,
                  icon: Icon(Icons.more_vert, color: fgColor),
                  onPressed: openOptionsSheet,
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 180),
                child: Column(
                  key: editorFieldsKey,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: titleController,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontSize: 26,
                        height: 1.3,
                        fontWeight: FontWeight.w400,
                        color: fgColor,
                      ),
                      decoration: InputDecoration(
                        hintText: AppTexts.noteTitleHint,
                        hintStyle: TextStyle(color: hintColor),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentController,
                      maxLines: null,
                      minLines: 14,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontSize: 16.5,
                        height: 1.5,
                        color: fgColor.withValues(alpha: 0.87),
                      ),
                      decoration: InputDecoration(
                        hintText: AppTexts.noteBodyHint,
                        hintStyle: TextStyle(color: hintColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Step 3: Spotlight around the prefilled Title & Body fields
          if (tourStep == NotesTourStep.editPrefilledNote)
            TourSpotlightOverlay(
              targetKey: editorFieldsKey,
              stepLabel: AppTexts.tourStepLabel(3, 6),
              title: AppTexts.tourStep3Title,
              description: AppTexts.tourStep3Desc,
              primaryActionLabel: AppTexts.next,
              onPrimaryAction: () => ref
                  .read(notesTourProvider.notifier)
                  .advanceTo(NotesTourStep.tapMoreMenu),
              onSkip: () => ref.read(notesTourProvider.notifier).stop(),
            ),

          // Step 4: Spotlight on ⋮ button
          if (tourStep == NotesTourStep.tapMoreMenu)
            TourSpotlightOverlay(
              targetKey: moreButtonKey,
              stepLabel: AppTexts.tourStepLabel(4, 6),
              title: AppTexts.tourStep4Title,
              description: AppTexts.tourStep4Desc,
              onSkip: () => ref.read(notesTourProvider.notifier).stop(),
            ),

          // Step 6: Spotlight on Back arrow + hardware back explanation
          if (tourStep == NotesTourStep.tapBackToSave)
            TourSpotlightOverlay(
              targetKey: backButtonKey,
              stepLabel: AppTexts.tourStepLabel(6, 6),
              title: AppTexts.tourStep6Title,
              description: AppTexts.tourStep6Desc,
              onSkip: () => ref.read(notesTourProvider.notifier).stop(),
            ),
        ],
      ),
    );
  }
}
