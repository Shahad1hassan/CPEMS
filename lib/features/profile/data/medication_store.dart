
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
    saveMedications();
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
    saveMedications();
  }

  static void delete(int id) {
    medications.value = medications.value
        .where((medication) => medication['id'] != id)
        .toList();
        saveMedications();
  }

  static Map<String, dynamic>? findById(int id) {
    for (final medication in medications.value) {
      if (medication['id'] == id) {
        return medication;
      }
    }

    return null;
  }

  static const String _storageKey = 'cpems_medications';

  // Save medications on the device
  static Future<void> saveMedications() async {
    final prefs = await SharedPreferences.getInstance();

    final data = jsonEncode(medications.value);
    await prefs.setString(_storageKey, data);
  }

  // Load medications when the app starts
  static Future<void> loadMedications() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_storageKey);

    if (savedData == null) return;

    final decoded = jsonDecode(savedData) as List<dynamic>;

    final loadedMedications = decoded
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    medications.value = loadedMedications;

    // Prevent duplicate medication IDs
    final ids = loadedMedications
        .map((medication) => medication['id'])
        .whereType<int>()
        .toList();

    _nextId = ids.isEmpty
        ? 1
        : ids.reduce((a, b) => a > b ? a : b) + 1;
  }

}
