import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';

import '../widgets/background.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          WelcomeBackground(color: AppColors.primary),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 64),

                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/cpems_logo.png',
                      width: 170,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'CPEMS',
                    style: AppTextStyles.largeTitle.copyWith(
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Connected Peak Expiratory Measurement System',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body,
                  ),

                  const Spacer(),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text('Log In'),
                  ),

                  const SizedBox(height: 12),

                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text('Create Account'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
