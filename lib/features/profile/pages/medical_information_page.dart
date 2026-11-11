
import 'package:flutter/material.dart';
import 'edit_medical_information_page.dart';
import '../data/medical_information_store.dart';

class MedicalInformationPage extends StatelessWidget {
  const MedicalInformationPage({super.key});

  static const Color blue = Color(0xFF2563EB);
  static const Color navy = Color(0xFF142A55);
  static const Color background = Color(0xFFF7F9FD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Medical Information'),
        backgroundColor: background,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Your respiratory health information',
            style: TextStyle(color: Colors.blueGrey),
          ),
          const SizedBox(height: 24),

          _sectionTitle('Asthma Information'),
          const SizedBox(height: 12),
          
ValueListenableBuilder<String?>(
  valueListenable: MedicalInformationStore.asthmaDiagnosis,
  builder: (context, diagnosis, child) {
    return ValueListenableBuilder<DateTime?>(
      valueListenable: MedicalInformationStore.diagnosisDate,
      builder: (context, diagnosisDate, child) {
        final formattedDate = diagnosisDate == null
            ? 'Not provided'
            : '${diagnosisDate.day}/${diagnosisDate.month}/${diagnosisDate.year}';

        return _infoCard(
          children: [
            _infoRow(
              Icons.medical_information_outlined,
              'Asthma Diagnosis',
              diagnosis ?? 'Not provided',
            ),
            const Divider(height: 24),
            _infoRow(
              Icons.calendar_month_outlined,
              'Diagnosis Date',
              formattedDate,
            ),
          ],
        );
      },
    );
  },
),


          const SizedBox(height: 24),

          _sectionTitle('Asthma Triggers'),
          const SizedBox(height: 12),
         
ValueListenableBuilder<List<String>>(
  valueListenable: MedicalInformationStore.asthmaTriggers,
  builder: (context, triggers, child) {
    return _infoCard(
      children: [
        if (triggers.isEmpty)
          const Text(
            'No triggers recorded yet',
            style: TextStyle(color: Colors.blueGrey),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: triggers.map((trigger) {
              return Chip(
                avatar: const Icon(
                  Icons.check_circle_outline,
                  color: blue,
                  size: 18,
                ),
                label: Text(trigger),
                backgroundColor: const Color(0xFFE8F2FF),
                side: BorderSide.none,
              );
            }).toList(),
          ),
      ],
    );
  },
),


          const SizedBox(height: 24),

          _sectionTitle('Emergency Contact'),
          const SizedBox(height: 12),
          
ValueListenableBuilder<String>(
  valueListenable:
      MedicalInformationStore.emergencyContactName,
  builder: (context, contactName, child) {
    return ValueListenableBuilder<String>(
      valueListenable:
          MedicalInformationStore.emergencyContactPhone,
      builder: (context, contactPhone, child) {
        return _infoCard(
          children: [
            _infoRow(
              Icons.person_outline,
              'Contact Name',
              contactName.trim().isEmpty
                  ? 'Not provided'
                  : contactName,
            ),
            const Divider(height: 24),
            _infoRow(
              Icons.phone_outlined,
              'Phone Number',
              contactPhone.trim().isEmpty
                  ? 'Not provided'
                  : contactPhone,
            ),
          ],
        );
      },
    );
  },
),

const SizedBox(height: 24),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const EditMedicalInformationPage(),
        ),
      );
    },
    icon: const Icon(Icons.edit_outlined),
    label: const Text('Edit Medical Information'),
  ),
),
          const SizedBox(height: 20),
          const Text(
            'This information is not a substitute for medical advice '
            'or an emergency response service.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: navy,
      ),
    );
  }

  static Widget _infoCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  static Widget _infoRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, color: blue),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: navy),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
