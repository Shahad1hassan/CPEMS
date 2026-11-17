
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'add_reminder_page.dart';
import '../data/reminder_store.dart';
import '../../profile/data/medication_store.dart';

class ReminderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> reminder;

  const ReminderDetailsPage({
    super.key,
    required this.reminder,
  });

  static const Color navy = Color(0xFF142A55);
  static const Color primary = Color(0xFF2563EB);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color background = Color(0xFFF4F8FF);
  static const Color muted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final type = reminder['type']?.toString() ?? '';
    final repeat =
        reminder['repeat']?.toString() ?? 'No Repeat';
    final time = reminder['time'] as TimeOfDay;
    final date = reminder['date'] as DateTime;
    final isMedication = type == 'Medication';

    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: MedicationStore.medications,
      builder: (context, medications, child) {
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

        final name =
            medication?['name']?.toString() ??
            reminder['name']?.toString() ??
            '';

        final dose =
            medication?['dose']?.toString() ??
            reminder['dose']?.toString() ??
            '';

        final instructions =
            medication?['instructions']?.toString() ??
            reminder['instructions']?.toString() ??
            '';

        final title = isMedication
            ? (name.isNotEmpty ? name : 'Medication')
            : 'PEF Measurement';

        final accent = isMedication ? purple : primary;

        return Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            title: const Text(
              'Reminder Details',
              style: TextStyle(
                color: navy,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            backgroundColor: background,
            surfaceTintColor: background,
            scrolledUnderElevation: 0,
            elevation: 0,
            foregroundColor: navy,
          ),
          body: Stack(
            children: [
              Positioned(
                top: -90,
                right: -90,
                child: _backgroundCircle(
                  260,
                  const Color(0xFFDCEBFF),
                ),
              ),
              Positioned(
                bottom: -90,
                left: -90,
                child: _backgroundCircle(
                  240,
                  isMedication
                      ? const Color(0xFFECE3FF)
                      : const Color(0xFFD9E8FF),
                ),
              ),
              ScrollConfiguration(
                behavior: const _NoStretchScrollBehavior(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    22,
                    20,
                    35,
                  ),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.93,
                      ),
                      borderRadius:
                          BorderRadius.circular(26),
                      border: Border.all(
                        color: isMedication
                            ? const Color(0xFFE8DDFC)
                            : const Color(0xFFDDE9FC),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: navy.withValues(
                            alpha: 0.07,
                          ),
                          blurRadius: 23,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // Gradient header
                        _buildHeader(
                          title: title,
                          type: type,
                          isMedication: isMedication,
                        ),

                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              if (isMedication) ...[
                                _detailRow(
                                  icon: LucideIcons.pill,
                                  label: 'Dose',
                                  value: dose.isNotEmpty
                                      ? dose
                                      : 'Not provided',
                                  accent: accent,
                                  isMedication: true,
                                ),
                                _divider(),

                                if (instructions.trim().isNotEmpty) ...[
                                  _detailRow(
                                    icon: Icons.notes_rounded,
                                    label: 'Instructions',
                                    value: instructions,
                                    accent: accent,
                                    isMedication: true,
                                  ),
                                  _divider(),
                                ],
                              ],

                              _detailRow(
                                icon: Icons.access_time_rounded,
                                label: 'Scheduled Time',
                                value: time.format(context),
                                accent: accent,
                                isMedication: isMedication,
                              ),

                              _divider(),

                              _detailRow(
                                icon: Icons.repeat_rounded,
                                label: 'Repeat',
                                value: repeat,
                                accent: accent,
                                isMedication: isMedication,
                              ),

                              _divider(),

                              _detailRow(
                                icon: Icons.calendar_month_outlined,
                                label: 'Start Date',
                                value:
                                    '${date.day}/${date.month}/${date.year}',
                                accent: accent,
                                isMedication: isMedication,
                              ),

                              const SizedBox(height: 27),

                              // Edit reminder
                              Container(
                                width: double.infinity,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient:
                                      const LinearGradient(
                                    colors: [
                                      Color(0xFF2563EB),
                                      Color(0xFF3B82F6),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withValues(
                                        alpha: 0.18,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius.circular(15),
                                    onTap: () =>
                                        _editReminder(context, date),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.edit_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 9),
                                        Text(
                                          'Edit Reminder',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight:
                                                FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 13),

                              // Delete reminder
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      _deleteReminder(context),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 20,
                                  ),
                                  label: const Text(
                                    'Delete Reminder',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        const Color(0xFFEF4444),
                                    side: const BorderSide(
                                      color: Color(0xFFFFB4BF),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader({
    required String title,
    required String type,
    required bool isMedication,
  }) {
    final accent = isMedication ? purple : primary;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isMedication
              ? const [
                  Color(0xFFFFFFFF),
                  Color(0xFFF3ECFF),
                  Color(0xFFE8DCFF),
                ]
              : const [
                  Color(0xFFFFFFFF),
                  Color(0xFFEAF3FF),
                  Color(0xFFD5E8FF),
                ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -48,
            bottom: -70,
            child: IgnorePointer(
              child: Container(
                width: 170,
                height: 130,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.09),
                  borderRadius:
                      BorderRadius.circular(90),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 28,
            ),
            child: Row(
              children: [
                Container(
                  width: 67,
                  height: 67,
                  decoration: BoxDecoration(
                    color: isMedication
                        ? const Color(0xFFE9DBFF)
                        : const Color(0xFFDAEAFE),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Icon(
                    isMedication
                        ? LucideIcons.pill
                        : Icons.air_rounded,
                    color: accent,
                    size: 35,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withValues(
                            alpha: 0.11,
                          ),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          isMedication
                              ? 'Medication'
                              : 'PEF Measurement',
                          style: TextStyle(
                            color: accent,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color accent,
    required bool isMedication,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: isMedication
                  ? const Color(0xFFF1EAFF)
                  : const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              size: 21,
              color: accent,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFE6EAF2),
    );
  }

  Future<void> _editReminder(
    BuildContext context,
    DateTime date,
  ) async {
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

    if (updatedReminder == null) return;

    await ReminderStore.update(
      reminder,
      updatedReminder,
    );

    if (!context.mounted) return;

    Navigator.pop(context);
  }

  Future<void> _deleteReminder(BuildContext context) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.48),
      builder: (sheetContext) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            24 + MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFFDFEFF),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8ED),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  size: 43,
                  color: Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Delete this reminder?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: navy,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you sure you want to delete this reminder? '
                'This action can’t be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () =>
                            Navigator.pop(sheetContext, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: navy,
                          side: const BorderSide(
                            color: Color(0xFFCAD9F5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pop(sheetContext, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF3349),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                        ),
                        label: const Text(
                          'Delete Reminder',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    await ReminderStore.delete(reminder);

    if (!context.mounted) return;
    Navigator.pop(context);
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

class _NoStretchScrollBehavior
    extends MaterialScrollBehavior {
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
