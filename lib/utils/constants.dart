import 'package:flutter/material.dart';


// Colors

// const Color accentColor = Color.fromARGB(255, 248, 146, 48);

// Images
const String backgroundImage = 'assets/background_image.jpg';
const String apiaryImage = 'assets/apiary.png';

// Strings
const String logoutButtonText = 'Log out';
const String dashboardText = 'Dashboard';

// Colors
const Color tempLineColor1 = Color(0xFFE57373);
const Color tempLineColor2 = Color(0xFFEF5350);
const Color humidityLineColor1 = Color(0xFF64B5F6);
const Color humidityLineColor2 = Color(0xFF42A5F5);
const Color weightLineColor = Color(0xFF81C784);
const Color errorColor = Color(0xFFE53935);

// const primaryColor = Color(0xFFF89230);
const backgroundColor = Color(0xFFFDF8D2);
const brownColor = Color(0xFF5D4037);

const Color primaryColor = Color.fromARGB(255, 255, 193, 7); // Light yellow
const Color accentColor = Color.fromARGB(255, 248, 146, 48); // Orange accent
const Color textColor = Color(0xFF5D4037); // Dark brown for text
const Color formBackground = Color.fromARGB(255,255,255,255); // Off-white for forms
const Color customColor = Color.fromARGB(255, 255, 245, 195);

// Text Styles
const TextStyle chartTitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: const Color(0xFF5D4037),
);




class Constants {

  // Text Styles
  static const TextStyle appBarTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle sectionHeaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: brownColor,
  );

  static const TextStyle infoTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: brownColor,
  );

  static const TextStyle infoValueStyle = TextStyle(
    fontSize: 16,
    color: brownColor,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle noteTextStyle = TextStyle(
    fontSize: 14,
    color: brownColor,
  );

  static const TextStyle tableHeaderStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 14,
    color: errorColor,
  );

  static const TextStyle dialogTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  // Padding/Margin
  static const double defaultPadding = 16.0;
  static const double cardPadding = 16.0;
  static const double buttonPadding = 12.0;

  // Border Radius
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius buttonBorderRadius = BorderRadius.all(Radius.circular(20));
  static const BorderRadius inputBorderRadius = BorderRadius.all(Radius.circular(12));

  // Shadows
  static BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    spreadRadius: 1,
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  // App Bar Shape
  static const appBarShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(20),
    ),
  );
}