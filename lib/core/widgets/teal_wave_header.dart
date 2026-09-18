import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Soft topographic waves used on GX Inspecta teal headers.
class TealWaveHeader extends StatelessWidget {
  const TealWaveHeader({
    super.key,
    required this.child,
    this.height,
    this.padding = const EdgeInsets.fromLTRB(20, 12, 20, 20),
  });

  final Widget child;
  final double? height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        gradient: AppColors.tealHeader,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        child: CustomPaint(
          painter: const _WavePainter(),
          child: SafeArea(
            bottom: false,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = Colors.white.withValues(alpha: 0.12);

    for (var i = 0; i < 6; i++) {
      final path = Path();
      final yBase = size.height * (0.18 + i * 0.14);
      path.moveTo(0, yBase);
      for (var x = 0.0; x <= size.width; x += 8) {
        final y =
            yBase +
            math.sin((x / size.width) * math.pi * 2 + i) * (10 + i * 2) +
            math.cos((x / size.width) * math.pi * 3 + i * 0.4) * 4;
        path.lineTo(x, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
