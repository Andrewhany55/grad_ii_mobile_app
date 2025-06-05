import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:DoseMe/welcome_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie animation - size increased here
          SizedBox(
            height: 500,
            width: 500,
            child: Lottie.asset('assets/animations/pillsplash.json'),
          ),
          const SizedBox(height: 30),
          const Text(
            'Pill Dispenser',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF0D47A1),
      nextScreen: const WelcomeScreen(),
      splashIconSize: 600,
      duration: 4000,
      animationDuration: const Duration(milliseconds: 800),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
