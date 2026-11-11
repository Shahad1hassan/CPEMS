
import 'package:flutter/foundation.dart';

class MedicationStore {
  static final ValueNotifier<List<Map<String, dynamic>>> medications =
      ValueNotifier([]);

  static int _nextId = 1;

  static int _generateId() {
    final usedIds = medications.value
        .map((medication) => medication['id'])
        .whereType<int>()
        .toSet();

    while (usedIds.contains(_nextId)) {
      _nextId++;
    }

    return _nextId++;
  }

  static void add({
    required String name,
    required String dose,
    required String instructions,
  }) {
    final medication = <String, dynamic>{
      'id': _generateId(),
      'name': name.trim(),
      'dose': dose.trim(),
      'instructions': instructions.trim(),
    };

    medications.value = [
      ...medications.value,
      medication,
    ];
  }

  static void update({
    required int id,
    required String name,
    required String dose,
    required String instructions,
  }) {
    medications.value = medications.value.map((medication) {
      if (medication['id'] == id) {
        return <String, dynamic>{
          ...medication,
          'name': name.trim(),
          'dose': dose.trim(),
          'instructions': instructions.trim(),
        };
      }

      return medication;
    }).toList();
  }

  static void delete(int id) {
    medications.value = medications.value
        .where((medication) => medication['id'] != id)
        .toList();
  }

  static Map<String, dynamic>? findById(int id) {
    for (final medication in medications.value) {
      if (medication['id'] == id) {
        return medication;
      }
    }

    return null;
  }
}
