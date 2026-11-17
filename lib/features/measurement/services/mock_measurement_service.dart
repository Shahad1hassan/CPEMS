import 'dart:async';

import '../models/measurement_event.dart';
import 'measurement_device_service.dart';

/// A deterministic demonstration source. Values are NOT real patient data.
class MockMeasurementService implements MeasurementDeviceService {
  final _events = StreamController<MeasurementEvent>.broadcast(sync: true);
  int _generation = 0;
  bool _connected = false;
  bool _disposed = false;

  @override
  Stream<MeasurementEvent> get events => _events.stream;

  @override
  Future<void> connect() async {
    if (_disposed) return;
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!_disposed) _connected = true;
  }

  void _emit(MeasurementEvent event, int generation) {
    if (!_disposed && _connected && generation == _generation) {
      _events.add(event);
    }
  }

  @override
  Future<void> startAttempt({required int attemptId, required bool invalid}) async {
    if (!_connected || _disposed) return;
    cancelAttempt();
    final generation = _generation;
    _emit(MeasurementEvent(type: MeasurementEventType.blowStarted, attemptId: attemptId), generation);

    for (var i = 1; i <= 12; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 170));
      if (generation != _generation || !_connected || _disposed) return;
      // Visual game progress only. Not a physiological validity score.
      final progress = invalid ? i / 18.0 : i / 12.0;
      _emit(MeasurementEvent(
        type: MeasurementEventType.blowProgress,
        attemptId: attemptId,
        progress: progress,
      ), generation);
    }

    _emit(MeasurementEvent(type: MeasurementEventType.blowEnded, attemptId: attemptId), generation);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (generation != _generation || !_connected || _disposed) return;
    if (invalid) {
      _emit(MeasurementEvent(type: MeasurementEventType.readingInvalid, attemptId: attemptId), generation);
    } else {
      const demoValues = [390.0, 420.0, 405.0];
      // Accepted reading position is provided by controller via the attemptId
      // only for uniqueness. Here we cycle simulated values for the demo.
      final value = demoValues[(attemptId - 1) % demoValues.length];
      _emit(MeasurementEvent(
        type: MeasurementEventType.readingValid,
        attemptId: attemptId,
        pefValue: value,
      ), generation);
    }
  }

  @override
  void cancelAttempt() => _generation++;

  @override
  Future<void> disconnect() async {
    cancelAttempt();
    _connected = false;
    if (!_disposed) {
      _events.add(const MeasurementEvent(
        type: MeasurementEventType.deviceDisconnected,
        attemptId: 0,
      ));
    }
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    cancelAttempt();
    await _events.close();
  }
}
