import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'sign_in_page.dart'; // Import your professional sign-in page

// Define the primary brand color for use in the main theme
const Color kPrimaryColor = Color(0xFF4285F4);
const Color kAccentColor = Color(0xFF6200EE);

void main() async {
  // Ensure that Flutter is initialized before calling native code like Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase services
  await Firebase.initializeApp();

  runApp(const PawMeApp());
}

class PawMeApp extends StatelessWidget {
  const PawMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Set the official app title
      title: 'PawMe: Robot Control',

      theme: ThemeData(
        // Set the primary color used in the SignInPage for global consistency
        primaryColor: kPrimaryColor,
        // Define the color scheme
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(kPrimaryColor.value, <int, Color>{
            50: kPrimaryColor.withOpacity(0.1),
            100: kPrimaryColor.withOpacity(0.2),
            200: kPrimaryColor.withOpacity(0.3),
            300: kPrimaryColor.withOpacity(0.4),
            400: kPrimaryColor.withOpacity(0.5),
            500: kPrimaryColor,
            600: kPrimaryColor.withOpacity(0.9),
            700: kPrimaryColor.withOpacity(0.8),
            800: kPrimaryColor.withOpacity(0.7),
            900: kPrimaryColor.withOpacity(0.6),
          }),
          accentColor: kAccentColor,
        ),
        // Set a more modern, minimal look for buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
        // Set a consistent font if needed (optional)
        fontFamily: 'Roboto',
      ),

      // Start the application on the SignInPage
      home: const SignInPage(),

      // Keep this for a professional appearance
      debugShowCheckedModeBanner: false,
    );
  }
}
