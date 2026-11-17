import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

import '../models/measurement_session.dart';

class MeasurementResultPage extends StatelessWidget {
  final MeasurementSession session;

const MeasurementResultPage({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final bestReading = session.bestReading;
    final isComplete = session.isComplete;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Measurement Result'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 60,
                        color: AppColors.success,
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Session Finished',
                        style: AppTextStyles.sectionTitle,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        isComplete
                            ? 'All 3 readings completed'
                            : '${session.completedReadings} of 3 '
                              'recommended readings',
                        style: AppTextStyles.body,
                      ),

                      const SizedBox(height: 24),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Highest PEF Reading',
                              style: AppTextStyles.label,
                            ),

                            const SizedBox(height: 10),

                            Text(
                              '${bestReading.toStringAsFixed(0)} L/min',
                              style: AppTextStyles.readingValue
                                  .copyWith(
                                color: AppColors.primary,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Best of ${session.completedReadings} readings',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: List.generate(
                          session.completedReadings,
                          (index) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.border,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Reading ${index + 1}',
                                        style: AppTextStyles.caption,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        session.readings[index]
                                            .toStringAsFixed(0),
                                        style: AppTextStyles.label,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
