import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../auth/auth_service.dart';
import '../pages/timely_data.dart';
import '../pages/apiaries.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        // borderRadius: const BorderRadius.vertical(
        //   top: Radius.circular(20),
        // ),
        child: BottomNavigationBar(
          backgroundColor: primaryColor, // Yellow
          elevation: 10,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 146, 48).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.dashboard),
              ),
              label: dashboardText,
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 146, 48).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.dashboard),
              ),
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 146, 48).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.logout),
              ),
              label: logoutButtonText,
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF5D4037),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.logout),
              ),
            ),
          ],
          selectedItemColor: const Color(0xFF5D4037), // Orange
          unselectedItemColor: const Color(0xFF5D4037), // Dark brown
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: (index) async {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ApiaryScreen()),
              );
            } else if (index == 1) {
              await _auth.signout();
              // Add navigation to login screen if needed
            }
          },
        ),
      ),
    );
  }
}