
import 'package:flutter/material.dart';

import '../../schedule/pages/my_schedule_page.dart';
import '../../schedule/data/reminder_store.dart';
import '../../schedule/pages/reminder_details_page.dart';
import '../../profile/data/patient_store.dart';
import '../../profile/data/medication_store.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    this.patientName,
  });

  final String? patientName;

  static const Color blue = Color(0xFF2563EB);
  static const Color navy = Color(0xFF142A55);
  static const Color background = Color(0xFFF7F9FD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CPEMS',
                  style: TextStyle(
                    color: blue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 26),

            ValueListenableBuilder<String>(
              valueListenable: PatientStore.name,
              builder: (context, name, child) {
                final firstName = name.trim().isNotEmpty
                    ? name.trim().split(RegExp(r'\s+')).first
                    : 'there';

                return Text(
                  'Hi $firstName!',
                  style: const TextStyle(
                    color: navy,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),

            const SizedBox(height: 5),

            const Text(
              'Your respiratory health overview',
              style: TextStyle(color: Colors.blueGrey),
            ),

            const SizedBox(height: 24),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Latest PEF Reading',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Icon(
                        Icons.air_rounded,
                        color: blue,
                        size: 36,
                      ),
                      SizedBox(width: 12),
                      Text(
                        '--',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: navy,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('L/min'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'No measurements recorded yet',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: blue,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "Today's Schedule",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: navy,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MySchedulePage(),
                            ),
                          );
                        },
                        child: const Text('See all →'),
                      ),
                    ],
                  ),

                  const Divider(height: 25),

                  ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: ReminderStore.reminders,
                    builder: (context, reminders, child) {
                      return ValueListenableBuilder<
                          List<Map<String, dynamic>>>(
                        valueListenable: MedicationStore.medications,
                        builder: (context, medications, child) {
                          final todayReminders =
                              ReminderStore.forDate(DateTime.now());

                          if (todayReminders.isEmpty) {
                            return const Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  'No reminders scheduled for today',
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              for (int i = 0;
                                  i < todayReminders.length;
                                  i++) ...[
                                if (i > 0)
                                  const Divider(height: 24),

                                Builder(
                                  builder: (context) {
                                    final reminder =
                                        todayReminders[i];

                                    final isMedication =
                                        reminder['type'] ==
                                            'Medication';

                                    final time =
                                        reminder['time'] as TimeOfDay;

                                    final medicationId =
                                        reminder['medicationId'];

                                    Map<String, dynamic>? medication;

                                    if (isMedication &&
                                        medicationId is int) {
                                      for (final item
                                          in medications) {
                                        if (item['id'] ==
                                            medicationId) {
                                          medication = item;
                                          break;
                                        }
                                      }
                                    }

                                    // Show the latest medication data.
                                    // Fall back to saved values for older reminders.
                                    final name =
                                        medication?['name']
                                                ?.toString() ??
                                            reminder['name']
                                                ?.toString() ??
                                            '';

                                    final dose =
                                        medication?['dose']
                                                ?.toString() ??
                                            reminder['dose']
                                                ?.toString() ??
                                            '';

                                    return InkWell(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ReminderDetailsPage(
                                              reminder: reminder,
                                            ),
                                          ),
                                        );
                                      },
                                      child: _scheduleItem(
                                        isMedication
                                            ? Icons.medication_outlined
                                            : Icons.air_rounded,
                                        time.format(context),
                                        isMedication &&
                                                name.isNotEmpty
                                            ? name
                                            : 'PEF Measurement',
                                        isMedication
                                            ? (dose.isNotEmpty
                                                ? 'Dose: $dose'
                                                : 'Medication reminder')
                                            : 'Use your CPEMS device',
                                        isMedication
                                            ? Colors.redAccent
                                            : blue,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _card(
              child: const Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.amber,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Follow your measurement instructions '
                      'for consistent readings.',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _quickAction(
                    Icons.chat_bubble_outline,
                    'My Doctor',
                    'Contact & follow-up',
                    const Color(0xFFE8F2FF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickAction(
                    Icons.warning_amber_rounded,
                    'Emergency',
                    'Get help now',
                    const Color(0xFFFFE9EC),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  static Widget _scheduleItem(
    IconData icon,
    String time,
    String title,
    String subtitle,
    Color color,
  ) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.10),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$time  ·  $title',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.chevron_right,
          color: Colors.blueGrey,
        ),
      ],
    );
  }

  static Widget _quickAction(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: navy, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
