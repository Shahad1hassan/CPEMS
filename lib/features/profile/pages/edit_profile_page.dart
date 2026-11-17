import 'package:flutter/material.dart';
import '../data/patient_store.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const Color _navy = Color(0xFF142A55);
  static const Color _blue = Color(0xFF2563EB);
  static const Color _muted = Color(0xFF64748B);
  static const Color _background = Color(0xFFF4F8FF);

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  DateTime? _dateOfBirth;
  String? _sex;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: PatientStore.name.value);
    _phoneController = TextEditingController(text: PatientStore.phoneNumber.value);
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
    if (!mounted) return;
    if (picked != null) setState(() => _dateOfBirth = picked);
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
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: _navy, fontSize: 22, fontWeight: FontWeight.w800),
        ),
        foregroundColor: _navy,
        backgroundColor: _background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -90,
            child: _softCircle(260, const Color(0xFFD9EAFE)),
          ),
          Positioned(
            bottom: -95,
            left: -85,
            child: _softCircle(235, const Color(0xFFDDEAFF)),
          ),
          ScrollConfiguration(
            behavior: const _NoStretchScrollBehavior(),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                children: [
                  _buildIntroCard(),
                  const SizedBox(height: 26),
                  _label('Full Name'),
                  const SizedBox(height: 9),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _inputDecoration(
                      icon: Icons.person_outline_rounded,
                      hint: 'Enter your full name',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 21),
                  _label('Date of Birth'),
                  const SizedBox(height: 9),
                  _dateField(),
                  const SizedBox(height: 21),
                  _label('Sex'),
                  const SizedBox(height: 9),
                  DropdownButtonFormField<String>(
                    key: ValueKey(_sex),
                    initialValue: _sex == 'Male' || _sex == 'Female' ? _sex : null,
                    isExpanded: true,
                    decoration: _inputDecoration(
                      icon: Icons.person_outline_rounded,
                      hint: 'Select sex',
                    ),
                    hint: const Text('Not provided', style: TextStyle(color: _muted)),
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                    ],
                    onChanged: (value) => setState(() => _sex = value),
                  ),
                  const SizedBox(height: 21),
                  _label('Phone Number'),
                  const SizedBox(height: 9),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration(
                      icon: Icons.phone_outlined,
                      hint: '05XXXXXXXX',
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: _blue.withValues(alpha: 0.19),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: _saveProfile,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_rounded, color: Colors.white, size: 23),
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
                  const SizedBox(height: 19),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded, color: _muted, size: 18),
                      SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'Profile changes are stored temporarily during this app session.',
                          style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
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

  Widget _buildIntroCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF1F8FF), Color(0xFFDDEEFF), Color(0xFFC6E2FF)],
        ),
        border: Border.all(color: Colors.white, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.05),
            blurRadius: 17,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -60,
            bottom: -75,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _blue.withValues(alpha: 0.075),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(17),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline_rounded, color: _blue, size: 34),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Update Your Information',
                        style: TextStyle(
                          color: _navy,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Keep your profile details up to date.',
                        style: TextStyle(color: _muted, fontSize: 12, height: 1.4),
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
    final value = _dateOfBirth == null
        ? 'Select date'
        : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}';
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: _selectDate,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 57,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFDCE6F4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_month_outlined, color: _navy, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: _dateOfBirth == null ? _muted : _navy,
                    fontSize: 14,
                    fontWeight: _dateOfBirth == null
                        ? FontWeight.w400
                        : FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.calendar_today_outlined, color: _navy, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          color: _navy,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      );

  static InputDecoration _inputDecoration({
    required IconData icon,
    required String hint,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _muted, fontSize: 14),
      prefixIcon: Icon(icon, color: _navy, size: 22),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFDCE6F4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFDCE6F4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: _blue, width: 1.5),
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
