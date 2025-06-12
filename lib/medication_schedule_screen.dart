import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'medication_repository.dart';
import 'dashboard_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class MedicationScheduleScreen extends StatefulWidget {
  const MedicationScheduleScreen({super.key});

  @override
  State<MedicationScheduleScreen> createState() => _MedicationScheduleScreenState();
}

class _MedicationScheduleScreenState extends State<MedicationScheduleScreen> {
  final TextEditingController _pillNameController = TextEditingController();
  final TextEditingController _pillAmountController = TextEditingController();
  TimeOfDay? _selectedTime;
  File? _selectedImage;
  int _selectedDosageAmount = 1;

  @override
  void initState() {
    super.initState();
    _initializeNotification();
  }

  void _initializeNotification() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _selectedImage = File(picked.path));
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'med_channel', 'Medications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  void _saveSchedule() {
    if (_pillNameController.text.isEmpty || _pillAmountController.text.isEmpty || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    final med = Medication(
      name: _pillNameController.text.trim(),
      amount: '${_pillAmountController.text.trim()} (${_selectedDosageAmount} pills)',
      time: _selectedTime!,
      image: _selectedImage,
    );

    MedicationRepository.addMedication(med);
    _showNotification("New Medication Scheduled", "${med.name} at ${med.time.format(context)}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Saved & Notification Sent!")),
    );

    _pillNameController.clear();
    _pillAmountController.clear();
    setState(() {
      _selectedImage = null;
      _selectedTime = null;
      _selectedDosageAmount = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final font = GoogleFonts.poppins();
    const primaryColor = Color(0xFF3674B5);

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const DashboardScreen()),
                          );
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryColor),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.calendar_today_outlined, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        "Schedule Medication",
                        style: font.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "🩺 Add New Medication",
                    style: font.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _pillNameController,
                          decoration: InputDecoration(
                            labelText: "Pill Name",
                            prefixIcon: const Icon(Icons.medication_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _pillAmountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Dosage (mg)",
                            prefixIcon: const Icon(Icons.scale_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            labelText: 'Dosage Amount (pills)',
                            prefixIcon: const Icon(Icons.format_list_numbered),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          value: _selectedDosageAmount,
                          items: List.generate(10, (index) => index + 1)
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text('$e pills'),
                          ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedDosageAmount = val);
                          },
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: _pickTime,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  _selectedTime == null ? "Select Time" : _selectedTime!.format(context),
                                  style: font.copyWith(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_selectedImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_selectedImage!, height: 100, fit: BoxFit.cover),
                          )
                        else
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(child: Icon(Icons.image, size: 40, color: Colors.grey)),
                          ),
                        TextButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.upload),
                          label: const Text("Upload Image"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveSchedule,
                      icon: const Icon(Icons.save_alt),
                      label: const Text("Save & Notify"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: font.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}