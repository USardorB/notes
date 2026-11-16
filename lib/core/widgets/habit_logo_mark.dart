import 'package:flutter/material.dart';
import 'package:notes/app/theme/app_theme.dart';

/// Renders the circular white pinned-note logo from the HaBIT Note Splash screen.
class HabitSplashEmblem extends StatelessWidget {
  final double size;

  const HabitSplashEmblem({super.key, this.size = 152});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
      ),
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.56, size * 0.56),
          painter: _PinnedNotePainter(),
        ),
      ),
    );
  }
}

class _PinnedNotePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final left = w * 0.14;
    final top = h * 0.24;
    final right = w * 0.90;
    final bottom = h * 0.92;
    final foldSize = w * 0.22;
    const radius = 10.0;

    final notePath = Path()
      ..moveTo(left + w * 0.22, top)
      ..lineTo(right - radius, top)
      ..arcToPoint(
        Offset(right, top + radius),
        radius: const Radius.circular(radius),
      )
      ..lineTo(right, bottom - foldSize)
      ..lineTo(right - foldSize, bottom)
      ..lineTo(left + radius, bottom)
      ..arcToPoint(
        Offset(left, bottom - radius),
        radius: const Radius.circular(radius),
      )
      ..lineTo(left, top + radius)
      ..arcToPoint(
        Offset(left + radius, top),
        radius: const Radius.circular(radius),
      );

    canvas.drawPath(notePath, strokePaint);

    final foldPath = Path()
      ..moveTo(right - foldSize, bottom)
      ..lineTo(right - foldSize, bottom - foldSize + 4)
      ..quadraticBezierTo(
        right - foldSize,
        bottom - foldSize,
        right - foldSize + 4,
        bottom - foldSize,
      )
      ..lineTo(right, bottom - foldSize)
      ..close();
    canvas.drawPath(foldPath, fillPaint);

    final lineLeft = left + w * 0.12;
    final lineRightFull = right - w * 0.12;
    final lineRightShort = right - foldSize - w * 0.08;

    final y1 = top + (bottom - top) * 0.36;
    final y2 = top + (bottom - top) * 0.56;
    final y3 = top + (bottom - top) * 0.76;

    canvas.drawLine(Offset(lineLeft, y1), Offset(lineRightFull, y1), strokePaint);
    canvas.drawLine(Offset(lineLeft, y2), Offset(lineRightFull, y2), strokePaint);
    canvas.drawLine(
      Offset(lineLeft, y3),
      Offset(lineRightShort, y3),
      strokePaint,
    );

    final pinCenter = Offset(w * 0.26, h * 0.14);
    final pinRadius = w * 0.11;
    canvas.drawCircle(pinCenter, pinRadius, strokePaint);

    final pinNeedlePath = Path()
      ..moveTo(pinCenter.dx - pinRadius * 0.3, pinCenter.dy + pinRadius * 0.85)
      ..lineTo(w * 0.44, top + h * 0.13)
      ..lineTo(pinCenter.dx + pinRadius * 0.85, pinCenter.dy + pinRadius * 0.3);
    canvas.drawPath(pinNeedlePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Top-left 3-bar orange menu button shown on Onboarding & Menu screens.
class HabitHamburgerButton extends StatelessWidget {
  final VoidCallback onTap;
  final double width;

  const HabitHamburgerButton({
    super.key,
    required this.onTap,
    this.width = 26,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bar(),
              const SizedBox(height: 5),
              _bar(),
              const SizedBox(height: 5),
              _bar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bar() {
    return Container(
      height: 2.2,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
