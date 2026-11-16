import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notes/app/theme/app_theme.dart';

/// Displays a dimmed spotlight overlay with a cutout around [targetKey]
/// (if provided) and a floating coach-mark card explaining the current step.
class TourSpotlightOverlay extends HookWidget {
  final GlobalKey? targetKey;
  final String stepLabel;
  final String title;
  final String description;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final VoidCallback onSkip;
  final bool allowTargetTap;

  const TourSpotlightOverlay({
    super.key,
    this.targetKey,
    required this.stepLabel,
    required this.title,
    required this.description,
    this.primaryActionLabel,
    this.onPrimaryAction,
    required this.onSkip,
    this.allowTargetTap = true,
  });

  @override
  Widget build(BuildContext context) {
    final targetRect = useState<Rect?>(null);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final renderBox =
              targetKey?.currentContext?.findRenderObject() as RenderBox?;
          if (renderBox != null && renderBox.hasSize) {
            final offset = renderBox.localToGlobal(Offset.zero);
            targetRect.value = (offset & renderBox.size).inflate(8);
          } else {
            targetRect.value = null;
          }
        });
        return null;
      },
      [targetKey, stepLabel],
    );

    final screenSize = MediaQuery.sizeOf(context);
    final hole = targetRect.value;
    final isTallTarget = hole != null && hole.height > screenSize.height * 0.45;
    final placeCardAbove =
        !isTallTarget && hole != null && hole.center.dy > screenSize.height * 0.5;

    return Stack(
      children: [
        // Dimmed backdrop with optional spotlight cutout.
        // When `allowTargetTap` is true and a hole exists, we split the
        // blocking regions around the hole so taps inside the hole pass
        // directly to the target widget underneath!
        if (hole != null && allowTargetTap)
          ..._buildPassthroughBackdrop(screenSize, hole)
        else
          Positioned.fill(
            child: GestureDetector(
              onTap: () {},
              child: const ColoredBox(color: Colors.black54),
            ),
          ),

        // Visual spotlight cutout painter (non-interactive)
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _SpotlightPainter(hole: hole),
            ),
          ),
        ),

        // Floating Coach-Mark Card
        Positioned(
          left: 20,
          right: 20,
          top: (hole == null || isTallTarget)
              ? null
              : placeCardAbove
                  ? null
                  : hole.bottom + 16,
          bottom: (hole == null || isTallTarget)
              ? 24
              : placeCardAbove
                  ? screenSize.height - hole.top + 16
                  : null,
          child: SafeArea(
            child: TourCoachCard(
              stepLabel: stepLabel,
              title: title,
              description: description,
              primaryActionLabel: primaryActionLabel,
              onPrimaryAction: onPrimaryAction,
              onSkip: onSkip,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPassthroughBackdrop(Size screen, Rect hole) {
    return [
      // Top region
      if (hole.top > 0)
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: hole.top,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
          ),
        ),
      // Bottom region
      if (hole.bottom < screen.height)
        Positioned(
          left: 0,
          right: 0,
          top: hole.bottom,
          bottom: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
          ),
        ),
      // Left region
      if (hole.left > 0)
        Positioned(
          left: 0,
          top: hole.top,
          width: hole.left,
          height: hole.height,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
          ),
        ),
      // Right region
      if (hole.right < screen.width)
        Positioned(
          left: hole.right,
          right: 0,
          top: hole.top,
          height: hole.height,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
          ),
        ),
    ];
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect? hole;

  _SpotlightPainter({required this.hole});

  @override
  void paint(Canvas canvas, Size size) {
    final fullScreen = Path()..addRect(Offset.zero & size);
    final overlayPaint = Paint()..color = const Color(0x99000000);

    final currentHole = hole;
    if (currentHole == null) {
      canvas.drawPath(fullScreen, overlayPaint);
      return;
    }

    final holeRRect = RRect.fromRectAndRadius(
      currentHole,
      const Radius.circular(18),
    );
    final holePath = Path()..addRRect(holeRRect);
    final combined = Path.combine(
      PathOperation.difference,
      fullScreen,
      holePath,
    );

    canvas.drawPath(combined, overlayPaint);

    // Subtle amber highlight ring around the target widget
    final ringPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawRRect(holeRRect, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.hole != hole;
  }
}

class TourCoachCard extends StatelessWidget {
  final String stepLabel;
  final String title;
  final String description;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final VoidCallback onSkip;

  const TourCoachCard({
    super.key,
    required this.stepLabel,
    required this.title,
    required this.description,
    this.primaryActionLabel,
    this.onPrimaryAction,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 10,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    stepLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onSkip,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black54,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Skip Tour'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
            if (primaryActionLabel != null && onPrimaryAction != null) ...[
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: onPrimaryAction,
                  child: Text(primaryActionLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
