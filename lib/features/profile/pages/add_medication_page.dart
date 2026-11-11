
import 'package:flutter/material.dart';
import '../data/medication_store.dart';

class AddMedicationPage extends StatefulWidget {
  const AddMedicationPage({
    super.key,
    this.existingMedication,
  });

  final Map<String, dynamic>? existingMedication;

  @override
  State<AddMedicationPage> createState() =>
      _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  final _instructionsController = TextEditingController();

@override
void initState() {
  super.initState();

  final medication = widget.existingMedication;

  if (medication != null) {
    _nameController.text = medication['name']?.toString() ?? '';
    _doseController.text = medication['dose']?.toString() ?? '';
    _instructionsController.text =
        medication['instructions']?.toString() ?? '';
  }
}
  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  
void _saveMedication() {
  if (!_formKey.currentState!.validate()) return;

  final existingMedication = widget.existingMedication;

  if (existingMedication == null) {
    // Add a new medication
    MedicationStore.add(
      name: _nameController.text,
      dose: _doseController.text,
      instructions: _instructionsController.text,
    );
  } else {
    // Update an existing medication
    final id = existingMedication['id'] as int;

    MedicationStore.update(
      id: id,
      name: _nameController.text,
      dose: _doseController.text,
      instructions: _instructionsController.text,
    );
  }

  Navigator.pop(context);
}


  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF7F9FD);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
  widget.existingMedication == null
      ? 'Add Medication'
      : 'Edit Medication',
),
        backgroundColor: background,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Medication Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF142A55),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter medication details from your prescribed treatment plan.',
              style: TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Medication Name',
                hintText: 'Enter medication name',
                prefixIcon: Icon(Icons.medication_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the medication name';
                }
                return null;
              },
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: _doseController,
              decoration: const InputDecoration(
                labelText: 'Prescribed Dose',
                hintText: 'Enter the dose from your prescription',
                prefixIcon: Icon(Icons.medical_services_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the prescribed dose';
                }
                return null;
              },
            ),

            const SizedBox(height: 18),

            TextFormField(
              controller: _instructionsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Instructions (Optional)',
                hintText: 'Enter instructions from your healthcare provider',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _saveMedication,
              child: Text(
  widget.existingMedication == null
      ? 'Save Medication'
      : 'Save Changes',
),
            ),

            const SizedBox(height: 12),

if (widget.existingMedication != null) ...[
  OutlinedButton.icon(
    onPressed: () async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Delete Medication?'),
          content: const Text(
            'Are you sure you want to delete this medication?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

      if (confirm != true || !context.mounted) return;

      final id = widget.existingMedication!['id'] as int;
      MedicationStore.delete(id);

      Navigator.pop(context);
    },
    icon: const Icon(
      Icons.delete_outline,
      color: Colors.red,
    ),
    label: const Text(
      'Delete Medication',
      style: TextStyle(color: Colors.red),
    ),
  ),
  const SizedBox(height: 12),
],

            const Text(
              'For prototype testing only. Use fictional data, not real prescriptions.',
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
