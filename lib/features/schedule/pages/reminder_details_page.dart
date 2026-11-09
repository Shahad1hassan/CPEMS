
import 'package:flutter/material.dart';
import 'add_reminder_page.dart';
import '../data/reminder_store.dart';

class ReminderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> reminder;

  const ReminderDetailsPage({
    super.key,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context) {
    final type = reminder['type']?.toString() ?? '';
    final name = reminder['name']?.toString() ?? '';
    final dose = reminder['dose']?.toString() ?? '';
    final repeat = reminder['repeat']?.toString() ?? 'No Repeat';
    final time = reminder['time'] as TimeOfDay;
    final date = reminder['date'] as DateTime;

    final isMedication = type == 'Medication';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FD),
      appBar: AppBar(
        title: const Text('Reminder Details'),
        backgroundColor: const Color(0xFFF7F9FD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isMedication
                          ? Icons.medication
                          : Icons.air,
                      color: isMedication
                          ? Colors.redAccent
                          : Colors.blue,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isMedication ? name : 'PEF Measurement',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const Divider(height: 32),

                Text('Type: $type'),
                const SizedBox(height: 12),

                if (isMedication) ...[
                  Text('Dose: $dose'),
                  const SizedBox(height: 12),
                ],

                Text('Time: ${time.format(context)}'),
                const SizedBox(height: 12),

                Text('Repeat: $repeat'),
                const SizedBox(height: 12),

                Text(
                  'Start Date: ${date.day}/${date.month}/${date.year}',
                ),
                const SizedBox(height: 30),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () async {
      final updatedReminder =
          await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (context) => AddReminderPage(
            selectedDate: date,
            existingReminder: reminder,
          ),
        ),
      );

      if (updatedReminder != null) {
        await ReminderStore.update(reminder, updatedReminder);

        if (!context.mounted) return;

        Navigator.pop(context);
      }
    },
    icon: const Icon(Icons.edit),
    label: const Text('Edit Reminder'),
  ),
),

const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: () async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Delete Reminder?'),
          content: const Text(
            'Are you sure you want to delete this reminder?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await ReminderStore.delete(reminder);

        if (!context.mounted) return;
        Navigator.pop(context);
      }
    },
    icon: const Icon(Icons.delete_outline, color: Colors.red),
    label: const Text(
      'Delete Reminder',
      style: TextStyle(color: Colors.red),
    ),
  ),
),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
