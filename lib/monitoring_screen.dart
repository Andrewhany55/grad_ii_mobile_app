import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'medication_repository.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'taken':
        return Colors.green;
      case 'missed':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final font = GoogleFonts.poppins();
    final medications = MedicationRepository.getMedications();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : const Color(0xFFBBDEFB),
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
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : const Color(0xFFB2EBF2),
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
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onPrimary),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.monitor_heart_outlined, color: theme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        "Monitoring",
                        style: font.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'monitoring_status'.tr(),
                    style: font.copyWith(fontSize: 20, fontWeight: FontWeight.w600, color: theme.primaryColor),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: medications.isEmpty
                      ? Center(
                    child: Text(
                      "No medications added yet",
                      style: font.copyWith(fontSize: 16, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: medications.length,
                    itemBuilder: (context, index) {
                      final med = medications[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: isDark ? Colors.black45 : Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: med.image != null
                              ? CircleAvatar(
                            radius: 28,
                            backgroundImage: FileImage(med.image!),
                          )
                              : CircleAvatar(
                            radius: 28,
                            backgroundColor: theme.primaryColor.withOpacity(0.15),
                            child: Icon(Icons.medication, color: theme.primaryColor),
                          ),
                          title: Text(
                            med.name,
                            style: font.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text("Dosage: ${med.amount}", style: font.copyWith(fontSize: 13, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7))),
                              Text("Time: ${med.time.format(context)}", style: font.copyWith(fontSize: 13, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7))),
                              Text("Status: ${med.status}", style: font.copyWith(fontSize: 13, color: _getStatusColor(med.status))),
                            ],
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
