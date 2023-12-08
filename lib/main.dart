import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tomotogame/SplashScreen.dart';
import 'LoginPage.dart';

void main() async {
  // Ensure that Flutter is initialized and Firebase is configured
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Run the app
  runApp(const MyApp());
}

/// The main application widget for the Tomato Game.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tomato Game',
      theme: ThemeData(
        primaryColor: Colors.transparent,
      ),
      // Disable the debug banner in the top-right corner
      debugShowCheckedModeBanner: false,
      // Set the initial screen to the SplashScreen
      home: SplashScreen(),
    );
  }
}
