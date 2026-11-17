
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'add_reminder_page.dart';
import 'reminder_details_page.dart';
import '../data/reminder_store.dart';
import '../../profile/data/medication_store.dart';

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({super.key});

  @override
  State<MySchedulePage> createState() => _MySchedulePageState();
}

class _MySchedulePageState extends State<MySchedulePage> {
  static const Color primary = Color(0xFF2563EB);
  static const Color navy = Color(0xFF142A55);
  static const Color background = Color(0xFFF4F8FF);
  static const Color muted = Color(0xFF64748B);
  static const Color purple = Color(0xFF8B5CF6);

  DateTime selectedDate = DateTime.now();
  DateTime visibleWeek = DateTime.now();

  DateTime get weekStart => visibleWeek.subtract(
        Duration(days: visibleWeek.weekday % 7),
      );

  void changeWeek(int weeks) {
    setState(() {
      visibleWeek = visibleWeek.add(Duration(days: weeks * 7));
      selectedDate = selectedDate.add(Duration(days: weeks * 7));
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = List.generate(
      7,
      (index) => weekStart.add(Duration(days: index)),
    );

    const dayNames = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];

    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'My Schedule',
          style: TextStyle(
            color: navy,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        backgroundColor: background,
        surfaceTintColor: background,
        scrolledUnderElevation: 0,
        elevation: 0,
        foregroundColor: navy,
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          color: background,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2563EB),
                  Color(0xFF3B82F6),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.20),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: openAddReminder,
                borderRadius: BorderRadius.circular(16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 23,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Add Reminder',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          Positioned(
            top: -85,
            right: -85,
            child: _backgroundCircle(
              240,
              const Color(0xFFDAEAFE),
            ),
          ),
          Positioned(
            bottom: -65,
            left: -80,
            child: _backgroundCircle(
              210,
              const Color(0xFFE4EAFF),
            ),
          ),

          ScrollConfiguration(
            behavior: const _NoStretchScrollBehavior(),
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: MedicationStore.medications,
              builder: (context, medications, child) {
                return ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable: ReminderStore.reminders,
                  builder: (context, allReminders, child) {
                    final reminders =
                        ReminderStore.forDate(selectedDate);

                    return ListView(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        18,
                        20,
                        30,
                      ),
                      children: [
                        // Month heading with subtle gradient
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 17,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFE9F2FF),
                                Color(0xFFD8E9FF),
                                Color(0xFFC9E2FF),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_rounded,
                                color: primary,
                                size: 26,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${monthNames[selectedDate.month - 1]} '
                                  '${selectedDate.year}',
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              _weekButton(
                                Icons.chevron_left_rounded,
                                () => changeWeek(-1),
                              ),
                              const SizedBox(width: 8),
                              _weekButton(
                                Icons.chevron_right_rounded,
                                () => changeWeek(1),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Week calendar
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

                            final isPast = DateTime(
                              day.year,
                              day.month,
                              day.day,
                            ).isBefore(
                              DateTime(
                                now.year,
                                now.month,
                                now.day,
                              ),
                            );

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius.circular(15),
                                    onTap: () {
                                      setState(() {
                                        selectedDate = day;
                                        visibleWeek = day;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: isSelected
                                            ? const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color(0xFF2563EB),
                                                  Color(0xFF3B82F6),
                                                ],
                                              )
                                            : null,
                                        color: isSelected
                                            ? null
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15),
                                        border: Border.all(
                                          color: isToday && !isSelected
                                              ? const Color(0xFFBFD7FF)
                                              : Colors.transparent,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: primary.withValues(
                                                    alpha: 0.17,
                                                  ),
                                                  blurRadius: 9,
                                                  offset:
                                                      const Offset(0, 4),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            dayNames[index],
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : muted,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${day.day}',
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : isPast
                                                      ? const Color(0xFFB0B9C8)
                                                      : navy,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          'Schedule',
                          style: TextStyle(
                            color: navy,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 17),

                        if (reminders.isEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 38,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE8EDF7),
                              ),
                            ),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.event_available_outlined,
                                  color: Color(0xFF94A3B8),
                                  size: 34,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'No reminders scheduled for this day.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: muted,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ...reminders.map((reminder) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: _reminderCard(
                              context,
                              reminder,
                              medications,
                            ),
                          );
                        }),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _weekButton(
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: navy,
          size: 22,
        ),
      ),
    );
  }

  Widget _reminderCard(
    BuildContext context,
    Map<String, dynamic> reminder,
    List<Map<String, dynamic>> medications,
  ) {
    final isMedication = reminder['type'] == 'Medication';
    final medicationId = reminder['medicationId'];

    Map<String, dynamic>? medication;

    if (isMedication && medicationId is int) {
      for (final item in medications) {
        if (item['id'] == medicationId) {
          medication = item;
          break;
        }
      }
    }

    final name = medication?['name']?.toString() ??
        reminder['name']?.toString() ??
        '';

    final dose = medication?['dose']?.toString() ??
        reminder['dose']?.toString() ??
        '';

    final repeat =
        reminder['repeat']?.toString() ?? 'No Repeat';

    final time = reminder['time'] as TimeOfDay;

    final title = isMedication && name.isNotEmpty
        ? name
        : 'PEF Measurement';

    final iconColor = isMedication
        ? purple
        : primary;

    final iconBackground = isMedication
        ? const Color(0xFFF0E5FF)
        : const Color(0xFFE7F2FF);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isMedication
              ? const [
                  Color(0xFFFFFFFF),
                  Color(0xFFF8F4FF),
                  Color(0xFFF1EAFF),
                ]
              : const [
                  Color(0xFFFFFFFF),
                  Color(0xFFF4F9FF),
                  Color(0xFFEAF3FF),
                ],
        ),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: isMedication
              ? const Color(0xFFE9DEFA)
              : const Color(0xFFDDE9FC),
        ),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(21),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 19,
            ),
            child: Row(
              children: [
                Container(
                  width: 51,
                  height: 51,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isMedication
                        ? LucideIcons.pill
                        : Icons.air_rounded,
                    color: iconColor,
                    size: 27,
                  ),
                ),

                const SizedBox(width: 13),

                Container(
                  width: 2,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isMedication
                        ? const Color(0xFFD9C7F5)
                        : const Color(0xFFC9DDF9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 8),

                      if (isMedication && dose.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(
                              LucideIcons.pill,
                              size: 14,
                              color: muted,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Dose: $dose',
                                style: const TextStyle(
                                  color: muted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                      ],

                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: muted,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${time.format(context)} • $repeat',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 5),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF53627E),
                  size: 23,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _backgroundCircle(
    double size,
    Color color,
  ) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.85),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoStretchScrollBehavior extends MaterialScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
