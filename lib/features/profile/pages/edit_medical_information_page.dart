import 'package:flutter/material.dart';

import '../data/medical_information_store.dart';

class EditMedicalInformationPage extends StatefulWidget {
  const EditMedicalInformationPage({super.key});

  @override
  State<EditMedicalInformationPage> createState() =>
      _EditMedicalInformationPageState();
}

class _EditMedicalInformationPageState
    extends State<EditMedicalInformationPage> {
  static const Color blue = Color(0xFF2563EB);
  static const Color navy = Color(0xFF142A55);
  static const Color background = Color(0xFFF4F8FF);
  static const Color muted = Color(0xFF64748B);
  static const Color outline = Color(0xFFDCE6F5);

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _contactNameController;
  late final TextEditingController _contactPhoneController;

  String? _diagnosis;
  DateTime? _diagnosisDate;
  late Set<String> _selectedTriggers;

  final List<String> _triggerOptions = const [
    'Dust',
    'Smoke',
    'Pollen',
    'Exercise',
    'Cold Air',
    'Respiratory Infections',
    'Strong Scents',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _diagnosis = MedicalInformationStore.asthmaDiagnosis.value;
    _diagnosisDate = MedicalInformationStore.diagnosisDate.value;
    _selectedTriggers = {...MedicalInformationStore.asthmaTriggers.value};
    _contactNameController = TextEditingController(
      text: MedicalInformationStore.emergencyContactName.value,
    );
    _contactPhoneController = TextEditingController(
      text: MedicalInformationStore.emergencyContactPhone.value,
    );
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDiagnosisDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _diagnosisDate ?? DateTime(now.year - 1),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() => _diagnosisDate = picked);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    MedicalInformationStore.update(
      asthmaDiagnosis: _diagnosis,
      diagnosisDate: _diagnosisDate,
      asthmaTriggers: _selectedTriggers.toList(),
      emergencyContactName: _contactNameController.text,
      emergencyContactPhone: _contactPhoneController.text,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Edit Medical Information',
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
            top: -100,
            right: -100,
            child: _softCircle(260, const Color(0xFFD9EAFE)),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: _softCircle(260, const Color(0xFFE0E9FF)),
          ),
          ScrollConfiguration(
            behavior: const _NoStretchScrollBehavior(),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 36),
                children: [
                  _introBanner(),
                  const SizedBox(height: 26),
                  _sectionTitle(
                    'Asthma Information',
                    Icons.medical_information_outlined,
                  ),
                  const SizedBox(height: 14),
                  _fieldLabel('Asthma Diagnosis'),
                  const SizedBox(height: 9),
                  DropdownButtonFormField<String>(
                    key: ValueKey(_diagnosis),
                    initialValue: _diagnosis,
                    isExpanded: true,
                    hint: const Text('Select asthma diagnosis'),
                    decoration: _inputDecoration(
                      Icons.medical_information_outlined,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Diagnosed',
                        child: Text('Diagnosed with asthma'),
                      ),
                      DropdownMenuItem(
                        value: 'Not Diagnosed',
                        child: Text('Not diagnosed'),
                      ),
                      DropdownMenuItem(
                        value: 'Unsure',
                        child: Text('Unsure'),
                      ),
                    ],
                    onChanged: (value) => setState(() => _diagnosis = value),
                  ),
                  const SizedBox(height: 18),
                  _fieldLabel('Diagnosis Date'),
                  const SizedBox(height: 9),
                  _dateField(),
                  const SizedBox(height: 29),
                  _sectionTitle('Asthma Triggers', Icons.air_rounded),
                  const SizedBox(height: 8),
                  const Text(
                    'Select any triggers that apply to you.',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                  const SizedBox(height: 13),
                  _triggersCard(),
                  const SizedBox(height: 29),
                  _sectionTitle('Emergency Contact', Icons.phone_in_talk_outlined),
                  const SizedBox(height: 14),
                  _fieldLabel('Contact Name'),
                  const SizedBox(height: 9),
                  TextFormField(
                    controller: _contactNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _inputDecoration(
                      Icons.person_outline_rounded,
                      hint: 'Enter contact name',
                    ),
                  ),
                  const SizedBox(height: 18),
                  _fieldLabel('Phone Number'),
                  const SizedBox(height: 9),
                  TextFormField(
                    controller: _contactPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration(
                      Icons.phone_outlined,
                      hint: 'Enter contact phone number',
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: blue.withValues(alpha: 0.18),
                          blurRadius: 13,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _save,
                        borderRadius: BorderRadius.circular(15),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_rounded, color: Colors.white),
                            SizedBox(width: 9),
                            Text(
                              'Save Changes',
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
                  const SizedBox(height: 16),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded, size: 17, color: muted),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This prototype stores information temporarily '
                          'during the current app session. Use test data only.',
                          style: TextStyle(color: muted, fontSize: 11, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _introBanner() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFEDF6FF),
            Color(0xFFB9DAFF),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.055),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -55,
            bottom: -85,
            child: Container(
              width: 180,
              height: 150,
              decoration: BoxDecoration(
                color: blue.withValues(alpha: 0.09),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.health_and_safety_outlined,
                    color: blue,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 13),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Update Your Health Information',
                        style: TextStyle(
                          color: navy,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Keep your respiratory health details up to date.',
                        style: TextStyle(color: muted, fontSize: 11, height: 1.4),
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

  Widget _dateField() {
    final dateLabel = _diagnosisDate == null
        ? 'Select date'
        : '${_diagnosisDate!.day}/${_diagnosisDate!.month}/${_diagnosisDate!.year}';
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: _selectDiagnosisDate,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
          decoration: BoxDecoration(
            border: Border.all(color: outline),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_month_outlined, color: navy, size: 21),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  dateLabel,
                  style: TextStyle(
                    color: _diagnosisDate == null ? muted : navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.calendar_today_outlined, color: muted, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _triggersCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: outline),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 5,
        children: _triggerOptions.map((trigger) {
          final selected = _selectedTriggers.contains(trigger);
          return FilterChip(
            label: Text(trigger),
            selected: selected,
            showCheckmark: true,
            checkmarkColor: blue,
            selectedColor: const Color(0xFFDCEBFF),
            backgroundColor: const Color(0xFFF8FAFF),
            side: BorderSide(
              color: selected ? const Color(0xFF9EC5FF) : outline,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? blue : navy,
            ),
            onSelected: (value) {
              setState(() {
                if (value) {
                  _selectedTriggers.add(trigger);
                } else {
                  _selectedTriggers.remove(trigger);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE1EFFF),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: blue, size: 22),
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

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: navy,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  InputDecoration _inputDecoration(IconData icon, {String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: muted, fontSize: 13),
      prefixIcon: Icon(icon, color: navy, size: 21),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: blue, width: 1.4),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  static Widget _softCircle(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
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
