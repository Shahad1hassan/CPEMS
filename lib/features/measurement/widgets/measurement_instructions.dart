import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/measurement_guide_mode.dart';
import 'child_blowing_progress.dart';
import 'processing_device_indicator.dart';

enum MeasurementStep { preparing, inhaling, blowing, processing, invalidAttempt }

class MeasurementInstructions extends StatelessWidget {
  final MeasurementStep step;
  final MeasurementGuideMode guideMode;
  final double blowProgress;

  const MeasurementInstructions({
    super.key,
    required this.step,
    required this.guideMode,
    this.blowProgress = 0,
  });

  String get _imagePath {
    final folder = guideMode == MeasurementGuideMode.child ? 'child' : 'adult';
    final file = switch (step) {
      MeasurementStep.preparing => 'preparing',
      MeasurementStep.inhaling => 'inhaling',
      MeasurementStep.blowing => 'blowing',
      MeasurementStep.processing => 'processing',
      MeasurementStep.invalidAttempt => 'invalid',
    };
    return 'assets/images/measurement/$folder/$file.png';
  }

  String get _title => switch (step) {
    MeasurementStep.preparing => 'Get Ready',
    MeasurementStep.inhaling => 'Take a Deep Breath',
    MeasurementStep.blowing => 'Blow into the Device',
    MeasurementStep.processing => 'Processing',
    MeasurementStep.invalidAttempt => 'Try Again',
  };

  String get _description => switch (step) {
    MeasurementStep.preparing => 'Sit upright and prepare your device.',
    MeasurementStep.inhaling => 'Breathe in deeply before blowing.',
    MeasurementStep.blowing => guideMode == MeasurementGuideMode.child
        ? 'Blow to move the car!'
        : 'Blow firmly and quickly into the mouthpiece.',
    MeasurementStep.processing => 'Waiting for your measurement.',
    MeasurementStep.invalidAttempt => 'The attempt was not accepted. Please try again.',
  };

  @override
  Widget build(BuildContext context) {
    final isChildBlowing = guideMode == MeasurementGuideMode.child &&
        step == MeasurementStep.blowing;
    final isCompact = MediaQuery.sizeOf(context).height < 730;
    return LayoutBuilder(builder: (context, bounds) {
      final short = bounds.maxHeight < 220 || isCompact;
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 230),
              child: SizedBox.expand(
                key: ValueKey('${guideMode.name}-${step.name}'),
                child: step == MeasurementStep.processing
                    ? const ProcessingDeviceIndicator()
                    : isChildBlowing
                        ? LayoutBuilder(builder: (context, inner) {
                            final imageHeight = inner.maxHeight * .64;
                            return Column(
                              children: [
                                SizedBox(
                                  height: imageHeight,
                                  width: double.infinity,
                                  child: Image.asset(
                                    'assets/images/measurement/child/blowing.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, _, _) => const Icon(
                                      Icons.air_rounded,
                                      color: AppColors.primary, size: 52,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ChildBlowingProgress(progress: blowProgress),
                                ),
                              ],
                            );
                          })
                        : Image.asset(
                            _imagePath,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.image_outlined,
                              size: 52,
                              color: AppColors.primary,
                            ),
                          ),
              ),
            ),
          ),
          SizedBox(height: short ? 5 : 9),
          Text(
            _title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: short ? 17 : 19,
              color: step == MeasurementStep.invalidAttempt
                  ? AppColors.warning : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(fontSize: short ? 12 : 13),
          ),
        ],
      );
    });
  }
}
