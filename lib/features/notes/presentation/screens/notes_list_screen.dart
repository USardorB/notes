import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notes/app/router/app_router.dart';
import 'package:notes/app/theme/app_theme.dart';
import 'package:notes/app/theme/theme_controller.dart';
import 'package:notes/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notes/features/notes/domain/note.dart';
import 'package:notes/features/notes/presentation/controllers/notes_controller.dart';
import 'package:notes/features/notes/presentation/widgets/note_palette.dart';

@RoutePage()
class NotesListScreen extends HookConsumerWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = useState(0);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
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
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: selectedTab.value,
          children: [
            const SafeArea(bottom: false, child: _NotesHomeTab()),
            const SafeArea(bottom: false, child: _OcrTab()),
            _HelpTab(onSwitchTab: (index) => selectedTab.value = index),
            const SafeArea(bottom: false, child: _ProfileTab()),
          ],
        ),
        floatingActionButton: selectedTab.value == 0
            ? FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                onPressed: () async {
                  final action = await showNewNoteTypeSheet(context);
                  if (!context.mounted || action == null) return;
                  switch (action) {
                    case NewNoteAction.addNote:
                      await context.router.push(NoteEditorRoute());
                    case NewNoteAction.addTodo:
                      await context.router.push(TodoEditorRoute());
                  }
                },
                child: const Icon(Icons.add, size: 32),
              )
            : null,
        bottomNavigationBar: _HabitBottomNavBar(
          currentIndex: selectedTab.value,
          onTap: (index) => selectedTab.value = index,
        ),
      ),
    );
  }
}

class _NotesHomeTab extends ConsumerWidget {
  const _NotesHomeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(filteredNotesProvider);
    final viewMode = ref.watch(notesViewModeProvider);
    final selectedColor = ref.watch(notesColorFilterProvider);

    return Column(
      children: [
        // Top Header ("Notes" + Palette + View Mode Toggle)
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 16, 12),
          child: Row(
            children: [
              const Text(
                'Notes',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Filter by colour',
                icon: Badge(
                  isLabelVisible: selectedColor != null,
                  backgroundColor: AppColors.primary,
                  child: const Icon(
                    Icons.palette,
                    color: Colors.black,
                    size: 26,
                  ),
                ),
                onPressed: () {
                  showFilterByColourSheet(
                    context: context,
                    selectedColor: selectedColor,
                    onSelectColor: (color) => ref
                        .read(notesColorFilterProvider.notifier)
                        .selectColor(color),
                  );
                },
              ),
              IconButton(
                tooltip: viewMode == NotesViewMode.list
                    ? 'Grid view'
                    : 'List view',
                icon: Icon(
                  viewMode == NotesViewMode.list
                      ? Icons.grid_view_outlined
                      : Icons.drag_handle_rounded,
                  color: Colors.black,
                  size: 26,
                ),
                onPressed: () =>
                    ref.read(notesViewModeProvider.notifier).toggle(),
              ),
            ],
          ),
        ),

