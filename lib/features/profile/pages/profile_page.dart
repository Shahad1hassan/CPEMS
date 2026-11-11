
import 'package:flutter/material.dart';
import '../data/patient_store.dart';
import 'edit_profile_page.dart';
import 'medical_information_page.dart';
import 'my_medications_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    this.patientName,
  });

  final String? patientName;

  static const Color blue = Color(0xFF2563EB);
  static const Color navy = Color(0xFF142A55);
  static const Color background = Color(0xFFF7F9FD);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'My Profile',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
            const SizedBox(height: 24),

            // Patient information card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 38,
                    backgroundColor: Color(0xFFE8F2FF),
                    child: Icon(
                      Icons.person_outline,
                      color: blue,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<String>(
  valueListenable: PatientStore.name,
  builder: (context, name, child) {
    return Text(
      name.isNotEmpty ? name : 'Patient',
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: navy,
      ),
    );
  },
),
                  const SizedBox(height: 4),
                  const Text(
                    'Patient Account',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 16),

OutlinedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      ),
    );
  },
  icon: const Icon(Icons.edit_outlined),
  label: const Text('Edit Profile'),
),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
            const SizedBox(height: 12),

            
ValueListenableBuilder<DateTime?>(
  valueListenable: PatientStore.dateOfBirth,
  builder: (context, dateOfBirth, child) {
    return ValueListenableBuilder<String?>(
      valueListenable: PatientStore.sex,
      builder: (context, sex, child) {
        return ValueListenableBuilder<String>(
          valueListenable: PatientStore.phoneNumber,
          builder: (context, phoneNumber, child) {
            final birthday = dateOfBirth == null
                ? 'Not provided'
                : '${dateOfBirth.day}/${dateOfBirth.month}/${dateOfBirth.year}';

            return _infoCard(
              children: [
                _infoRow(
                  Icons.cake_outlined,
                  'Date of Birth',
                  birthday,
                ),
                const Divider(height: 24),
                _infoRow(
                  Icons.person_outline,
                  'Sex',
                  sex ?? 'Not provided',
                ),
                const Divider(height: 24),
                _infoRow(
                  Icons.phone_outlined,
                  'Phone Number',
                  phoneNumber.trim().isEmpty
                      ? 'Not provided'
                      : phoneNumber,
                ),
              ],
            );
          },
        );
      },
    );
  },
),


            const SizedBox(height: 24),

            const Text(
              'My Health',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
            const SizedBox(height: 12),

            _menuTile(
  Icons.favorite_border,
  'Medical Information',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MedicalInformationPage(),
      ),
    );
  },
),
            const SizedBox(height: 10),
            _menuTile(
  Icons.medication_outlined,
  'My Medications',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyMedicationsPage(),
      ),
    );
  },
),
            const SizedBox(height: 10),
            _menuTile(
              Icons.description_outlined,
              "Doctor's Notes",
            ),

            const SizedBox(height: 24),

            const Text(
              'Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: navy,
              ),
            ),
            const SizedBox(height: 12),

            _menuTile(Icons.settings_outlined, 'Settings'),
          ],
        ),
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
      child: Column(children: children),
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


  
static Widget _menuTile(
  IconData icon,
  String title, {
  VoidCallback? onTap,
}) {
  return Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: blue),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: navy,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
    ),
  );
}
}


