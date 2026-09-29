import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import 'doctor_register_page.dart';
import 'patient_register_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Account',
                style: AppTextStyles.heading,
              ),

              const SizedBox(height: 8),

              const Text(
                'Choose how you will use CPEMS',
                style: AppTextStyles.body,
              ),

              const SizedBox(height: 40),

              _AccountTypeCard(
                icon: Icons.person_outline,
                title: 'Patient',
                description: 'Monitor and track your measurements',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const PatientRegisterPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              _AccountTypeCard(
                icon: Icons.medical_services_outlined,
                title: 'Doctor',
                description: 'Monitor and manage your patients',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const DoctorRegisterPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  const _AccountTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: primary,
              size: 32,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.sectionTitle,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    description,
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}