        // Content Body
        Expanded(
          child: notesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (notes) {
              if (notes.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/vectors/rafiki.svg',
                          height: 220,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          selectedColor != null
                              ? 'No notes match this colour'
                              : 'Create your first note !',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (viewMode == NotesViewMode.list) {
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
                  itemCount: notes.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) => _NoteCard(
                    note: notes[index],
                    onTap: () => _openEditor(context, notes[index]),
                    onToggleTodo: (todoId) => ref
                        .read(notesControllerProvider.notifier)
                        .toggleTodoItem(note: notes[index], todoId: todoId),
                  ),
                );
              }

              // 2-Column Staggered Masonry Grid (Image 3)
              final leftColumn = <Note>[];
              final rightColumn = <Note>[];
              for (var i = 0; i < notes.length; i++) {
                if (i.isEven) {
                  leftColumn.add(notes[i]);
                } else {
                  rightColumn.add(notes[i]);
                }
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          for (final note in leftColumn) ...[
                            _NoteCard(
                              note: note,
                              onTap: () => _openEditor(context, note),
                              onToggleTodo: (todoId) => ref
                                  .read(notesControllerProvider.notifier)
                                  .toggleTodoItem(note: note, todoId: todoId),
                            ),
                            const SizedBox(height: 14),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        children: [
                          for (final note in rightColumn) ...[
                            _NoteCard(
                              note: note,
                              onTap: () => _openEditor(context, note),
                              onToggleTodo: (todoId) => ref
                                  .read(notesControllerProvider.notifier)
                                  .toggleTodoItem(note: note, todoId: todoId),
                            ),
                            const SizedBox(height: 14),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openEditor(BuildContext context, Note note) {
    if (note.type == NoteType.todo) {
      context.router.push(TodoEditorRoute(existingNote: note));
    } else {
      context.router.push(NoteEditorRoute(existingNote: note));
    }
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final ValueChanged<String> onToggleTodo;

  const _NoteCard({
    required this.note,
    required this.onTap,
    required this.onToggleTodo,
  });

  @override
  Widget build(BuildContext context) {
    final isWhite = note.colorValue == 0xFFFFFFFF;
    final displayTitle =
        note.title.isNotEmpty ? note.title : note.content;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        decoration: BoxDecoration(
          color: Color(note.colorValue),
          borderRadius: BorderRadius.circular(12),
          border: isWhite ? Border.all(color: Colors.black87, width: 1) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.type == NoteType.todo) ...[
              if (note.title.isNotEmpty) ...[
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              for (final item in note.todos.take(4))
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: Checkbox(
                          value: item.isDone,
                          onChanged: (_) => onToggleTodo(item.id),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: Colors.black87,
                          side: const BorderSide(
                            color: Colors.black87,
                            width: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.text,
                          style: TextStyle(
                            fontSize: 15.5,
                            color: Colors.black,
                            decoration: item.isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ] else
              Text(
                displayTitle,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 19,
                  height: 1.3,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                formatRelativeTime(note.updatedAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _HabitBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF1F1F1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.description_outlined,
                label: 'Notes',
                selected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.image_search_outlined,
                label: 'OCR',
                selected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.help_outline,
                label: 'Help',
                selected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Me',
                selected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.black : Colors.black54;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                color: color,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OcrTab extends HookConsumerWidget {
  const _OcrTab();

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
        // Header ("Image to Text" + Copy icon)
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

        // Image Preview Container & Scanned Text Container
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

        // Bottom Action Row ("Clear Image", "Scan Image", "+" FAB)
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

class _HelpTab extends StatelessWidget {
  final ValueChanged<int> onSwitchTab;

  const _HelpTab({required this.onSwitchTab});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Amber Header ("Help" + "User Guide") extending behind status bar
        Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(32, 18, 24, 34),
          child: const SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Help',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 28),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    'User Guide',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // White body with 3 Amber Guide Cards
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(36, 28, 36, 24),
            children: [
              _HelpGuideCard(
                icon: Icons.description,
                title: 'Notes',
                onTap: () => onSwitchTab(0),
              ),
              const SizedBox(height: 22),
              _HelpGuideCard(
                icon: Icons.image_search,
                title: 'OCR',
                onTap: () => onSwitchTab(1),
              ),
              const SizedBox(height: 22),
              _HelpGuideCard(
                icon: Icons.lock,
                title: 'Reset Password',
                onTap: () => context.router.push(const ForgotPasswordRoute()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HelpGuideCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _HelpGuideCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 42),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Tap to view',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w300,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final themeMode = ref.watch(appThemeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Me',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFE5E7EB),
                        child: Icon(
                          Icons.person,
                          color: Colors.black54,
                          size: 40,
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'John Doe',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'yourmail@gmail.com',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Colors.black),
        const SizedBox(height: 12),

        // Dark Mode Toggle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
          child: Row(
            children: [
              const Icon(Icons.dark_mode, color: Colors.black, size: 22),
              const SizedBox(width: 24),
              const Expanded(
                child: Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 16.5, color: Colors.black),
                ),
              ),
              Switch(
                value: isDark,
                activeThumbColor: Colors.white,
                activeTrackColor: AppColors.primary,
                onChanged: (val) =>
                    ref.read(appThemeModeProvider.notifier).toggle(val),
              ),
            ],
          ),
        ),

        // Reset Password
        InkWell(
          onTap: () => context.router.push(const ForgotPasswordRoute()),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.lock, color: Colors.black, size: 22),
                SizedBox(width: 24),
                Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 16.5, color: Colors.black),
                ),
              ],
            ),
          ),
        ),

        // About
        InkWell(
          onTap: () => context.router.push(const AboutRoute()),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.black, size: 22),
                SizedBox(width: 24),
                Text(
                  'About',
                  style: TextStyle(fontSize: 16.5, color: Colors.black),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // LOG OUT Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                final confirmed = await showHabitConfirmDialog(
                  context: context,
                  title: 'Log out',
                  message: 'Are you sure you want to log out?',
                  confirmLabel: 'Log out',
                );
                if (!confirmed) return;

                await ref.read(authControllerProvider.notifier).signOut();
                if (context.mounted) {
                  await context.router.replaceAll([const OnboardingRoute()]);
                }
              },
              icon: const Icon(Icons.logout, size: 26),
              label: const Text(
                'LOG OUT',
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
