import 'package:flutter/material.dart';
import 'package:notes/app/theme/app_theme.dart';

/// The 12 note card colors shown in "Filter by colour" and "Select Colour".
const List<int> notePaletteColors = [
  0xFFFFFFFF, // White (outlined)
  0xFFFF9E9E, // Coral / Salmon
  0xFFFFB347, // Amber / Primary
  0xFFFFF599, // Light Yellow
  0xFF91F48F, // Light Green
  0xFF9EFFFF, // Cyan
  0xFFFF9EFA, // Pink / Magenta
  0xFFB69CFF, // Lavender
  0xFF6247EA, // Indigo
  0xFFFADAE6, // Soft Pink
  0xFFF0F0F0, // Off-white
  0xFFBDBDBD, // Medium Gray
];

/// Colors arranged for the 3-column "Filter by colour" sheet (Image 4).
const List<int> filterGridColors = [
  0xFFFFFFFF, 0xFFFF9E9E, 0xFFFFB347,
  0xFFFFF599, 0xFF91F48F, 0xFF9EFFFF,
  0xFFFF9EFA, 0xFFB69CFF, 0xFF6247EA,
  0xFFFADAE6, 0xFFF0F0F0, 0xFFBDBDBD,
];

/// Colors arranged for the 5-column "Select Colour" sheet (Image 6).
const List<int> selectColourCircleColors = [
  0xFFFFFFFF, 0xFFFF9E9E, 0xFFFFB347, 0xFFFFF599, 0xFF9EFFFF,
  0xFF91F48F, 0xFFFF9EFA, 0xFFB69CFF, 0xFF6247EA, 0xFFBDBDBD,
  0xFFFADAE6, 0xFFF0F0F0,
];

String formatRelativeTime(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inSeconds < 60) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays == 1) return '1 day ago';
  return '${diff.inDays} days ago';
}

/// Image 4: "Filter by colour" modal bottom sheet.
Future<void> showFilterByColourSheet({
  required BuildContext context,
  required int? selectedColor,
  required ValueChanged<int?> onSelectColor,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by colour',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),
              InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  onSelectColor(null);
                  Navigator.of(sheetContext).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.black87,
                      width: selectedColor == null ? 1.8 : 1.0,
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filterGridColors.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 2.35,
                ),
                itemBuilder: (context, index) {
                  final colorVal = filterGridColors[index];
                  final isSelected = selectedColor == colorVal;
                  final isWhite = colorVal == 0xFFFFFFFF;
                  return InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      onSelectColor(colorVal);
                      Navigator.of(sheetContext).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(colorVal),
                        borderRadius: BorderRadius.circular(24),
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 2.4)
                            : isWhite
                                ? Border.all(color: Colors.black87, width: 1)
                                : null,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

enum NewNoteAction { addNote, addTodo }

/// Image 5: "New" modal bottom sheet ("Add note" / "Add to-do").
Future<NewNoteAction?> showNewNoteTypeSheet(BuildContext context) {
  return showModalBottomSheet<NewNoteAction>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'New',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.keyboard,
                  color: Colors.black,
                  size: 28,
                ),
                title: const Text(
                  'Add note',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
                onTap: () =>
                    Navigator.of(sheetContext).pop(NewNoteAction.addNote),
              ),
              const SizedBox(height: 6),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.check_box,
                  color: Colors.black,
                  size: 28,
                ),
                title: const Text(
                  'Add to-do',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
                onTap: () =>
                    Navigator.of(sheetContext).pop(NewNoteAction.addTodo),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Image 6: "Delete note" + "Select Colour" bottom sheet for Note/Todo editors.
Future<void> showNoteOptionsSheet({
  required BuildContext context,
  required int currentColor,
  required ValueChanged<int> onColorSelected,
  required VoidCallback? onDelete,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onDelete != null) ...[
              InkWell(
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onDelete();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: Colors.black,
                        size: 28,
                      ),
                      SizedBox(width: 22),
                      Text(
                        'Delete note',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.black54),
            ],
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Colour',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 22),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectColourCircleColors.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      final colorVal = selectColourCircleColors[index];
                      final isSelected = currentColor == colorVal;
                      final isWhite = colorVal == 0xFFFFFFFF;
                      return GestureDetector(
                        onTap: () {
                          onColorSelected(colorVal);
                          Navigator.of(sheetContext).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(colorVal),
                            border: isSelected
                                ? Border.all(color: Colors.black, width: 2.5)
                                : isWhite
                                    ? Border.all(
                                        color: Colors.black87,
                                        width: 1.2,
                                      )
                                    : null,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 20,
                                  color: Colors.black,
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

enum OcrImageSource { camera, gallery }

/// Image 2 (OCR): "New" modal bottom sheet ("Take photo" / "Choose from gallery").
Future<OcrImageSource?> showOcrImageSourceSheet(BuildContext context) {
  return showModalBottomSheet<OcrImageSource>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'New',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 28,
                ),
                title: const Text(
                  'Take photo',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
                onTap: () =>
                    Navigator.of(sheetContext).pop(OcrImageSource.camera),
              ),
              const SizedBox(height: 6),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.collections,
                  color: Colors.black,
                  size: 28,
                ),
                title: const Text(
                  'Choose from gallery',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
                onTap: () =>
                    Navigator.of(sheetContext).pop(OcrImageSource.gallery),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Images 5 & 6: Styled confirmation dialog for "Log out" and "Exit app".
Future<bool> showHabitConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  String cancelLabel = 'No',
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black54,
                          side: const BorderSide(color: Color(0xFFD0D5DD)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        child: Text(
                          cancelLabel,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        child: Text(
                          confirmLabel,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  return confirmed ?? false;
}
