
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

    _diagnosis =
        MedicalInformationStore.asthmaDiagnosis.value;
    _diagnosisDate =
        MedicalInformationStore.diagnosisDate.value;

    _selectedTriggers = {
      ...MedicalInformationStore.asthmaTriggers.value,
    };

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

    if (picked != null) {
      setState(() {
        _diagnosisDate = picked;
      });
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
    const blue = Color(0xFF2563EB);
    const background = Color(0xFFF7F9FD);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Edit Medical Information'),
        backgroundColor: background,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Asthma Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _diagnosis,
              decoration: const InputDecoration(
                labelText: 'Asthma Diagnosis',
                prefixIcon:
                    Icon(Icons.medical_information_outlined),
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
              onChanged: (value) {
                setState(() => _diagnosis = value);
              },
            ),

            const SizedBox(height: 16),

            ListTile(
              leading: const Icon(
                Icons.calendar_month_outlined,
                color: blue,
              ),
              title: const Text('Diagnosis Date'),
              subtitle: Text(
                _diagnosisDate == null
                    ? 'Not provided'
                    : '${_diagnosisDate!.day}/${_diagnosisDate!.month}/${_diagnosisDate!.year}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _selectDiagnosisDate,
            ),

            const SizedBox(height: 28),

            const Text(
              'Asthma Triggers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              'Select any triggers that apply to you.',
              style: TextStyle(color: Colors.blueGrey),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _triggerOptions.map((trigger) {
                final selected =
                    _selectedTriggers.contains(trigger);

                return FilterChip(
                  label: Text(trigger),
                  selected: selected,
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

            const SizedBox(height: 28),

            const Text(
              'Emergency Contact',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _contactNameController,
              decoration: const InputDecoration(
                labelText: 'Contact Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _contactPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _save,
              child: const Text('Save Changes'),
            ),

            const SizedBox(height: 12),

            const Text(
              'This prototype stores information temporarily '
              'during the current app session. Use test data only.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
