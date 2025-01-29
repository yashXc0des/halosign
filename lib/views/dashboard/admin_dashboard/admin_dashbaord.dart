import 'package:flutter/material.dart';
import 'admin_aggrementscreen.dart';
import 'admin_settings.dart';
import 'dashbaord_admin.dart';
import 'user_management_screen.dart';


class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    DashboardScreen(),
    AgreementsScreen(),
    UserManagementScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blueAccent, // Attractive background color
        selectedItemColor: Colors.teal, // Color of the selected icon/item
        unselectedItemColor: Colors.grey, // Color of unselected icons/items
        showUnselectedLabels: true, // Show labels for unselected items
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Agreements"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
