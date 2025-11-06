import 'package:flutter/material.dart';
import '../../domain/entities/medication.dart';

class AddMedicationFormProvider extends ChangeNotifier {
  String name = '';
  String description = '';

  int dosageAmount = 0;
  String dosageUnit = 'mg';

  int frequency = 0;

  int durationAmount = 0;
  String durationUnit = 'Días';

  String elderId = '';

  List<Medication> medications = [];

  void setName(String val) {
    name = val;
    notifyListeners();
  }

  void setDescription(String val) {
    description = val;
    notifyListeners();
  }

  void setDosageAmount(int val) {
    dosageAmount = val;
    notifyListeners();
  }

  void setDosageUnit(String val) {
    dosageUnit = val;
    notifyListeners();
  }

  void setFrequency(int val) {
    frequency = val;
    notifyListeners();
  }

  void setDurationAmount(int val) {
    durationAmount = val;
    notifyListeners();
  }

  void setDurationUnit(String val) {
    durationUnit = val;
    notifyListeners();
  }

  void setElderId(String val) {
    elderId = val;
    notifyListeners();
  }

  int computeDurationInDays() {
    switch (durationUnit) {
      case 'Días':
        return durationAmount;
      case 'Semanas':
        return durationAmount * 7;
      case 'Meses':
        return durationAmount * 30;
      default:
        return durationAmount;
    }
  }

  void addMedication() {
    if (name.isEmpty || dosageAmount == 0 || durationAmount == 0) return;

    final String finalDosage = '$dosageAmount $dosageUnit';
    final int days = computeDurationInDays();

    medications.add(
      Medication(
        name: name,
        description: description,
        dosage: finalDosage, // Ej. "1 mg"
        frequency: frequency,
        duration: durationAmount,
        elderId: elderId,
      ),
    );

    // Limpiar campos
    name = '';
    description = '';
    dosageAmount = 0;
    dosageUnit = 'mg';
    frequency = 0;
    durationAmount = 0;
    durationUnit = 'Días';

    notifyListeners();
  }

  void clearAll() {
    medications.clear();
    name = '';
    description = '';
    dosageAmount = 0;
    dosageUnit = 'mg';
    frequency = 0;
    durationAmount = 0;
    durationUnit = 'Días';
    elderId = '';
    notifyListeners();
  }
}
