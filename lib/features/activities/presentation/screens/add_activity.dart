import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/widgets/custom_drop_down.dart';
import 'package:heraguard_frontend/core/widgets/custom_text_field.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({super.key});

  @override
  State<AddActivity> createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  late TextEditingController _nameController;
  late TextEditingController _frequencyController;
  late TextEditingController _recommendedTimeController;
  late TextEditingController _durationController;
  late TextEditingController _notesController;

  String? _selectedFrequency;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _frequencyController = TextEditingController();
    _recommendedTimeController = TextEditingController();
    _durationController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _frequencyController.dispose();
    _recommendedTimeController.dispose();
    _durationController.dispose();
    _notesController.dispose();
  }

  final List<String> _frequencyHours = [
    'Cada 4 horas',
    'Cada 6 horas',
    'Cada 8 horas',
    'Cada 12 horas',
    'Cada 24 horas ',
  ];

  void _onFrequencyChanged(String? newValue) {
    setState(() {
      _selectedFrequency = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(controller: _nameController, label: 'Nombre'),
                const SizedBox(height: 10),
                CustomDropDown(
                  options: _frequencyHours,
                  selectedValue: _selectedFrequency,
                  onChanged: _onFrequencyChanged,
                  label: 'Frecuencia',
                  hintText: 'Seleccionar Frecuencia',
                  fillColor: Colors.amber,
                ),
                SizedBox(
                  width: 200,
                  child: CustomDropDown(
                    options: _frequencyHours,
                    selectedValue: _selectedFrequency,
                    onChanged: _onFrequencyChanged,
                    label: 'Duracion',
                    fillColor: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _notesController,
                  label: 'Notas',
                  maxLines: 5,
                  minLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
