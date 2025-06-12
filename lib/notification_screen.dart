import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'medication_repository.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meds = MedicationRepository.getMedications();
    final font = GoogleFonts.poppins();

    return Scaffold(
      backgroundColor: const Color(0xFFE7F3FA),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
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
            left: -80,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF3674B5)),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.notifications_active, color: Color(0xFF3674B5)),
                      const SizedBox(width: 8),
                      Text(
                        "Notifications",
                        style: font.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3674B5),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: meds.isEmpty
                      ? Center(
                    child: Text(
                      "No notifications yet.",
                      style: font.copyWith(fontSize: 16, color: Colors.grey[700]),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: meds.length,
                    itemBuilder: (context, index) {
                      final med = meds[index];
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
                          leading: const Icon(Icons.medication_rounded, color: Color(0xFF3674B5)),
                          title: Text(
                            "Scheduled: ${med.name} - ${med.amount}",
                            style: font.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "At: ${med.time.format(context)}",
                            style: font.copyWith(color: Colors.grey[700]),
                          ),
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
