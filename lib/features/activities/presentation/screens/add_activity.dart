import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/widgets/appbar_widget.dart';
import 'package:heraguard_frontend/core/widgets/custom_button.dart';
import 'package:heraguard_frontend/core/widgets/custom_drop_down.dart';
import 'package:heraguard_frontend/core/widgets/custom_text_field.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';

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
  String? _selectedDuration;

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

  final List<String> _frequency = [
    'Una sola vez',
    'Diario',
    'Cada 2 días',
    'Luneas a Viernes',
    'Fin de semana',
    'Semanalmente',
    'Mensualmente',
  ];

  final List<String> _duration = [
    '5 minutos',
    '10 minutos',
    '15 minutos',
    '30 minutos',
    '45 minutos',
    '1 hora',
  ];

  void _onFrequencyChanged(String? newValue) {
    setState(() {
      _selectedFrequency = newValue;
    });
  }

  void _onDurationChanged(String? newValue) {
    setState(() {
      _selectedDuration = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'Programar Actividad'),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              child: Column(
                children: [
                  Text(
                    'Detalles de la Actividad',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(controller: _nameController, label: 'Nombre'),
                  const SizedBox(height: 10),
                  CustomDropDown(
                    options: _frequency,
                    selectedValue: _selectedFrequency,
                    onChanged: _onFrequencyChanged,
                    label: 'Frecuencia',
                    hintText: 'Seleccione la frecuencia',
                    fillColor: Colors.blue.shade100,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Hora recomendada',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Duración',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _recommendedTimeController,
                          label: 'Hora',
                          icon: Icons.access_time,
                          readOnly: true,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CustomDropDown(
                          options: _duration,
                          selectedValue: _selectedDuration,
                          onChanged: _onDurationChanged,
                          label: '',
                          hintText: 'Seleccione la duración',
                          fillColor: Colors.blue.shade100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _notesController,
                    label: 'Notas',
                    maxLines: 5,
                    minLines: 3,
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Programar Actividad',
                    onPressed: () {},
                    width: 220,
                    height: 55,
                    fontSize: 20,
                  ),
                  const SizedBox(height: 15),
                  CustomButton(
                    text: 'Cancelar',
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Colors.red,
                    width: 220,
                    height: 55,
                    fontSize: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavbarBottom(),
    );
  }
}
