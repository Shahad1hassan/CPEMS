import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

import '../home/pages/home_page.dart';
import '../measurement/pages/measurement_page.dart';
import '../charts/pages/charts_page.dart';
import '../profile/pages/profile_page.dart';
  
class PatientMainPage extends StatefulWidget {
  const PatientMainPage({super.key});

  @override
  State<PatientMainPage> createState() => _PatientMainPageState();
}

class _PatientMainPageState extends State<PatientMainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    MeasurementPage(),
    ChartsPage(),
    ProfilePage(),
  ];

  final List<String> _pageTitles = const [
    'CPEMS',
    'Measurement',
    'Charts',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,

        title: Text(
          _pageTitles[_selectedIndex],
          style: AppTextStyles.heading.copyWith(
            color: _selectedIndex == 0
                ? AppColors.primary
                : AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(child: _pages[_selectedIndex]),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.air_outlined),
            selectedIcon: Icon(Icons.air),
            label: 'Measurement',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Charts',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
