import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'medication_repository.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.black : Colors.white;
    final font = GoogleFonts.poppins();
    final medications = MedicationRepository.getMedications();

    return Scaffold(
      appBar: AppBar(
        title: Text('monitoring'.tr(), style: TextStyle(color: textColor)),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('monitoring_status'.tr(), style: font.copyWith(fontSize: 22, fontWeight: FontWeight.w600, color: textColor)),
            const SizedBox(height: 20),
            Expanded(
              child: medications.isEmpty
                  ? Center(child: Text("No medications added yet", style: font.copyWith(color: textColor)))
                  : ListView.builder(
                itemCount: medications.length,
                itemBuilder: (context, index) {
                  final med = medications[index];
                  return Card(
                    elevation: 3,
                    color: theme.cardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: med.image != null
                          ? CircleAvatar(backgroundImage: FileImage(med.image!), radius: 25)
                          : const CircleAvatar(child: Icon(Icons.medication)),
                      title: Text(med.name, style: font.copyWith(fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dosage: ${med.amount} mg", style: font.copyWith(fontSize: 13)),
                          Text("Time: ${med.time.format(context)}", style: font.copyWith(fontSize: 13)),
                          Text("Status: ${med.status}", style: font.copyWith(fontSize: 13, color: Colors.green)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
