import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

import 'login_screen.dart';
import 'theme_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  double _fontSize = 16;
  late SharedPreferences _prefs;

  late AnimationController _fadeController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _loadFontSize();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
  }

  Future<void> _loadFontSize() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = _prefs.getDouble('font_size')?.clamp(12.0, 24.0) ?? 16;
    });
  }

  Future<void> _saveFontSize(double value) async {
    await _prefs.setDouble('font_size', value);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// Blue background
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1A73E8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                ),
              ),
            ),
          ),

          /// Theme & Language
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.light_mode, color: Colors.black),
                  onPressed: () => themeProvider.toggleTheme(),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.language, color: Colors.black),
                  onPressed: () {
                    final newLocale = isArabic ? const Locale('en') : const Locale('ar');
                    context.setLocale(newLocale);
                  },
                ),
              ],
            ),
          ),

          /// Lottie pill animation
          Positioned(
            top: MediaQuery.of(context).size.height * 0.14,
            left: MediaQuery.of(context).size.width * 0.2,
            right: MediaQuery.of(context).size.width * 0.2,
            child: SizedBox(
              height: 220,
              child: Lottie.asset(
                'assets/animations/Animation1.json',
                fit: BoxFit.contain,
              ),
            ),
          ),

          /// App name + tagline with fade-in
          Positioned(
            top: MediaQuery.of(context).size.height * 0.48,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeController,
              child: Column(
                children: [
                  Text(
                    'app_name'.tr(),
                    style: GoogleFonts.poppins(
                      fontSize: _fontSize + 6,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'tagline'.tr(),
                    style: GoogleFonts.poppins(
                      fontSize: _fontSize - 2,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(radius: 4, backgroundColor: Colors.white),
                      SizedBox(width: 6),
                      CircleAvatar(radius: 4, backgroundColor: Colors.white54),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// Font size slider
          Positioned(
            bottom: 150,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Text(
                  'Font Size',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Slider(
                  min: 12,
                  max: 24,
                  value: _fontSize,
                  onChanged: (value) {
                    setState(() => _fontSize = value);
                    _saveFontSize(value);
                  },
                  activeColor: Colors.black,
                  inactiveColor: Colors.black26,
                ),
              ],
            ),
          ),

          /// Animated "Get Started" button
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: ScaleTransition(
              scale: _scaleController,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await _scaleController.forward();
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                icon: const Icon(Icons.arrow_forward, color: Colors.black),
                label: Text(
                  'get_started'.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  shadowColor: Colors.black26,
                  elevation: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
