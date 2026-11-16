enum MeasurementEventType {
  blowStarted,
  blowProgress,
  blowEnded,
  readingValid,
  readingInvalid,
  deviceDisconnected,
}

class MeasurementEvent {
  final MeasurementEventType type;
  final int attemptId;
  final double? progress;
  final double? pefValue;

  const MeasurementEvent({
    required this.type,
    required this.attemptId,
    this.progress,
    this.pefValue,
  });
}
