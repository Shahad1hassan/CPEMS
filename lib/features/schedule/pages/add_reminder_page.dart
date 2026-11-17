
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../profile/data/medication_store.dart';

class AddReminderPage extends StatefulWidget {
  const AddReminderPage({
    super.key,
    required this.selectedDate,
    this.existingReminder,
  });

  final DateTime selectedDate;
  final Map<String, dynamic>? existingReminder;

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  static const Color navy = Color(0xFF142A55);
  static const Color blue = Color(0xFF2563EB);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color muted = Color(0xFF64748B);
  static const Color background = Color(0xFFF4F8FF);

  String reminderType = 'Medication';
  String repeat = 'Daily';
  int? selectedMedicationId;
  late DateTime selectedDate;
  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

  final nameController = TextEditingController();
  final doseController = TextEditingController();

  bool get isMedication => reminderType == 'Medication';
  bool get isEditing => widget.existingReminder != null;
  bool get isLegacyMedication =>
      isEditing && widget.existingReminder!['medicationId'] == null &&
      widget.existingReminder!['type'] == 'Medication';

  @override
  void initState() {
    super.initState();
    final reminder = widget.existingReminder;
    selectedDate = reminder?['date'] as DateTime? ?? widget.selectedDate;
    if (reminder != null) {
      reminderType = reminder['type']?.toString() ?? 'Medication';
      repeat = reminder['repeat']?.toString() ?? 'Daily';
      selectedTime = reminder['time'] as TimeOfDay? ?? selectedTime;
      selectedMedicationId = reminder['medicationId'] as int?;
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

  String _dateText(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && mounted) {
      setState(() => selectedTime = picked);
    }
  }

  void _save() {
    if (isMedication) {
      final isValidLegacy = isLegacyMedication &&
          selectedMedicationId == null &&
          nameController.text.trim().isNotEmpty &&
          doseController.text.trim().isNotEmpty;
      final selected = selectedMedicationId == null
          ? null
          : MedicationStore.findById(selectedMedicationId!);
      if (selected == null && !isValidLegacy) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a saved medication first.')),
        );
        return;
      }
    }

    final medication = isMedication && selectedMedicationId != null
        ? MedicationStore.findById(selectedMedicationId!)
        : null;

