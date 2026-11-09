
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/notification_server.dart';

class ReminderStore {
  static const String _storageKey = 'cpems_reminders';

  static final ValueNotifier<List<Map<String, dynamic>>> reminders =
      ValueNotifier([]);

  // تحويل التنبيهات إلى بيانات قابلة للحفظ
  static Map<String, dynamic> _encodeReminder(
    Map<String, dynamic> reminder,
  ) {
    final date = reminder['date'] as DateTime;
    final time = reminder['time'] as TimeOfDay;

    return {
      ...reminder,
      'date': date.toIso8601String(),
      'time': {
        'hour': time.hour,
        'minute': time.minute,
      },
    };
  }

  // استرجاع التاريخ والوقت بصيغتهما الأصلية
  static Map<String, dynamic> _decodeReminder(
    Map<String, dynamic> reminder,
  ) {
    final time = reminder['time'] as Map<String, dynamic>;

    return {
      ...reminder,
      'date': DateTime.parse(reminder['date'] as String),
      'time': TimeOfDay(
        hour: time['hour'] as int,
        minute: time['minute'] as int,
      ),
    };
  }

  // حفظ التنبيهات داخل الجهاز
  static Future<void> saveReminders() async {
    final prefs = await SharedPreferences.getInstance();

    final data = reminders.value
        .map(_encodeReminder)
        .toList();

    await prefs.setString(_storageKey, jsonEncode(data));
  }

  
static Future<void> loadReminders() async {
  final prefs = await SharedPreferences.getInstance();
  final savedData = prefs.getString(_storageKey);

  if (savedData == null) return;

  final decoded = jsonDecode(savedData) as List<dynamic>;

  final loadedReminders = decoded
      .map(
        (item) => _decodeReminder(
          Map<String, dynamic>.from(item as Map),
        ),
      )
      .toList();

  final usedIds = loadedReminders
      .map((reminder) => reminder['id'])
      .whereType<int>()
      .toSet();

  var nextId = 100;
  var needsSaving = false;

  for (final reminder in loadedReminders) {
    if (reminder['id'] is! int) {
      while (usedIds.contains(nextId)) {
        nextId++;
      }

      reminder['id'] = nextId;
      usedIds.add(nextId);
      needsSaving = true;
    }
  }

  reminders.value = loadedReminders;

  if (needsSaving) {
    await saveReminders();
  }
}

static int _generateId() {
  final usedIds = reminders.value
      .map((reminder) => reminder['id'])
      .whereType<int>()
      .toSet();

  var id = 100;

  while (usedIds.contains(id)) {
    id++;
  }

  return id;
}

static void add(Map<String, dynamic> reminder) {
  final newReminder = {
    ...reminder,
    'id': _generateId(),
  };

  reminders.value = [
    ...reminders.value,
    newReminder,
  ];

  saveReminders();

  NotificationService.scheduleReminder(newReminder);
}

  

static Future<void> update(
  Map<String, dynamic> oldReminder,
  Map<String, dynamic> updatedReminder,
) async {
  final id = oldReminder['id'] as int?;

  final updated = {
    ...updatedReminder,
    'id': id,
  };

  reminders.value = reminders.value.map((reminder) {
    if (identical(reminder, oldReminder)) {
      return updated;
    }
    return reminder;
  }).toList();

  await saveReminders();

  if (id != null) {
    await NotificationService.cancelReminder(id);
    await NotificationService.scheduleReminder(updated);
  }
}

  // حذف تنبيه
  
static Future<void> delete(
  Map<String, dynamic> reminderToDelete,
) async {
  final id = reminderToDelete['id'] as int?;

  reminders.value = reminders.value
      .where(
        (reminder) => !identical(reminder, reminderToDelete),
      )
      .toList();

  await saveReminders();

  if (id != null) {
    await NotificationService.cancelReminder(id);
  }
}


  // تحديد إذا كان التنبيه يظهر في اليوم المختار
  static bool occursOn(
    Map<String, dynamic> reminder,
    DateTime day,
  ) {
    final start = reminder['date'] as DateTime;
    final repeat = reminder['repeat']?.toString() ?? 'No Repeat';

    final startDay = DateTime(start.year, start.month, start.day);
    final targetDay = DateTime(day.year, day.month, day.day);

    final difference = targetDay.difference(startDay).inDays;

    if (difference < 0) return false;

    if (repeat == 'Daily') return true;
    if (repeat == 'Weekly') return difference % 7 == 0;

    return difference == 0;
  }

  // إرجاع تنبيهات اليوم وترتيبها حسب الوقت
  static List<Map<String, dynamic>> forDate(DateTime date) {
    final items = reminders.value
        .where((reminder) => occursOn(reminder, date))
        .toList();

    items.sort((a, b) {
      final aTime = a['time'] as TimeOfDay;
      final bTime = b['time'] as TimeOfDay;

      final aMinutes = aTime.hour * 60 + aTime.minute;
      final bMinutes = bTime.hour * 60 + bTime.minute;

      return aMinutes.compareTo(bMinutes);
    });

    return items;
  }
}
