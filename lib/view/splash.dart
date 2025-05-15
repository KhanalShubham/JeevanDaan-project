
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:jeevandaan/view/login.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo image
          Image.asset(
            'assets/lottie/images/logo.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          // App name
          const Text(
            'Jeevan Daan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 40),
          // Loading animation
          Lottie.asset(
            'assets/lottie/loading.json',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
      nextScreen: const Login(),
      splashIconSize: 500,
      backgroundColor: Colors.white,
      duration: 3000, // Duration in milliseconds
    );
  }
}