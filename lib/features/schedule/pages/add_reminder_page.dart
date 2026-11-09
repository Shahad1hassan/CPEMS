
import 'package:flutter/material.dart';

class AddReminderPage extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, dynamic>? existingReminder;

  const AddReminderPage({
    super.key,
    required this.selectedDate,
    this.existingReminder,
  });

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  String reminderType = 'Medication';
  String repeat = 'Daily';

  final nameController = TextEditingController();
  final doseController = TextEditingController();

  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);
late DateTime selectedDate;
@override
void initState() {
  super.initState();
selectedDate = widget.existingReminder?['date'] as DateTime?
    ?? widget.selectedDate;
  final reminder = widget.existingReminder;

  if (reminder != null) {
    reminderType = reminder['type']?.toString() ?? 'Medication';
    repeat = reminder['repeat']?.toString() ?? 'Daily';
    selectedTime = reminder['time'] as TimeOfDay;

    nameController.text = reminder['name']?.toString() ?? '';
    doseController.text = reminder['dose']?.toString() ?? '';
  }
}

  @override
  void dispose() {
    nameController.dispose();
    doseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FD),
      appBar: AppBar(
       title: Text(
  widget.existingReminder == null
      ? 'New Reminder'
      : 'Edit Reminder',
),
        backgroundColor: const Color(0xFFF7F9FD),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Reminder Type'),
          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            initialValue: reminderType,
            items: const [
              DropdownMenuItem(
                value: 'Medication',
                child: Text('Medication'),
              ),
              DropdownMenuItem(
                value: 'PEF Measurement',
                child: Text('PEF Measurement'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                reminderType = value!;
              });
            },
          ),

          const SizedBox(height: 25),
          const Text('Date'),
          const SizedBox(height: 10),

          ListTile(
  contentPadding: EdgeInsets.zero,
  title: Text(
    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
    style: const TextStyle(fontSize: 18),
  ),
  trailing: const Icon(Icons.calendar_month),
  onTap: () async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  },
),

          const SizedBox(height: 25),
          const Text('Time'),
          const SizedBox(height: 10),

          ListTile(
            title: Text(selectedTime.format(context)),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: selectedTime,
              );

              if (time != null) {
                setState(() {
                  selectedTime = time;
                });
              }
            },
          ),

          if (reminderType == 'Medication') ...[
            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Medication Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: doseController,
              decoration: const InputDecoration(
                labelText: 'Dose',
                hintText: 'e.g. 1 tablet',
                border: OutlineInputBorder(),
              ),
            ),
          ],

          const SizedBox(height: 25),
          const Text('Repeat'),
          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            initialValue: repeat,
            items: const [
              DropdownMenuItem(
                value: 'Daily',
                child: Text('Daily'),
              ),
              DropdownMenuItem(
                value: 'Weekly',
                child: Text('Weekly'),
              ),
              DropdownMenuItem(
                value: 'No Repeat',
                child: Text('No Repeat'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                repeat = value!;
              });
            },
          ),

          const SizedBox(height: 35),

   ElevatedButton(
  onPressed: () {
    Navigator.pop(context, {
      'type': reminderType,
'date': selectedDate,      'time': selectedTime,
      'name': nameController.text.trim(),
      'dose': doseController.text.trim(),
      'repeat': repeat,
    });
  },
  child: Text(
    widget.existingReminder == null
        ? 'Save Reminder'
        : 'Save Changes',
  ),
),
        ],
      ),
    );
  }
}
