// Importing necessary libraries
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

// Importing the LoginPage widget
import 'package:tomotogame/LoginPage.dart';

// Widget representing the SplashScreen
class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

// State class for the SplashScreen widget
class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      // Logo displayed on the splash screen
      logo: Image.asset(
        'assets/unnamed.png',
        height: 400,
        width: 500,
      ),
      // Title displayed on the splash screen
      title: const Text(
        "Welcome to tomato",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Background color of the splash screen
      backgroundColor: Colors.blueGrey,
      // Display a loading indicator
      showLoader: true,
      // Loading text displayed along with the loading indicator
      loadingText: const Text("Loading..."),
      // Navigate to the LoginPage after the splash screen
      navigator: const LoginPage(),
      // Duration of the splash screen in seconds
      durationInSeconds: 5,
    );
  }
}
