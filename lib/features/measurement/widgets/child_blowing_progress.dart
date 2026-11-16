import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// The road is the only progress indicator. It expands to its parent height.
class ChildBlowingProgress extends StatelessWidget {
  final double progress;
  const ChildBlowingProgress({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final value = progress.isFinite ? progress.clamp(0.0, 1.0).toDouble() : 0.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        if (height <= 0 || width <= 0) return const SizedBox.shrink();
        final carWidth = (height * 0.72).clamp(34.0, 76.0).toDouble();
        final flagSize = (height * 0.32).clamp(19.0, 34.0).toDouble();
        final finishSpace = flagSize + 5;
        final travel = (width - carWidth - finishSpace).clamp(0.0, double.infinity).toDouble();
        final roadHeight = (height * 0.43).clamp(16.0, 36.0).toDouble();
        final roadBottom = (height - roadHeight) / 2 - 4;
        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: 0, right: 0, bottom: roadBottom,
              child: Container(
                height: roadHeight,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: LayoutBuilder(builder: (context, lineBounds) {
                    final count = (lineBounds.maxWidth / 25).floor().clamp(2, 20);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(count, (_) => Container(
                        width: 9, height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      )),
                    );
                  }),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: roadBottom + roadHeight / 2,
              child: AnimatedScale(
                scale: value >= 1 ? 1.12 : 1,
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  value >= 1 ? Icons.emoji_events_rounded : Icons.flag_rounded,
                  size: flagSize,
                  color: value >= 1 ? AppColors.warning : AppColors.primaryDark,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 170),
              curve: Curves.linear,
              left: travel * value,
              bottom: roadBottom + roadHeight / 3,
              child: Image.asset(
                'assets/images/measurement/child/car.png',
                width: carWidth,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Icon(
                  Icons.directions_car_filled_rounded,
                  size: carWidth,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
