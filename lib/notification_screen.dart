import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'medication_repository.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meds = MedicationRepository.getMedications();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: meds.isEmpty
          ? const Center(child: Text("No notifications yet."))
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: meds.length,
        itemBuilder: (context, index) {
          final med = meds[index];
          return Card(
            color: theme.cardColor,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.notifications_active),
              title: Text(
                "Scheduled: ${med.name} - ${med.amount}mg",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("At: ${med.time.format(context)}"),
            ),
          );
        },
      ),
    );
  }
}
