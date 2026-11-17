import 'package:flutter/material.dart';

import 'edit_medical_information_page.dart';
import '../data/medical_information_store.dart';

class MedicalInformationPage extends StatelessWidget {
  const MedicalInformationPage({super.key});

  static const Color blue = Color(0xFF2563EB);
  static const Color navy = Color(0xFF142A55);
  static const Color background = Color(0xFFF4F8FF);
  static const Color muted = Color(0xFF64748B);
  static const Color dividerColor = Color(0xFFE4EAF4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Medical Information',
          style: TextStyle(
            color: navy,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        foregroundColor: navy,
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -110,
            right: -110,
            child: _backgroundGlow(270, const Color(0xFFCBE3FF)),
          ),
          Positioned(
            bottom: -110,
            left: -110,
            child: _backgroundGlow(280, const Color(0xFFDEE9FF)),
          ),
          ScrollConfiguration(
            behavior: const _NoStretchScrollBehavior(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 15, 18, 35),
              children: [
                _healthHeader(),
                const SizedBox(height: 24),
                _sectionHeading(
                  icon: Icons.medical_information_outlined,
                  title: 'Asthma Information',
                ),
                const SizedBox(height: 11),
                ValueListenableBuilder<String?>(
                  valueListenable: MedicalInformationStore.asthmaDiagnosis,
                  builder: (context, diagnosis, child) {
                    return ValueListenableBuilder<DateTime?>(
                      valueListenable: MedicalInformationStore.diagnosisDate,
                      builder: (context, diagnosisDate, child) {
                        final dateLabel = diagnosisDate == null
                            ? 'Not provided'
                            : '${diagnosisDate.day}/${diagnosisDate.month}/${diagnosisDate.year}';
                        return _contentCard(
                          child: Column(
                            children: [
                              _infoRow(
                                Icons.health_and_safety_outlined,
                                'Asthma Diagnosis',
                                diagnosis?.trim().isNotEmpty == true
                                    ? diagnosis!.trim()
                                    : 'Not provided',
                              ),
                              const Divider(height: 1, color: dividerColor),
                              _infoRow(
                                Icons.calendar_month_outlined,
                                'Diagnosis Date',
                                dateLabel,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 23),
                _sectionHeading(
                  icon: Icons.air_rounded,
                  title: 'Asthma Triggers',
                ),
                const SizedBox(height: 11),
                ValueListenableBuilder<List<String>>(
                  valueListenable: MedicalInformationStore.asthmaTriggers,
                  builder: (context, triggers, child) {
                    return _contentCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        child: triggers.isEmpty
                            ? const Row(
                                children: [
                                  Icon(Icons.cloud_outlined,
                                      color: blue, size: 20),
                                  SizedBox(width: 11),
                                  Expanded(
                                    child: Text(
                                      'No triggers recorded yet',
                                      style: TextStyle(
                                        color: muted,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: triggers.map((trigger) {
                                    return Chip(
                                      avatar: const Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 17,
                                        color: blue,
                                      ),
                                      label: Text(trigger),
                                      labelStyle: const TextStyle(
                                        color: navy,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                      backgroundColor:
                                          const Color(0xFFEAF3FF),
                                      side: const BorderSide(
                                        color: Color(0xFFD9E9FF),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 23),
                _sectionHeading(
                  icon: Icons.phone_in_talk_outlined,
                  title: 'Emergency Contact',
                ),
                const SizedBox(height: 11),
                ValueListenableBuilder<String>(
                  valueListenable:
                      MedicalInformationStore.emergencyContactName,
                  builder: (context, contactName, child) {
                    return ValueListenableBuilder<String>(
                      valueListenable:
                          MedicalInformationStore.emergencyContactPhone,
                      builder: (context, contactPhone, child) {
                        return _contentCard(
                          child: Column(
                            children: [
                              _infoRow(
                                Icons.person_outline_rounded,
                                'Contact Name',
                                contactName.trim().isEmpty
                                    ? 'Not provided'
                                    : contactName.trim(),
                              ),
                              const Divider(height: 1, color: dividerColor),
                              _infoRow(
                                Icons.phone_outlined,
                                'Phone Number',
                                contactPhone.trim().isEmpty
                                    ? 'Not provided'
                                    : contactPhone.trim(),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 53,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const EditMedicalInformationPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    label: const Text('Edit Medical Information'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: blue,
                      side: const BorderSide(color: blue, width: 1.5),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F2FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded, color: blue, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This information is not a substitute for medical '
                          'advice or an emergency response service.',
                          style: TextStyle(
                            color: navy,
                            fontSize: 12,
                            height: 1.45,
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

  static Widget _healthHeader() {
    return Container(
      height: 116,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF0F8FF),
            Color(0xFFD8ECFF),
            Color(0xFFB6D9FF),
          ],
        ),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.07),
            blurRadius: 17,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -75,
            right: -30,
            child: Container(
              height: 150,
              width: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.17),
              ),
            ),
          ),
          Positioned(
            right: 14,
            top: 14,
            child: Opacity(
              opacity: 0.23,
              child: Image.asset(
                'assets/images/cpems_logo.png',
                width: 78,
                height: 78,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(17, 22, 99, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Respiratory Health',
                  style: TextStyle(
                    color: navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'View and manage your asthma information.',
                  style: TextStyle(
                    color: muted,
                    fontSize: 12,
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

  static Widget _sectionHeading({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          width: 41,
          height: 41,
          decoration: BoxDecoration(
            color: const Color(0xFFE1EFFF),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: blue, size: 23),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: navy,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _contentCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  static Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: Row(
        children: [
          Icon(icon, color: blue, size: 21),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: navy,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: muted,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _backgroundGlow(double size, Color color) {
    return IgnorePointer(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.8), color.withValues(alpha: 0)],
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
