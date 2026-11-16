
import 'package:flutter/material.dart';
import '../data/medication_store.dart';
import 'add_medication_page.dart';

class MyMedicationsPage extends StatelessWidget {
  const MyMedicationsPage({super.key});

  static const Color blue = Color(0xFF2563EB);
  static const Color navy = Color(0xFF142A55);
  static const Color background = Color(0xFFF7F9FD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('My Medications'),
        backgroundColor: background,
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: MedicationStore.medications,
        builder: (context, medications, child) {
          if (medications.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.medication_outlined,
                      color: blue,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No medications added yet',
                      style: TextStyle(
                        color: navy,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add your medications to manage them '
                      'and set reminders.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: medications.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final medication = medications[index];

              final name = medication['name']?.toString() ?? '';
              final dose = medication['dose']?.toString() ?? '';
              final instructions =
                  medication['instructions']?.toString() ?? '';

             
return InkWell(
  borderRadius: BorderRadius.circular(18),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMedicationPage(
          existingMedication: medication,
        ),
      ),
    );
  },
  child: Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundColor: Color(0xFFE8F2FF),
          child: Icon(
            Icons.medication_outlined,
            color: blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                dose.isEmpty
                    ? 'Dose not provided'
                    : 'Dose: $dose',
                style: const TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
              if (instructions.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  instructions,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
        const Icon(
          Icons.chevron_right,
          color: Colors.blueGrey,
        ),
      ],
    ),
  ),
);
},
);
},
),
floatingActionButton: FloatingActionButton.extended(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMedicationPage(),
      ),
    );
  },
  icon: const Icon(Icons.add),
  label: const Text('Add Medication'),
),
    );
  }
}


