

import 'package:flutter/material.dart';
import 'app.dart';
import 'features/schedule/data/reminder_store.dart';
import 'services/notification_server.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await NotificationService.initialize();

  // Load saved reminders
  await ReminderStore.loadReminders();

  // Schedule notifications for saved reminders
  for (final reminder in ReminderStore.reminders.value) {
    await NotificationService.scheduleReminder(reminder);
  }

  runApp(const CpemsApp());
}

