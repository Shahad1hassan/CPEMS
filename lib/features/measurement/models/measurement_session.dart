
class MeasurementSession {
  final List<double> readings;
  final DateTime measuredAt;

  MeasurementSession({
    required List<double> readings,
    required this.measuredAt,
  }) : readings = List.unmodifiable(readings);

  static const int recommendedReadings = 3;

  int get completedReadings => readings.length;

  bool get isComplete =>
      completedReadings == recommendedReadings;

  bool get endedEarly => !isComplete;

  double get bestReading {
    return readings.reduce(
      (a, b) => a > b ? a : b,
    );
  }
}
