// medication_repository.dart
import 'dart:io';
import 'package:flutter/material.dart';

class Medication {
  final String name;
  final String amount;
  final TimeOfDay time;
  final File? image;
  String status;

  Medication({
    required this.name,
    required this.amount,
    required this.time,
    this.image,
    this.status = 'Scheduled',
  });
}

class MedicationRepository {
  static final List<Medication> _medications = [];

  static void addMedication(Medication medication) {
    _medications.add(medication);
  }

  static List<Medication> getMedications() {
    return _medications;
  }

  static void clear() => _medications.clear();
}
