import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/utils/input_decoration_helper.dart';
import 'package:heraguard_frontend/core/widgets/date_time_picker_helper.dart';
import 'package:heraguard_frontend/core/widgets/multi_step_dialog.dart';

class AddMedicationDialog extends StatefulWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onTimeSelected;
  final Function(Map<String, dynamic>) onMedicationAdded;

  const AddMedicationDialog({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
    required this.onMedicationAdded,
  });

  @override
  State<AddMedicationDialog> createState() => _AddMedicationDialogState();
}

class _AddMedicationDialogState extends State<AddMedicationDialog> {
  DateTime? _localSelectedDate;
  TimeOfDay? _localSelectedTime;

  @override
  void initState() {
    super.initState();
    _localSelectedDate = widget.selectedDate;
    _localSelectedTime = widget.selectedTime;
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await DateTimePickerHelper.pickDate(
      context,
      initialDate: _localSelectedDate,
    );
    if (date != null) {
      setState(() {
        _localSelectedDate = date;
      });
      widget.onDateSelected(date);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final time = await DateTimePickerHelper.pickTime(
      context,
      initialTime: _localSelectedTime,
    );
    if (time != null) {
      setState(() {
        _localSelectedTime = time;
      });
      widget.onTimeSelected(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiStepDialog(
      title: 'Agregar Medicamento',
      steps: [_buildMedicationDataStep(), _buildAdditionalInfoStep(context)],
      onComplete: (formData) {
        final medication = {
          "name": formData['name'] ?? '',
          "description": formData['description'] ?? '',
          "dosage":
              "${formData['dosage_amount'] ?? ''}${formData['dosage_unit'] ?? 'mg'}",
          "frequency": formData['frequency'] ?? 0,
          "duration": formData['duration'] ?? 0,
          "doctorId": formData['doctorId'] ?? '',
          "caregiverId": formData['caregiverId'] ?? '',
          "elderId": formData['elderId'] ?? '',
        };
        widget.onMedicationAdded(medication);
      },
    );
  }

  DialogStep _buildMedicationDataStep() {
    return DialogStep(
      title: 'Datos del Medicamento',
      buildContent: (formData) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecorationHelper.customDecoration(
                hint: 'Nombre del medicamento',
                icon: Icons.medication,
              ),
              onChanged: (value) => formData['name'] = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecorationHelper.customDecoration(
                hint: 'Descripción',
                icon: Icons.description,
                isMultiline: true,
              ),
              maxLines: 3,
              onChanged: (value) => formData['description'] = value,
            ),
            const SizedBox(height: 16),
            _buildDosageRow(formData),
            const SizedBox(height: 16),
            _buildFrequencyDropdown(formData),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecorationHelper.customDecoration(
                hint: 'Duración (días)',
                icon: Icons.calendar_month,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  formData['duration'] = int.tryParse(value) ?? 0,
            ),
          ],
        );
      },
    );
  }

  DialogStep _buildAdditionalInfoStep(BuildContext context) {
    return DialogStep(
      title: 'Fecha y Hora',
      buildContent: (formData) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _pickDate(context),
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecorationHelper.customDecoration(
                    hint: _localSelectedDate != null
                        ? DateTimePickerHelper.formatDate(_localSelectedDate!)
                        : 'Seleccionar fecha',
                    icon: Icons.calendar_today,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _pickTime(context),
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecorationHelper.customDecoration(
                    hint: _localSelectedTime != null
                        ? DateTimePickerHelper.formatTime(_localSelectedTime!)
                        : 'Seleccionar hora',
                    icon: Icons.access_time,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDosageRow(Map<String, dynamic> formData) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            decoration: InputDecorationHelper.customDecoration(hint: 'Dosis'),
            keyboardType: TextInputType.number,
            onChanged: (value) => formData['dosage_amount'] = value,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecorationHelper.customDecoration(hint: 'Unidad'),
            items: ['mg', 'ml', 'g', 'tabletas']
                .map(
                  (unit) => DropdownMenuItem(
                    value: unit,
                    child: Text(unit, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (value) => formData['dosage_unit'] = value ?? 'mg',
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencyDropdown(Map<String, dynamic> formData) {
    return DropdownButtonFormField<int>(
      decoration: InputDecorationHelper.customDecoration(
        hint: 'Seleccionar frecuencia',
        icon: Icons.schedule,
      ),
      items: const [
        DropdownMenuItem(value: 4, child: Text('Cada 4 horas')),
        DropdownMenuItem(value: 6, child: Text('Cada 6 horas')),
        DropdownMenuItem(value: 8, child: Text('Cada 8 horas')),
        DropdownMenuItem(value: 12, child: Text('Cada 12 horas')),
        DropdownMenuItem(value: 24, child: Text('Cada 24 horas')),
      ],
      onChanged: (value) => formData['frequency'] = value ?? 8,
    );
  }
}
