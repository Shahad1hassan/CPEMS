import 'package:flutter/material.dart';

import '../home/pages/home_page.dart';
import '../measurement/pages/measurement_page.dart';
import '../charts/pages/charts_page.dart';
import '../profile/pages/profile_page.dart';


class PatientMainPage extends StatefulWidget {
  const PatientMainPage({
    super.key,
    this.patientName,
  });

  final String? patientName;

  @override
  State<PatientMainPage> createState() => _PatientMainPageState();
}


class _PatientMainPageState extends State<PatientMainPage> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
  HomePage(patientName: widget.patientName),
  const MeasurementPage(),
  const ChartsPage(),
  const ProfilePage(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
