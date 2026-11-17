import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../data/medication_store.dart';
import 'add_medication_page.dart';

class MyMedicationsPage extends StatelessWidget {
  const MyMedicationsPage({super.key});

  static const Color blue = Color(0xFF2563EB);
  static const Color navy = Color(0xFF142A55);
  static const Color background = Color(0xFFF4F8FF);
  static const Color muted = Color(0xFF64748B);
  static const Color purple = Color(0xFF8B5CF6);

  void _openMedication(BuildContext context, Map<String, dynamic>? medication) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddMedicationPage(existingMedication: medication),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'My Medications',
          style: TextStyle(color: navy, fontSize: 22, fontWeight: FontWeight.w800),
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
            top: -100,
            right: -100,
            child: _glow(260, const Color(0xFFD9EAFE)),
          ),
          Positioned(
            bottom: -95,
            left: -95,
            child: _glow(250, const Color(0xFFE3EDFF)),
          ),
          ScrollConfiguration(
            behavior: const _NoStretchScrollBehavior(),
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: MedicationStore.medications,
              builder: (context, medications, _) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
                  children: [
                    _header(),
                    const SizedBox(height: 24),
                    if (medications.isEmpty)
                      _emptyState()
                    else
                      ...medications.map((medication) => Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: _medicationCard(context, medication),
                          )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: background,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: blue.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _openMedication(context, null),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, color: Colors.white, size: 23),
                    SizedBox(width: 8),
                    Text(
                      'Add Medication',
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
    );
  }

  static Widget _header() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF5FAFF), Color(0xFFDDEEFF), Color(0xFFBBD9FF)],
        ),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.055),
            blurRadius: 17,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -45,
            bottom: -90,
            child: Container(
              height: 170,
              width: 180,
              decoration: BoxDecoration(
                color: blue.withValues(alpha: 0.075),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(19),
            child: Row(
              children: [
                Container(
                  width: 61,
                  height: 61,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.pill, color: blue, size: 30),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Medications',
                        style: TextStyle(
                          color: navy,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Manage your current medications and doses.',
                        style: TextStyle(color: muted, fontSize: 12, height: 1.4),
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

  static Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8EDF8)),
      ),
      child: const Column(
        children: [
          Icon(LucideIcons.pill, color: purple, size: 40),
          SizedBox(height: 14),
          Text(
            'No medications added yet',
            style: TextStyle(color: navy, fontSize: 17, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8),
          Text(
            'Add your medications to manage them and set reminders.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _medicationCard(BuildContext context, Map<String, dynamic> medication) {
    final name = medication['name']?.toString() ?? '';
    final dose = medication['dose']?.toString() ?? '';
    final instructions = medication['instructions']?.toString() ?? '';

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF9FBFF), Color(0xFFF4F0FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7E7F5)),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.045),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openMedication(context, medication),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 49,
                  width: 49,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1E8FF),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(LucideIcons.pill, color: purple, size: 26),
                ),
                const SizedBox(width: 13),
                Container(
                  height: 52,
                  width: 2,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCC9FB),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dose.isEmpty ? 'Dose not provided' : 'Dose: $dose',
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                      if (instructions.trim().isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          instructions,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: muted, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded, color: Color(0xFF7E8DA3)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _glow(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.85), color.withValues(alpha: 0)],
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
