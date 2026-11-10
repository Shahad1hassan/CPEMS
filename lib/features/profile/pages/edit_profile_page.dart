
import 'package:flutter/material.dart';
import '../data/patient_store.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  DateTime? _dateOfBirth;
  String? _sex;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: PatientStore.name.value,
    );
    _phoneController = TextEditingController(
      text: PatientStore.phoneNumber.value,
    );
    _dateOfBirth = PatientStore.dateOfBirth.value;
    _sex = PatientStore.sex.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    PatientStore.updateProfile(
      name: _nameController.text,
      dateOfBirth: _dateOfBirth,
      sex: _sex,
      phoneNumber: _phoneController.text,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF142A55);
    const background = Color(0xFFF7F9FD);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: background,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            ListTile(
              leading: const Icon(Icons.cake_outlined),
              title: const Text('Date of Birth'),
              subtitle: Text(
                _dateOfBirth == null
                    ? 'Select date'
                    : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
              ),
              trailing: const Icon(Icons.calendar_month_outlined),
              onTap: _selectDate,
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<String>(
              initialValue: _sex,
              decoration: const InputDecoration(
                labelText: 'Sex',
                prefixIcon: Icon(Icons.person_outline),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Male',
                  child: Text('Male'),
                ),
                DropdownMenuItem(
                  value: 'Female',
                  child: Text('Female'),
                ),
              ],
              onChanged: (value) => setState(() => _sex = value),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '05XXXXXXXX',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Profile changes are stored temporarily during this app session.',
              textAlign: TextAlign.center,
              style: TextStyle(color: navy, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
