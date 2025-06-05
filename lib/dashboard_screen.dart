import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'theme_provider.dart';
import 'medication_schedule_screen.dart';
import 'monitoring_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'welcome_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isArabic = context.locale.languageCode == 'ar';
    final font = isArabic ? GoogleFonts.tajawal() : GoogleFonts.poppins();
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d').format(now);
    final time = DateFormat.jm().format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              /// Header
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '👋 ${'welcome_back'.tr()}, John!',
                          style: font.copyWith(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                                  (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formattedDate,
                      style: font.copyWith(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        time,
                        style: font.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              /// Dashboard Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    _buildTile(
                      context,
                      icon: Icons.calendar_month,
                      color: const Color(0xFFEF5350),
                      label: 'Medication',
                      subtitle: '2 pills today',
                      screen: const MedicationScheduleScreen(),
                    ),
                    _buildTile(
                      context,
                      icon: Icons.monitor_heart,
                      color: const Color(0xFF8E24AA),
                      label: 'Monitoring',
                      subtitle: 'Live status',
                      screen: const MonitoringScreen(),
                    ),
                    _buildTile(
                      context,
                      icon: Icons.notifications,
                      color: const Color(0xFFFFA000),
                      label: 'Notifications',
                      subtitle: '3 unread',
                      screen: const NotificationScreen(),
                    ),
                    _buildTile(
                      context,
                      icon: Icons.person,
                      color: const Color(0xFF00ACC1),
                      label: 'Profile',
                      subtitle: 'Edit info',
                      screen: const ProfileScreen(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context,
      {required IconData icon,
        required Color color,
        required String label,
        required Widget screen,
        String? subtitle}) {
    final font = context.locale.languageCode == 'ar' ? GoogleFonts.tajawal() : GoogleFonts.poppins();

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              textAlign: TextAlign.center,
              style: font.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: font.copyWith(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}