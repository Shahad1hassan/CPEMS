import '../models/measurement_event.dart';

/// Contract shared by a simulated device and a future BLE implementation.
abstract class MeasurementDeviceService {
  Stream<MeasurementEvent> get events;
  Future<void> connect();
  Future<void> startAttempt({required int attemptId, required bool invalid});
  void cancelAttempt();
  Future<void> disconnect();
  Future<void> dispose();
}
