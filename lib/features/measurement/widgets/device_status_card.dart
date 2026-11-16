import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class DeviceStatusCard extends StatelessWidget {
  final bool connected;
  final bool connecting;

  const DeviceStatusCard({
    super.key,
    this.connected = false,
    this.connecting = false,
  });

  @override
  Widget build(BuildContext context) {
    final status = connecting
        ? 'Connecting...'
        : connected ? 'Connected' : 'Not connected';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              connected ? Icons.bluetooth_connected : Icons.bluetooth,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('CPEMS Device', style: AppTextStyles.label),
                const SizedBox(height: 3),
                Text(status,
                    style: AppTextStyles.caption.copyWith(
                      color: connected ? AppColors.success : AppColors.textMuted,
                    )),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.battery_4_bar_outlined, color: AppColors.textMuted),
          const SizedBox(width: 4),
          const Text('60%', style: AppTextStyles.body),
        ],
      ),
    );
  }
}
