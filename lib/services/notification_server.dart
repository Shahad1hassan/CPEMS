
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    
tz.initializeTimeZones();

final timezoneInfo = await FlutterTimezone.getLocalTimezone();
tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(
      settings: settings,
    );
  }

  static Future<bool> requestPermission() async {
    final android = notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final granted =
        await android?.requestNotificationsPermission();

    return granted ?? false;
  }

  static Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'cpems_reminders',
      'CPEMS Reminders',
      channelDescription: 'Medication and PEF measurement reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    await notifications.show(
      id: 1,
      title: 'CPEMS Reminder',
      body: 'Your notification system is working!',
      notificationDetails: details,
    );
  }
  
static Future<void> scheduleTestNotification() async {
  final scheduledDate = tz.TZDateTime.now(
    tz.local,
  ).add(const Duration(minutes: 2));

  const androidDetails = AndroidNotificationDetails(
    'cpems_reminders',
    'CPEMS Reminders',
    channelDescription: 'Medication and PEF measurement reminders',
    importance: Importance.high,
    priority: Priority.high,
  );

  const details = NotificationDetails(
    android: androidDetails,
  );

  await notifications.zonedSchedule(
    id: 2,
    title: 'CPEMS Scheduled Reminder',
    body: 'Your scheduled notification is working!',
    scheduledDate: scheduledDate,
    notificationDetails: details,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
  );
}
static Future<void> scheduleReminder(
  Map<String, dynamic> reminder,
) async {
  final id = reminder['id'] as int?;
  if (id == null) return;

  final date = reminder['date'] as DateTime;
  final time = reminder['time'] as TimeOfDay;
  final repeat = reminder['repeat']?.toString() ?? 'No Repeat';

  final isMedication = reminder['type'] == 'Medication';
  final name = reminder['name']?.toString() ?? '';
  final dose = reminder['dose']?.toString() ?? '';

  var scheduledDate = tz.TZDateTime(
    tz.local,
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );

  final now = tz.TZDateTime.now(tz.local);

  if (repeat == 'Daily') {
    while (!scheduledDate.isAfter(now)) {
      scheduledDate = tz.TZDateTime(
        tz.local,
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day + 1,
        time.hour,
        time.minute,
      );
    }
  } else if (repeat == 'Weekly') {
    while (!scheduledDate.isAfter(now)) {
      scheduledDate = tz.TZDateTime(
        tz.local,
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day + 7,
        time.hour,
        time.minute,
      );
    }
  } else {
    if (!scheduledDate.isAfter(now)) return;
  }

  const details = NotificationDetails(
    android: AndroidNotificationDetails(
      'cpems_reminders',
      'CPEMS Reminders',
      channelDescription: 'Medication and PEF measurement reminders',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  await notifications.zonedSchedule(
    id: id,
    title: isMedication
        ? 'Medication Reminder'
        : 'PEF Measurement Reminder',
    body: isMedication
        ? 'Time to take $name${dose.isNotEmpty ? ' - $dose' : ''}'
        : 'Time to measure your Peak Expiratory Flow.',
    scheduledDate: scheduledDate,
    notificationDetails: details,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: repeat == 'Daily'
        ? DateTimeComponents.time
        : repeat == 'Weekly'
            ? DateTimeComponents.dayOfWeekAndTime
            : null,
  );
}

static Future<void> cancelReminder(int id) async {
  await notifications.cancel(id: id);
}

}


