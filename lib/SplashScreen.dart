import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:tomotogame/LoginPage.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
        'assets/unnamed.png',
        height: 400,
        width: 500,
      ),
      title: const Text(
        "Welcome to tomato",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.blueGrey,
      showLoader: true,
      loadingText: const Text("Loading..."),
      navigator: const LoginPage(),
      durationInSeconds: 5,
    );
  }
}
