import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// A stationary device with a circular, animated processing indicator.
class ProcessingDeviceIndicator extends StatelessWidget {
  const ProcessingDeviceIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, bounds) {
      final diameter = bounds.biggest.shortestSide.clamp(86.0, 190.0).toDouble();
      return Center(
        child: SizedBox(
          width: diameter,
          height: diameter,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  strokeWidth: diameter < 120 ? 6 : 9,
                  color: AppColors.primary,
                  backgroundColor: AppColors.primaryLight,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(diameter * .14),
                child: Image.asset(
                  'assets/images/measurement/device_only.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.air_rounded,
                    size: 62,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
