import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/measurement_controller.dart';
import '../models/measurement_guide_mode.dart';
import '../services/mock_measurement_service.dart';
import '../widgets/device_status_card.dart';
import '../widgets/measurement_instructions.dart';
import '../widgets/reading_progress.dart';
import 'measurement_result_page.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({super.key});

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  late final MeasurementController _controller;
  bool _resultRouteOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = MeasurementController(MockMeasurementService());
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (!mounted || _resultRouteOpen || !_controller.hasResult) return;
    final session = _controller.takeResult();
    if (session == null) return;
    _resultRouteOpen = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => MeasurementResultPage(session: session),
        ),
      );
      if (!mounted) return;
      _resultRouteOpen = false;
      _controller.cancelSession();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  // Presenter-only controls: long-press the device card to open this sheet.
  // They are hidden during ordinary user-facing demonstrations.
  Future<void> _showDemoOptions() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Presenter controls', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 12),
              const Text(
                'Simulated readings only. Not connected to a physical device.',
                style: AppTextStyles.body,
              ),
              if (!_controller.isActive && !_controller.connecting) ...[
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _controller.chooseMode(MeasurementGuideMode.adult);
                  },
                  child: const Text('Adult instructions'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _controller.chooseMode(MeasurementGuideMode.child);
                  },
                  child: const Text('Child instructions + car'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _controller.chooseInvalidFirst(false);
                  },
                  child: const Text('Scenario: successful session'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _controller.chooseInvalidFirst(true);
                  },
                  child: const Text('Scenario: failed attempt then retry'),
                ),
              ],
              if (_controller.isActive) ...[
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _controller.simulateDisconnect();
                  },
                  child: const Text('Simulate disconnection'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final active = _controller.isActive;
        final finished = _controller.sessionState == MeasurementSessionState.finished;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Tooltip(
                message: 'Long press for presenter options',
                child: GestureDetector(
                  onLongPress: _showDemoOptions,
                  child: DeviceStatusCard(
                    connected: _controller.connected,
                    connecting: _controller.connecting,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (active || finished) ...[
                ReadingProgress(completedReadings: _controller.readings.length),
                const SizedBox(height: 6),
              ],
              Expanded(
                child: active
                    ? MeasurementInstructions(
                        step: _controller.step,
                        guideMode: _controller.guideMode,
                        blowProgress: _controller.blowProgress,
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.air_rounded, size: 68, color: AppColors.primary),
                            const SizedBox(height: 12),
                            Text(finished ? 'Session Finished' : 'Ready to Measure?',
                                style: AppTextStyles.sectionTitle),
                            const SizedBox(height: 8),
                            const Text('Follow the instructions to complete your measurement.',
                                style: AppTextStyles.body, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 8),
              if (active) ...[
                if (_controller.hasReadings)
                  OutlinedButton(
                    onPressed: _controller.finishEarly,
                    child: const Text('Finish Session Early'),
                  ),
                TextButton(
                  onPressed: _controller.cancelSession,
                  child: const Text('Cancel Session'),
                ),
              ] else
                ElevatedButton(
                  onPressed: _controller.connecting ? null : _controller.startDemo,
                  child: Text(_controller.connecting ? 'Connecting...' : 'Start Measurement'),
                ),

            ],
          ),
        );
      },
    );
  }
}
