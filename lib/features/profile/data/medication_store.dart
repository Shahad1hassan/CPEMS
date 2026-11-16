
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../schedule/data/reminder_store.dart';
import '../../../services/notification_server.dart';

class MedicationStore {
  static final ValueNotifier<List<Map<String, dynamic>>> medications =
      ValueNotifier([]);

  static int _nextId = 1;

  static const String _storageKey = 'cpems_medications';

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

  // Update medication and its linked reminders.
  static Future<void> update({
    required int id,
    required String name,
    required String dose,
    required String instructions,
  }) async {
    final existingMedication = findById(id);

    if (existingMedication == null) {
      return;
    }

    final updatedName = name.trim();
    final updatedDose = dose.trim();
    final updatedInstructions = instructions.trim();

    // Update medication information.
    medications.value = medications.value.map((medication) {
      if (medication['id'] == id) {
        return <String, dynamic>{
          ...medication,
          'name': updatedName,
          'dose': updatedDose,
          'instructions': updatedInstructions,
        };
      }

      return medication;
    }).toList();

    // Find reminders linked to this medication.
    final linkedReminders = ReminderStore.reminders.value.where(
      (reminder) =>
          reminder['type'] == 'Medication' &&
          reminder['medicationId'] == id,
    ).toList();

    // Update the saved medication details in linked reminders.
    if (linkedReminders.isNotEmpty) {
      ReminderStore.reminders.value =
          ReminderStore.reminders.value.map((reminder) {
        if (reminder['type'] == 'Medication' &&
            reminder['medicationId'] == id) {
          return <String, dynamic>{
            ...reminder,
            'name': updatedName,
            'dose': updatedDose,
          };
        }

        return reminder;
      }).toList();
    }

    // Save the updated medication.
    await saveMedications();

    if (linkedReminders.isNotEmpty) {
      // Save updated reminders before rescheduling.
      await ReminderStore.saveReminders();

      // Replace old notifications with updated ones.
      final updatedReminders = ReminderStore.reminders.value.where(
        (reminder) =>
            reminder['type'] == 'Medication' &&
            reminder['medicationId'] == id,
      );

      for (final reminder in updatedReminders) {
        final reminderId = reminder['id'];

        if (reminderId is int) {
          await NotificationService.cancelReminder(reminderId);
          await NotificationService.scheduleReminder(reminder);
        }
      }
    }
  }

  static Future<void> delete(int id) async {
  // Cancel and remove reminders linked to this medication.
  await ReminderStore.deleteRemindersForMedication(id);

  // Remove the medication.
  medications.value = medications.value
      .where((medication) => medication['id'] != id)
      .toList();

  // Persist the updated medication list.
  await saveMedications();
}

  static Map<String, dynamic>? findById(int id) {
    for (final medication in medications.value) {
      if (medication['id'] == id) {
        return medication;
      }
    }

    return null;
  }

  // Save medications on the device.
  static Future<void> saveMedications() async {
    final prefs = await SharedPreferences.getInstance();

    final data = jsonEncode(medications.value);

    await prefs.setString(_storageKey, data);
  }

  // Load medications when the app starts.
  static Future<void> loadMedications() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_storageKey);

    if (savedData == null) return;

    final decoded = jsonDecode(savedData) as List<dynamic>;

    final loadedMedications = decoded
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    medications.value = loadedMedications;

    // Prevent duplicate medication IDs.
    final ids = loadedMedications
        .map((medication) => medication['id'])
        .whereType<int>()
        .toList();

    _nextId = ids.isEmpty
        ? 1
        : ids.reduce((a, b) => a > b ? a : b) + 1;
  }
}
