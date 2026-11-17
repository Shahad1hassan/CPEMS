
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../schedule/pages/my_schedule_page.dart';
import '../../schedule/pages/reminder_details_page.dart';
import '../../schedule/data/reminder_store.dart';
import '../../profile/data/patient_store.dart';
import '../../profile/data/medication_store.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    this.patientName,
  });

  final String? patientName;

  static const Color primary = Color(0xFF2563EB);
  static const Color navy = Color(0xFF142A55);
  static const Color background = Color(0xFFF4F8FF);
  static const Color muted = Color(0xFF64748B);
  static const Color medicationPurple = Color(0xFF8B5CF6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
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
              top: 340,
              left: -100,
              child: _backgroundCircle(
                220,
                const Color(0xFFE3F2FF),
              ),
            ),
            Positioned(
              bottom: -75,
              right: -75,
              child: _backgroundCircle(
                210,
                const Color(0xFFE7EDFF),
              ),
            ),

            ScrollConfiguration(
              behavior: const NoStretchScrollBehavior(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  20, 22, 20, 32,
                ),
                children: [
  _buildBrandHeader(),

  const SizedBox(height: 24),

  _buildWelcomeSection(),

  const SizedBox(height: 24),

  _buildHealthTip(),

                  const SizedBox(height: 20),

                  _buildPEFCard(),

                  const SizedBox(height: 22),

                  _buildScheduleCard(context),

                  const SizedBox(height: 26),

                  const Text(
                    'Quick Access',
                    style: TextStyle(
                      color: navy,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _quickAction(
                          title: 'My Doctor',
                          subtitle: 'Care & follow-up',
                          icon: Icons.medical_services_outlined,
                          decorationIcon: LucideIcons.stethoscope,
                          darkColor: const Color(0xFF1D4ED8),
                          textColor: navy,
                          gradientColors: const [
                            Color(0xFFF0F7FF),
                            Color(0xFFD4E7FF),
                            Color(0xFFBCD8FF),
                          ],
                          waveColor: const Color(0xFF77B3FF),
                          onTap: null,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _quickAction(
                          title: 'Emergency',
                          subtitle: 'Get help quickly',
                          icon: Icons.health_and_safety_outlined,
                          decorationIcon: Icons.monitor_heart_outlined,
                          darkColor: const Color(0xFFE11D48),
                          textColor: const Color(0xFF881337),
                          gradientColors: const [
                            Color(0xFFFFF5F6),
                            Color(0xFFFFE1E7),
                            Color(0xFFFFC7D2),
                          ],
                          waveColor: const Color(0xFFFF8FA6),
                          onTap: null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
Widget _buildBrandHeader() {
  return Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/cpems_logo.png',
          width: 36,
          height: 36,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 10),
        const Text(
          'CPEMS',
          style: TextStyle(
            color: primary,
            fontSize: 23,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ],
    ),
  );
}
  Widget _buildWelcomeSection() {
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder<String>(
            valueListenable: PatientStore.name,
            builder: (context, name, child) {
              final savedName = name.trim();
              final fallbackName = patientName?.trim() ?? '';

              final fullName = savedName.isNotEmpty
                  ? savedName
                  : fallbackName;

              final firstName = fullName.isNotEmpty
                  ? fullName.split(RegExp(r'\s+')).first
                  : 'there';

              return Text(
                'Hi $firstName! 👋',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: navy,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 8),

        _headerIcon(
          Icons.notifications_none_rounded,
          'Notifications',
        ),

        const SizedBox(width: 7),

        _headerIcon(
          Icons.settings_outlined,
          'Settings',
        ),
      ],
    );
  }

  Widget _headerIcon(
    IconData icon,
    String tooltip,
  ) {
    return Container(
      width: 41,
      height: 41,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: primary,
          size: 21,
        ),
        onPressed: null,
      ),
    );
  }

  Widget _buildHealthTip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFE5B0),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.lightbulb_rounded,
            color: Color(0xFFE8A323),
            size: 23,
          ),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'Follow your measurement instructions '
              'for consistent readings.',
              style: TextStyle(
                color: Color(0xFF8B6930),
                fontSize: 12,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPEFCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1D4ED8),
            Color(0xFF3B82F6),
            Color(0xFF69B5FF),
          ],
        ),
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.20),
            blurRadius: 19,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -55,
            right: -35,
            child: Container(
              width: 155,
              height: 155,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          Positioned(
            bottom: -105,
            right: 40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.055),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(19),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Latest PEF Reading',
                        style: TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w700,
),
                      ),
                    ),

                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.17),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.air_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                const Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '--',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 43,
                        height: 1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 9),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        'L/min',
                        style: TextStyle(
                          color: Color(0xFFE1F0FF),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                      SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'No measurements recorded yet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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

  // Compact versions of the cards used on My Schedule.
  Widget _buildScheduleCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDDE7FA)),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.045),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: navy,
                size: 23,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "Today's Schedule",
                  style: TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MySchedulePage(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: primary,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See all',
                      style: TextStyle(
                        color: primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(Icons.chevron_right_rounded, size: 17),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFD9E1F0),
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: ReminderStore.reminders,
            builder: (context, reminders, child) {
              return ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: MedicationStore.medications,
                builder: (context, medications, child) {
                  final todayReminders =
                      ReminderStore.forDate(DateTime.now());

                  if (todayReminders.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'No reminders scheduled for today',
                          style: TextStyle(color: muted, fontSize: 13),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      for (int i = 0; i < todayReminders.length; i++) ...[
                        if (i > 0) const SizedBox(height: 11),
                        _buildReminderItem(
                          context,
                          todayReminders[i],
                          medications,
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
    );
  }

  Widget _buildReminderItem(
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
        reminder['name']?.toString() ?? '';
    final dose = medication?['dose']?.toString() ??
        reminder['dose']?.toString() ?? '';
    final repeat = reminder['repeat']?.toString() ?? 'No Repeat';
    final time = reminder['time'] as TimeOfDay;
    final title = isMedication && name.isNotEmpty
        ? name
        : 'PEF Measurement';

    final accent = isMedication ? medicationPurple : primary;
    final iconBackground = isMedication
        ? const Color(0xFFEFE3FF)
        : const Color(0xFFE3EFFF);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isMedication
              ? const [Color(0xFFFFFFFF), Color(0xFFF8F3FF), Color(0xFFEFE4FF)]
              : const [Color(0xFFFFFFFF), Color(0xFFF4F9FF), Color(0xFFE3EEFF)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isMedication
              ? const Color(0xFFDCC5FF)
              : const Color(0xFFC9DCFF),
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.055),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReminderDetailsPage(
                  reminder: reminder,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            child: Row(
              children: [
                _smallIcon(
                  isMedication ? LucideIcons.pill : Icons.air_rounded,
                  accent,
                  iconBackground,
                ),
                const SizedBox(width: 10),
                Container(
                  width: 2,
                  height: isMedication ? 62 : 49,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.42),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (isMedication && dose.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.pill,
                              size: 13,
                              color: muted,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'Dose: $dose',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: muted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: muted,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              isMedication
                                  ? '${time.format(context)} • $repeat'
                                  : '${time.format(context)} • Use your CPEMS device',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF52627E),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 21,
                  color: Color(0xFF536681),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _smallIcon(
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 21,
      ),
    );
  }

  // Redesigned Doctor and Emergency tiles.
  static Widget _quickAction({
    required IconData icon,
    required IconData decorationIcon,
    required String title,
    required String subtitle,
    required Color darkColor,
    required Color textColor,
    required List<Color> gradientColors,
    required Color waveColor,
    required VoidCallback? onTap,
  }) {
    return Container(
      height: 195,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: darkColor.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(23),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(23),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(23),
            child: Stack(
              children: [
                // Large translucent decorative medical icon.
                Positioned(
                  top: 12,
                  right: -14,
                  child: IgnorePointer(
                    child: Transform.rotate(
                      angle: -0.2,
                      child: Icon(
                        decorationIcon,
                        size: 95,
                        color: darkColor.withValues(
                          alpha: 0.16,
                        ),
                      ),
                    ),
                  ),
                ),

                // Decorative curved background.
                Positioned(
                  bottom: -72,
                  left: -65,
                  child: IgnorePointer(
                    child: Container(
                      width: 215,
                      height: 145,
                      decoration: BoxDecoration(
                        color: waveColor.withValues(
                          alpha: 0.15,
                        ),
                        borderRadius: BorderRadius.circular(95),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: -95,
                  right: -65,
                  child: IgnorePointer(
                    child: Transform.rotate(
                      angle: -0.28,
                      child: Container(
                        width: 205,
                        height: 150,
                        decoration: BoxDecoration(
                          color: waveColor.withValues(
                            alpha: 0.22,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ),

                // Foreground content.
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: darkColor.withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          size: 26,
                          color: darkColor,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: textColor.withValues(alpha: 0.75),
                        ),
                      ),

                      const SizedBox(height: 13),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: darkColor,
                            size: 19,
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
    );
  }
}

class NoStretchScrollBehavior extends MaterialScrollBehavior {
  const NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
