
import 'package:flutter/material.dart';
import 'app.dart';
import 'features/schedule/data/reminder_store.dart';
import 'services/notification_server.dart';
import 'features/profile/data/medication_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await NotificationService.initialize();

  // Load saved reminders
  await ReminderStore.loadReminders();

  // Load saved medications
await MedicationStore.loadMedications();

  // Schedule notifications for saved reminders
  for (final reminder in ReminderStore.reminders.value) {
    await NotificationService.scheduleReminder(reminder);
  }

  // Start the application
  runApp(const CpemsApp());
}