    Navigator.pop(context, <String, dynamic>{
      'type': reminderType,
      'date': selectedDate,
      'time': selectedTime,
      'repeat': repeat,
      'medicationId': isMedication ? selectedMedicationId : null,
      'name': isMedication
          ? (medication?['name']?.toString() ?? nameController.text.trim())
          : '',
      'dose': isMedication
          ? (medication?['dose']?.toString() ?? doseController.text.trim())
          : '',
    });
  }

  @override
  Widget build(BuildContext context) {
    final accent = isMedication ? purple : blue;
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Reminder' : 'Add Reminder',
          style: const TextStyle(
            color: navy,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        foregroundColor: navy,
        backgroundColor: background,
        surfaceTintColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: isKeyboardOpen
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.circular(15),
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
                      borderRadius: BorderRadius.circular(15),
                      onTap: _save,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.event_available_rounded,
                              color: Colors.white, size: 21),
                          const SizedBox(width: 9),
                          Text(
                            isEditing ? 'Save Changes' : 'Save Reminder',
                            style: const TextStyle(
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
            top: -110,
            right: -90,
            child: _backgroundGlow(
              isMedication ? const Color(0xFFE8DBFF) : const Color(0xFFD7E8FF),
            ),
          ),
          ScrollConfiguration(
            behavior: const _NoStretchScrollBehavior(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                _typeSelector(),
                const SizedBox(height: 20),
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(color: const Color(0xFFE6EBF4)),
                    boxShadow: [
                      BoxShadow(
                        color: navy.withValues(alpha: 0.04),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _featureHeader(accent),
                      Padding(
                        padding: const EdgeInsets.all(17),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isMedication) ...[
                              _sectionLabel('Select Medication'),
                              const SizedBox(height: 8),
                              _medicationPicker(),
                              const SizedBox(height: 17),
                              _medicationSummary(),
                              const SizedBox(height: 21),
                            ],
                            _sectionLabel('Date'),
                            const SizedBox(height: 8),
                            _selectionField(
                              leading: Icons.calendar_month_outlined,
                              text: _dateText(selectedDate),
                              trailing: Icons.calendar_today_outlined,
                              onTap: _pickDate,
                            ),
                            const SizedBox(height: 19),
                            _sectionLabel('Time'),
                            const SizedBox(height: 8),
                            _selectionField(
                              leading: Icons.access_time_rounded,
                              text: selectedTime.format(context),
                              trailing: Icons.keyboard_arrow_down_rounded,
                              onTap: _pickTime,
                            ),
                            const SizedBox(height: 19),
                            _sectionLabel('Repeat'),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              key: ValueKey('repeat-$repeat'),
                              initialValue: repeat,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded),
                              decoration: _fieldDecoration(
                                prefixIcon: const Icon(
                                  Icons.repeat_rounded,
                                  color: muted,
                                  size: 21,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Daily', child: Text('Daily')),
                                DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                                DropdownMenuItem(
                                  value: 'No Repeat',
                                  child: Text('No Repeat'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) setState(() => repeat = value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isKeyboardOpen) ...[
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: _save,
                    child: Text(isEditing ? 'Save Changes' : 'Save Reminder'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeSelector() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFE8EDF7)),
      ),
      child: Row(
        children: [
          _typeOption('PEF Measurement', Icons.air_rounded, blue),
          const SizedBox(width: 7),
          _typeOption('Medication', LucideIcons.pill, purple),
        ],
      ),
    );
  }

  Widget _typeOption(String type, IconData icon, Color accent) {
    final selected = reminderType == type;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => reminderType = type),
          borderRadius: BorderRadius.circular(15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(
                      colors: [accent, accent.withValues(alpha: 0.85)],
                    )
                  : null,
              color: selected ? null : const Color(0xFFF7F9FD),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: selected ? Colors.white : accent, size: 22),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    type,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? Colors.white : navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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

  Widget _featureHeader(Color accent) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isMedication
              ? const [Color(0xFFFBF9FF), Color(0xFFECE0FF)]
              : const [Color(0xFFF8FBFF), Color(0xFFDDEBFF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25,
            bottom: -50,
            child: Container(
              width: 135,
              height: 100,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(70),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isMedication ? LucideIcons.pill : Icons.air_rounded,
                    color: accent,
                    size: 29,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminderType,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isMedication
                            ? 'Choose a saved medication and set its reminder.'
                            : 'Schedule your peak flow measurement.',
                        style: const TextStyle(
                          color: muted,
                          fontSize: 12,
                          height: 1.35,
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

  Widget _medicationPicker() {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: MedicationStore.medications,
      builder: (context, medications, child) {
        final selectedExists = medications.any(
          (medication) => medication['id'] == selectedMedicationId,
        );
        return DropdownButtonFormField<int>(
          key: ValueKey('medication-$selectedMedicationId-$selectedExists'),
          initialValue: selectedExists ? selectedMedicationId : null,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          decoration: _fieldDecoration(
            prefixIcon: const Icon(
              LucideIcons.pill,
              color: purple,
              size: 21,
            ),
          ),
          hint: Text(
            medications.isEmpty
                ? 'No saved medications available'
                : 'Choose a saved medication',
            style: const TextStyle(color: muted, fontSize: 13),
          ),
          items: medications.map((medication) {
            return DropdownMenuItem<int>(
              value: medication['id'] as int,
              child: Text(
                medication['name']?.toString() ?? '',
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: medications.isEmpty
              ? null
              : (id) {
                  final medication = id == null
                      ? null
                      : MedicationStore.findById(id);
                  setState(() {
                    selectedMedicationId = id;
                    if (medication != null) {
                      nameController.text = medication['name']?.toString() ?? '';
                      doseController.text = medication['dose']?.toString() ?? '';
                    }
                  });
                },
        );
      },
    );
  }

  Widget _medicationSummary() {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: MedicationStore.medications,
      builder: (context, medications, child) {
        Map<String, dynamic>? selected;
        for (final medication in medications) {
          if (medication['id'] == selectedMedicationId) {
            selected = medication;
            break;
          }
        }

        if (selected == null && !isLegacyMedication) {
          return const Text(
            'Medication details are managed in My Medications.',
            style: TextStyle(color: muted, fontSize: 12),
          );
        }

        if (selected == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Legacy Reminder',
                style: TextStyle(
                  color: navy,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: _fieldDecoration(label: 'Medication Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: doseController,
                decoration: _fieldDecoration(label: 'Dose'),
              ),
            ],
          );
        }

        final name = selected['name']?.toString() ?? '';
        final dose = selected['dose']?.toString() ?? '';
        final instructions = selected['instructions']?.toString() ?? '';
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F4FF),
            border: Border.all(color: const Color(0xFFEBE0FC)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(color: navy, fontWeight: FontWeight.w700),
              ),
              if (dose.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('Dose: $dose', style: const TextStyle(color: muted, fontSize: 12)),
              ],
              if (instructions.trim().isNotEmpty) ...[
                const SizedBox(height: 5),
                Text(
                  'Instructions: $instructions',
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _selectionField({
    required IconData leading,
    required String text,
    required IconData trailing,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFDDE5F1)),
          ),
          child: Row(
            children: [
              Icon(leading, color: muted, size: 21),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(trailing, color: muted, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({String? label, Widget? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDDE5F1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDDE5F1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: isMedication ? purple : blue, width: 1.5),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: navy,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  static Widget _backgroundGlow(Color color) {
    return IgnorePointer(
      child: Container(
        height: 250,
        width: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.75), color.withValues(alpha: 0)],
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
  ) => child;
}
