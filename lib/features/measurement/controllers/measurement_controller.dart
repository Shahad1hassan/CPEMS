import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/measurement_event.dart';
import '../models/measurement_guide_mode.dart';
import '../models/measurement_session.dart';
import '../services/measurement_device_service.dart';
import '../widgets/measurement_instructions.dart';

enum MeasurementSessionState { ready, active, finished }

/// Owns session logic; neither the widget nor this controller knows about BLE.
class MeasurementController extends ChangeNotifier {
  final MeasurementDeviceService device;
  late final StreamSubscription<MeasurementEvent> _subscription;

  MeasurementController(this.device) {
    _subscription = device.events.listen(_onEvent);
  }

  MeasurementSessionState sessionState = MeasurementSessionState.ready;
  MeasurementGuideMode guideMode = MeasurementGuideMode.adult;
  MeasurementStep step = MeasurementStep.preparing;
  bool connected = false;
  bool connecting = false;
  bool invalidFirstAttempt = false;
  double blowProgress = 0;
  final List<double> readings = [];

  int _generation = 0;
  int _attemptId = 0;
  int? _acceptedOrRejectedId;
  bool _didInvalidDemo = false;
  bool _disposed = false;
  bool _resultPending = false;

  bool get isActive => sessionState == MeasurementSessionState.active;
  bool get hasResult => _resultPending;
  bool get hasReadings => readings.isNotEmpty;

  void chooseMode(MeasurementGuideMode value) {
    if (isActive) return;
    guideMode = value;
    notifyListeners();
  }

  void chooseInvalidFirst(bool value) {
    if (isActive) return;
    invalidFirstAttempt = value;
    notifyListeners();
  }

  Future<void> startDemo() async {
    if (isActive || connecting) return;
    _cancelOngoing();
    final generation = _generation;
    readings.clear();
    step = MeasurementStep.preparing;
    blowProgress = 0;
    _didInvalidDemo = false;
    _resultPending = false;
    sessionState = MeasurementSessionState.ready;
    connecting = true;
    notifyListeners();

    await device.connect();
    if (!_stillCurrent(generation)) return;
    connected = true;
    connecting = false;
    sessionState = MeasurementSessionState.active;
    notifyListeners();
    _runNextAttempt(generation);
  }

  Future<void> _runNextAttempt(int generation) async {
    if (!_stillCurrent(generation) || !isActive || !connected) return;
    _attemptId++;
    _acceptedOrRejectedId = null;
    final attempt = _attemptId;
    blowProgress = 0;
    step = MeasurementStep.preparing;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 1300));
    if (!_mayContinue(generation, attempt)) return;
    step = MeasurementStep.inhaling;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!_mayContinue(generation, attempt)) return;
    step = MeasurementStep.blowing;
    notifyListeners();
    final invalid = invalidFirstAttempt && !_didInvalidDemo;
    if (invalid) _didInvalidDemo = true;
    await device.startAttempt(attemptId: attempt, invalid: invalid);
  }

  void _onEvent(MeasurementEvent event) {
    if (event.type == MeasurementEventType.deviceDisconnected) {
      _cancelOngoing();
      connected = false;
      connecting = false;
      // Preserve accepted readings; an interrupted attempt is not accepted.
      if (isActive) {
        sessionState = MeasurementSessionState.ready;
        step = MeasurementStep.preparing;
      }
      notifyListeners();
      return;
    }
    if (!isActive || !connected || event.attemptId != _attemptId) return;
    if (_acceptedOrRejectedId == event.attemptId) return;

    switch (event.type) {
      case MeasurementEventType.blowStarted:
        step = MeasurementStep.blowing;
        blowProgress = 0;
        notifyListeners();
      case MeasurementEventType.blowProgress:
        if (step != MeasurementStep.blowing) return;
        final p = event.progress;
        if (p == null || !p.isFinite) return;
        blowProgress = p.clamp(blowProgress, 1.0).toDouble();
        notifyListeners();
      case MeasurementEventType.blowEnded:
        step = MeasurementStep.processing;
        notifyListeners();
      case MeasurementEventType.readingInvalid:
        _acceptedOrRejectedId = event.attemptId;
        step = MeasurementStep.invalidAttempt;
        notifyListeners();
        final generation = _generation;
        final attempt = _attemptId;
        _retryAfterMessage(generation, attempt);
      case MeasurementEventType.readingValid:
        final value = event.pefValue;
        if (value == null || !value.isFinite || value <= 0) return;
        _acceptedOrRejectedId = event.attemptId;
        readings.add(value);
        blowProgress = 0;
        if (readings.length >= MeasurementSession.recommendedReadings) {
          sessionState = MeasurementSessionState.finished;
          _resultPending = true;
        } else {
          step = MeasurementStep.preparing;
        }
        notifyListeners();
        if (isActive) {
          final generation = _generation;
          _runNextAfterPause(generation);
        }
      case MeasurementEventType.deviceDisconnected:
        break;
    }
  }

  Future<void> _retryAfterMessage(int generation, int attempt) async {
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    if (_mayContinue(generation, attempt)) _runNextAttempt(generation);
  }

  Future<void> _runNextAfterPause(int generation) async {
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (_stillCurrent(generation) && isActive && connected) {
      _runNextAttempt(generation);
    }
  }

  bool _stillCurrent(int generation) => !_disposed && generation == _generation;
  bool _mayContinue(int generation, int attempt) =>
      _stillCurrent(generation) && isActive && connected && attempt == _attemptId;

  void _cancelOngoing() {
    _generation++;
    device.cancelAttempt();
  }

  void finishEarly() {
    if (!isActive || readings.isEmpty) return;
    _cancelOngoing();
    sessionState = MeasurementSessionState.finished;
    _resultPending = true;
    notifyListeners();
  }

  MeasurementSession? takeResult() {
    if (!_resultPending || readings.isEmpty) return null;
    _resultPending = false;
    return MeasurementSession(readings: readings, measuredAt: DateTime.now());
  }

  void cancelSession() {
    _cancelOngoing();
    readings.clear();
    blowProgress = 0;
    step = MeasurementStep.preparing;
    sessionState = MeasurementSessionState.ready;
    _resultPending = false;
    notifyListeners();
  }

  Future<void> simulateDisconnect() => device.disconnect();

  @override
  void dispose() {
    _disposed = true;
    _cancelOngoing();
    _subscription.cancel();
    device.dispose();
    super.dispose();
  }
}
