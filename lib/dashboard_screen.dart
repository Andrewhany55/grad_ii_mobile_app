import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_screen.dart';
import 'medication_schedule_screen.dart';
import 'monitoring_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final font = isArabic ? GoogleFonts.tajawal() : GoogleFonts.poppins();
    final now = DateTime.now();
    final time = DateFormat.Hm().format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFE7F3FA),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFFBBDEFB),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -80,
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                color: Color(0xFFB2EBF2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, font, now, time),
                const SizedBox(height: 30),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildAnimatedTile(
                          context,
                          font,
                          icon: Icons.medication_outlined,
                          label: 'Medication',
                          subtitle: '2 pills today',
                          color: const Color(0xFFFFCDD2),
                          screen: const MedicationScheduleScreen(),
                        ),
                        _buildAnimatedTile(
                          context,
                          font,
                          icon: Icons.monitor_heart,
                          label: 'Monitoring',
                          subtitle: 'Live status',
                          color: const Color(0xFFBBDEFB),
                          screen: const MonitoringScreen(),
                        ),
                        _buildAnimatedTile(
                          context,
                          font,
                          icon: Icons.notifications_active,
                          label: 'Notifications',
                          subtitle: '3 unread',
                          color: const Color(0xFFFFF9C4),
                          screen: const NotificationScreen(),
                        ),
                        _buildAnimatedTile(
                          context,
                          font,
                          icon: Icons.person,
                          label: 'Profile',
                          subtitle: 'Edit Info',
                          color: const Color(0xFFB2DFDB),
                          screen: const ProfileScreen(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TextStyle font, DateTime now, String time) {
    final day = DateFormat.E().format(now);
    final date = DateFormat.d().format(now);
    final month = DateFormat.MMM().format(now);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      decoration: const BoxDecoration(
        color: Color(0xFF3674B5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '👋 ${'welcome_back'.tr()}, John!',
                style: font.copyWith(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
          const SizedBox(height: 20),
          Container(
            width: 220,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(day, style: font.copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(month, style: font.copyWith(fontSize: 14, color: Colors.grey[700])),
                  ],
                ),
                Text(date,
                  style: font.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3674B5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              time,
              style: font.copyWith(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTile(
      BuildContext context,
      TextStyle font, {
        required IconData icon,
        required String label,
        required String subtitle,
        required Color color,
        required Widget screen,
      }) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 18),
            Text(label, style: font.copyWith(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 4),
            Text(subtitle, style: font.copyWith(fontSize: 13, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
