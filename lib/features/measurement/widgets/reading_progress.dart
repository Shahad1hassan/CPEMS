import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Small progress strip that leaves most of the screen for the illustration.
class ReadingProgress extends StatelessWidget {
  final int completedReadings;
  const ReadingProgress({super.key, required this.completedReadings});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Readings', style: AppTextStyles.label),
        const Spacer(),
        ...List.generate(3, (index) {
          final done = index < completedReadings;
          return Padding(
            padding: const EdgeInsets.only(left: 7),
            child: Container(
              width: 30, height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? AppColors.primaryLight : AppColors.surface,
                border: Border.all(
                  color: done ? AppColors.primary : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: done
                  ? const Icon(Icons.check_rounded, size: 17, color: AppColors.primary)
                  : Text('${index + 1}', style: AppTextStyles.caption),
            ),
          );
        }),
        const SizedBox(width: 8),
        Text('$completedReadings/3', style: AppTextStyles.caption),
      ],
    );
  }
}
