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
  static const Color background = Color(0xFFF4F8FF);
  static const Color secondary = Color(0xFF64748B);
  static const Color dividerColor = Color(0xFFE5EAF3);

  @override
  Widget build(BuildContext context) {
    // The navigation scaffold already displays the Profile app bar.
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -130,
              right: -100,
              child: _backgroundCircle(290, const Color(0xFFD9EAFE)),
            ),
            Positioned(
              bottom: -100,
              left: -100,
              child: _backgroundCircle(270, const Color(0xFFE2E9FF)),
            ),
            ScrollConfiguration(
              behavior: const _NoStretchScrollBehavior(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                children: [
  const Center(
    child: Text(
      'Profile',
      style: TextStyle(
        color: navy,
        fontSize: 23,
        fontWeight: FontWeight.w800,
      ),
    ),
  ),

  const SizedBox(height: 24),

  _profileCard(context),
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
                              return _surfaceCard(
                                child: Column(
                                  children: [
                                    _informationRow(
                                      icon: Icons.calendar_month_outlined,
                                      label: 'Date of Birth',
                                      value: birthday,
                                    ),
                                    const Divider(height: 1, color: dividerColor),
                                    _informationRow(
                                      icon: Icons.person_outline_rounded,
                                      label: 'Sex',
                                      value: sex?.trim().isNotEmpty == true
                                          ? sex!.trim()
                                          : 'Not provided',
                                    ),
                                    const Divider(height: 1, color: dividerColor),
                                    _informationRow(
                                      icon: Icons.phone_outlined,
                                      label: 'Phone Number',
                                      value: phoneNumber.trim().isNotEmpty
                                          ? phoneNumber.trim()
                                          : 'Not provided',
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 27),
                  _sectionHeading(
                    icon: Icons.favorite_border_rounded,
                    title: 'My Health',
                    subtitle: 'Manage your health information',
                  ),
                  const SizedBox(height: 13),
                  _surfaceCard(
                    child: Column(
                      children: [
                        _menuRow(
                          icon: Icons.favorite_border_rounded,
                          title: 'Medical Information',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MedicalInformationPage(),
                            ),
                          ),
                        ),
                        const Divider(height: 1, color: dividerColor),
                        _menuRow(
                          icon: Icons.medication_outlined,
                          title: 'My Medications',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyMedicationsPage(),
                            ),
                          ),
                        ),
                        const Divider(height: 1, color: dividerColor),
                        _menuRow(
                          icon: Icons.description_outlined,
                          title: "Doctor's Notes",
                          onTap: null, // Not implemented yet.
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 27),
                  _sectionHeading(
                    icon: Icons.settings_outlined,
                    title: 'Preferences',
                    subtitle: 'App settings and experience',
                  ),
                  const SizedBox(height: 13),
                  _surfaceCard(
                    child: _menuRow(
                      icon: Icons.tune_rounded,
                      title: 'Settings',
                      onTap: null, // Not implemented yet.
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.09),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFEEF7FF),
            Color(0xFFC5E5FF),
            Color(0xFF92CEFC),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -110,
            right: -80,
            child: _softShape(240, const Color(0xFF4DADFF).withValues(alpha: 0.19)),
          ),
          Positioned(
            top: 18,
            right: 15,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.19,
                child: Image.asset(
                  'assets/images/cpems_logo.png',
                  width: 86,
                  height: 86,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.88),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: blue.withValues(alpha: 0.08),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: blue,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder<String>(
                            valueListenable: PatientStore.name,
                            builder: (context, name, child) {
                              final display = name.trim().isNotEmpty
                                  ? name.trim()
                                  : (patientName?.trim().isNotEmpty == true
                                      ? patientName!.trim()
                                      : 'Patient');
                              return Text(
                                display,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: navy,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCEBFF),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              'Patient Account',
                              style: TextStyle(
                                fontSize: 12,
                                color: blue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 19),
                    label: const Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: blue,
                      backgroundColor: Colors.white.withValues(alpha: 0.95),
                      side: const BorderSide(color: blue, width: 1.3),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _sectionHeading({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: const Color(0xFFE0EFFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: blue, size: 23),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: secondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _surfaceCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.045),
            blurRadius: 17,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  static Widget _informationRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(icon, color: blue, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: navy,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: secondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _menuRow({
    required IconData icon,
    required String title,
    required VoidCallback? onTap,
  }) {
    final enabled = onTap != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FF),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: blue, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (enabled)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF7E8DA3),
                  size: 22,
                )
              else
                const Text(
                  'Coming soon',
                  style: TextStyle(color: secondary, fontSize: 11),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _backgroundCircle(double size, Color color) {
    return IgnorePointer(child: _softShape(size, color));
  }

  static Widget _softShape(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
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
