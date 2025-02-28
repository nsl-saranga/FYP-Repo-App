import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../auth/auth_service.dart';
import '../pages/timely_data.dart';
import '../pages/apiaries.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: primaryColor,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label:
              dashboardText, // Replace with your actual dashboard text constant
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label:
              logoutButtonText, // Replace with your actual logout text constant
        ),
      ],
      selectedItemColor: Color.fromARGB(255, 242, 255, 242),
      unselectedItemColor: Color.fromARGB(255, 44, 43, 43),
      onTap: (index) async {
        if (index == 0) {
          // Navigate to the dashboard
          print('Dashboard clicked');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ApiaryScreen()),
          ); // Ensure route is registered
        } else if (index == 1) {
          // Perform logout
          print('Logout clicked');
          await _auth.signout(); // Assuming `signOut` is your logout method
          // Ensure route is registered
        }
      },
    );
  }
}
