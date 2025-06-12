import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  final Map<String, String> userData = const {
    'Name': 'John Doe',
    'Email': 'john@example.com',
    'Phone': '+1 234 567 8901',
    'Address': '123 Main Street, Cityville',
    'Age': '28',
    'Gender': 'Male',
    'Preferred Language': 'English',
    'Account Status': 'Verified'
  };

  @override
  Widget build(BuildContext context) {
    final font = GoogleFonts.poppins();

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const DashboardScreen()),
                          );
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF3674B5)),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.person, color: Color(0xFF3674B5)),
                      const SizedBox(width: 8),
                      Text(
                        "Profile",
                        style: font.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3674B5),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Edit Profile coming soon...")),
                          );
                        },
                        icon: const Icon(Icons.edit, color: Color(0xFF3674B5)),
                      )
                    ],
                  ),
                ),
                Center(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    backgroundImage: const AssetImage("assets/user_profile.png"), // Placeholder image
                    child: const Icon(Icons.person, size: 40, color: Color(0xFF3674B5)),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      String key = userData.keys.elementAt(index);
                      String value = userData.values.elementAt(index);
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.info_outline, color: Color(0xFF3674B5)),
                          title: Text(key, style: font.copyWith(fontWeight: FontWeight.w600)),
                          subtitle: Text(value, style: font.copyWith(color: Colors.grey[700])),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}