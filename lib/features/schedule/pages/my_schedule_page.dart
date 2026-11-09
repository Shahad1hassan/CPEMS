
import 'package:flutter/material.dart';
import 'add_reminder_page.dart';
import 'reminder_details_page.dart';
import '../data/reminder_store.dart';
import '../../../services/notification_server.dart';

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({super.key});

  @override
  State<MySchedulePage> createState() => _MySchedulePageState();
}

class _MySchedulePageState extends State<MySchedulePage> {
  DateTime selectedDate = DateTime.now();
  DateTime visibleWeek = DateTime.now();

  DateTime get weekStart => visibleWeek.subtract(
    Duration(days: visibleWeek.weekday % 7),
  );

  void changeWeek(int weeks) {
  setState(() {
    visibleWeek = visibleWeek.add(
      Duration(days: weeks * 7),
    );
  });
}
  
Future<void> openAddReminder() async {
  final result = await Navigator.push<Map<String, dynamic>>(
    context,
    MaterialPageRoute(
      builder: (context) => AddReminderPage(
        selectedDate: selectedDate,
      ),
    ),
  );

  if (!mounted) return;

  if (result != null) {
  ReminderStore.add(result);
  setState(() {});
}
}


  @override
  Widget build(BuildContext context) {
    final days = List.generate(
      7,
      (index) => weekStart.add(Duration(days: index)),
    );

    const dayNames = [
      'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
    ];

    const monthNames = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FD),
      appBar: AppBar(
        title: const Text('My Schedule'),
        backgroundColor: const Color(0xFFF7F9FD),
      ),
      bottomNavigationBar: SafeArea(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: SizedBox(
      height: 54,
      child: ElevatedButton.icon(
       
onPressed: openAddReminder,

        icon: const Icon(Icons.add),
        label: const Text('Add Reminder'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    ),
  ),
),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${monthNames[selectedDate.month - 1]} '
                '${selectedDate.year}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => changeWeek(-1),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  IconButton(
                    onPressed: () => changeWeek(1),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: List.generate(7, (index) {
            final day = days[index];

final isSelected =
    day.year == selectedDate.year &&
    day.month == selectedDate.month &&
    day.day == selectedDate.day;

final now = DateTime.now();

final isToday =
    day.year == now.year &&
    day.month == now.month &&
    day.day == now.day;

    final isPast = DateTime(day.year, day.month, day.day)
    .isBefore(DateTime(now.year, now.month, now.day));

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = day;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                     color: isSelected
    ? const Color(0xFF2563EB)
    : isToday
        ? const Color(0xFFE5E7EB)
        : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(
                          dayNames[index],
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
    ? Colors.white
    : isPast
        ? Colors.grey.shade400
        : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 30),

          const Text(
            'Schedule',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          if (ReminderStore.forDate(selectedDate).isEmpty)
  const Padding(
    padding: EdgeInsets.symmetric(vertical: 40),
    child: Center(
      child: Text(
        'No reminders scheduled for this day.',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    ),
  ),

...ReminderStore.forDate(selectedDate).map((reminder) {
  final isMedication = reminder['type'] == 'Medication';
  final name = reminder['name']?.toString() ?? '';
  final dose = reminder['dose']?.toString() ?? '';
  final repeat = reminder['repeat']?.toString() ?? 'No Repeat';
  final time = reminder['time'] as TimeOfDay;

  return Card(
    child: ListTile(
     onTap: () async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ReminderDetailsPage(
        reminder: reminder,
      ),
    ),
  );

  if (!mounted) return;
  setState(() {});
},
      leading: Icon(
        isMedication ? Icons.medication : Icons.air,
        color: isMedication ? Colors.redAccent : Colors.blue,
      ),
    title: Text(
  isMedication && name.isNotEmpty
      ? name
      : 'PEF Measurement',
),

subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [
    ElevatedButton.icon(
  onPressed: () async {
    final granted = await NotificationService.requestPermission();

    if (!granted) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please allow notifications in Settings.'),
        ),
      );
      return;
    }

    await NotificationService.scheduleTestNotification();
  },
  icon: const Icon(Icons.notifications_active),
  label: const Text('Test Notification'),
),

const SizedBox(height: 16),
    if (isMedication && dose.isNotEmpty)
      Text('Dose: $dose'),
    Text('${time.format(context)} • $repeat'),
  ],
),
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}),

        ],
      ),
    );
  }
}
