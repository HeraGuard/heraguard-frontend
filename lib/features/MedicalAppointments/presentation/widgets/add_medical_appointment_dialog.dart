import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/utils/input_decoration_helper.dart';
import 'package:heraguard_frontend/core/widgets/date_time_picker_helper.dart';
import 'package:heraguard_frontend/features/MedicalAppointments/domain/entities/medical_appointment.dart';

class AddMedicalAppointmentDialog extends StatefulWidget {
  final String elderId;
  final String elderName;
  final Function(MedicalAppointment) onAppointmentAdded;

  const AddMedicalAppointmentDialog({
    super.key,
    required this.elderId,
    required this.elderName,
    required this.onAppointmentAdded,
  });

  @override
  State<AddMedicalAppointmentDialog> createState() => _AddMedicalAppointmentDialogState();
}

class _AddMedicalAppointmentDialogState extends State<AddMedicalAppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  final _descriptionController = TextEditingController();

  Future<void> _pickDate() async {
    final d = await DateTimePickerHelper.pickDate(context, initialDate: _date);
    if (d != null) setState(() => _date = d);
  }

  Future<void> _pickTime() async {
    final t = await DateTimePickerHelper.pickTime(context, initialTime: _time);
    if (t != null) setState(() => _time = t);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final appointment = MedicalAppointment(
      medicalAppointmentId: '', // se genera en repo o backend
      nameOfPatient: widget.elderName,
      date: DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute),
      time: _time.format(context),
      description: _descriptionController.text.trim(),
      doctorId: null,
      caregiverId: null,
      elderId: widget.elderId,
      doctorName: null,
      caregiverName: null,
      elderName: widget.elderName,
    );

    widget.onAppointmentAdded(appointment);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva Cita Médica'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecorationHelper.customDecoration(hint: 'Descripción', icon: Icons.description),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecorationHelper.customDecoration(
                    hint: 'Fecha', icon: Icons.calendar_today),
                  child: Text(DateTimePickerHelper.formatDate(_date)),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickTime,
                child: InputDecorator(
                  decoration: InputDecorationHelper.customDecoration(hint: 'Hora', icon: Icons.access_time),
                  child: Text(_time.format(context)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(onPressed: _submit, child: const Text('Agregar')),
      ],
    );
  }
}