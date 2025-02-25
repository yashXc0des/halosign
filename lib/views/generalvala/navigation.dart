import 'package:flutter/material.dart';
import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart'; // Make sure to import the necessary package
import 'package:halosign/views/dashboard/generalvala/aggrement_received.dart';
import 'package:halosign/views/dashboard/generalvala/profile.dart';
import 'aggrement_send.dart';

class AdminDashboard1 extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard1> {
  int _currentPage = 0;
  final List<Widget> _screens = [

    AgreementsScreen1(),
    AggrementReceived(),
    ProfileScreen()
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],  // Gradient from blue to purple
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _screens[_currentPage], // Display screen based on selected index
      ),
      bottomNavigationBar: DotCurvedBottomNav(
        scrollController: _scrollController,
        hideOnScroll: true,
        indicatorColor: Colors.blue,
        backgroundColor: Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.ease,
        selectedIndex: _currentPage,
        indicatorSize: 7,
        borderRadius: 25,
        height: 70,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        items: [
          Icon(
            Icons.send,
            color: _currentPage == 0 ? Colors.blue : Colors.white,
          ),
          Icon(
            Icons.inbox_rounded,
            color: _currentPage == 1 ? Colors.blue : Colors.white,
          ),
          Icon(
            Icons.person,
            color: _currentPage == 2 ? Colors.blue : Colors.white,
          ),

        ],
      ),
    );
  }
}