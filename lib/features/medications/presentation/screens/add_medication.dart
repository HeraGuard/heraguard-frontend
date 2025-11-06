import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heraguard_frontend/core/widgets/custom_drop_down.dart';
import 'package:heraguard_frontend/core/widgets/custom_text_field.dart';
import 'package:heraguard_frontend/features/medications/presentation/providers/add_medication_form_provider.dart';
import 'package:heraguard_frontend/features/medications/data/repositories/medication_repository_impl.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  late TextEditingController _descriptionController;
  late TextEditingController _elderIdController;
  late TextEditingController _durationAmountController;

  String? _selectedFrequency;
  String? _selectedDurationUnit;
  String? _selectedDosageUnit;
  DateTime? _selectedDateTime;

  final List<String> _frequencyOptions = [
    'Cada 4 horas',
    'Cada 6 horas',
    'Cada 8 horas',
    'Cada 12 horas',
    'Cada 24 horas',
  ];

  final List<String> _durationUnits = ['Días', 'Semanas', 'Meses'];
  final List<String> _dosageUnits = ['mg'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dosageController = TextEditingController();
    _descriptionController = TextEditingController();
    _elderIdController = TextEditingController();
    _durationAmountController = TextEditingController();
    _selectedDosageUnit = _dosageUnits.first;
    _selectedDateTime = DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _descriptionController.dispose();
    _elderIdController.dispose();
    _durationAmountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1565C0),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0D47A1),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1565C0),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        _selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          _selectedDateTime?.hour ?? 0,
          _selectedDateTime?.minute ?? 0,
        );
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1565C0),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0D47A1),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1565C0),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() {
        final current = _selectedDateTime ?? DateTime.now();
        _selectedDateTime = DateTime(
          current.year,
          current.month,
          current.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void _clearForm(AddMedicationFormProvider provider) {
    _nameController.clear();
    _dosageController.clear();
    _durationAmountController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedDurationUnit = null;
      _selectedDosageUnit = _dosageUnits.first;
      _selectedFrequency = null;
      _selectedDateTime = DateTime.now();
    });
  }

  void _showMedicationModal(
    BuildContext context,
    AddMedicationFormProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MedicationModal(
        nameController: _nameController,
        dosageController: _dosageController,
        durationAmountController: _durationAmountController,
        dosageUnits: _dosageUnits,
        durationUnits: _durationUnits,
        frequencyOptions: _frequencyOptions,
        selectedDosageUnit: _selectedDosageUnit,
        selectedDurationUnit: _selectedDurationUnit,
        selectedFrequency: _selectedFrequency,
        onNameChanged: provider.setName,
        onDosageChanged: (val) {
          final cantidad = int.tryParse(val) ?? 0;
          provider.setDosageAmount(cantidad);
        },
        onDosageUnitChanged: (val) {
          setState(() {
            _selectedDosageUnit = val;
            if (val != null) provider.setDosageUnit(val);
          });
        },
        onFrequencyChanged: (val) {
          setState(() {
            _selectedFrequency = val;
            if (val != null) {
              provider.setFrequency(_frequencyOptions.indexOf(val));
            }
          });
        },
        onDurationChanged: (val) {
          int cantidad = int.tryParse(val) ?? 0;
          provider.setDurationAmount(cantidad);
        },
        onDurationUnitChanged: (val) {
          setState(() {
            _selectedDurationUnit = val;
            if (val != null) provider.setDurationUnit(val);
          });
        },
        onAdd: () {
          if (provider.name.isNotEmpty &&
              provider.dosageAmount != 0 &&
              provider.durationAmount != 0 &&
              _selectedDosageUnit != null &&
              _selectedDurationUnit != null) {
            provider.addMedication();
            _clearForm(provider);
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  void _showDateTimeDescriptionModal(
    BuildContext context,
    AddMedicationFormProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DateTimeDescriptionModal(
        descriptionController: _descriptionController,
        selectedDateTime: _selectedDateTime,
        onDescriptionChanged: provider.setDescription,
        onPickDate: () => _pickDate(context),
        onPickTime: () => _pickTime(context),
        onConfirm: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddMedicationFormProvider(),
      child: Consumer<AddMedicationFormProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFE3F2FD),
            appBar: AppBar(
              title: const Text(
                'Recetar Medicamento',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color(0xFF1976D2),
              centerTitle: true,
              elevation: 4,
              toolbarHeight: 70,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PatientInfoSection(
                    elderIdController: _elderIdController,
                    onElderIdChanged: provider.setElderId,
                  ),
                  const SizedBox(height: 20),
                  LargeButton(
                    icon: Icons.medication,
                    label: 'Agregar Medicamento',
                    backgroundColor: const Color(0xFF64B5F6),
                    onPressed: () => _showMedicationModal(context, provider),
                  ),
                  const SizedBox(height: 16),
                  LargeButton(
                    icon: Icons.event_note,
                    label: 'Fecha, Hora y Descripción',
                    backgroundColor: const Color(0xFF64B5F6),
                    onPressed: () =>
                        _showDateTimeDescriptionModal(context, provider),
                  ),
                  const SizedBox(height: 24),
                  if (provider.medications.isNotEmpty)
                    MedicationListSection(
                      medications: provider.medications,
                      frequencyOptions: _frequencyOptions,
                    ),
                  const SizedBox(height: 20),
                  LargeButton(
                    icon: null,
                    label: '✓ RECETAR',
                    backgroundColor: const Color(0xFF1565C0),
                    fontSize: 24,
                    onPressed:
                        provider.elderId.isEmpty || provider.medications.isEmpty
                        ? null
                        : () async {
                            final repo = MedicationRepositoryImpl();
                            await repo.addPrescription(
                              elderId: provider.elderId,
                              date: _selectedDateTime ?? DateTime.now(),
                              medications: provider.medications,
                            );
                            provider.clearAll();
                            _clearForm(provider);
                          },
                  ),
                  const SizedBox(height: 16),
                  LargeButton(
                    icon: null,
                    label: '✗ Cancelar',
                    backgroundColor: const Color(0xFFE57373),
                    fontSize: 22,
                    onPressed: provider.clearAll,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================
// MODALES
// ============================================

/// Modal para agregar medicamento
class MedicationModal extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController dosageController;
  final TextEditingController durationAmountController;
  final List<String> dosageUnits;
  final List<String> durationUnits;
  final List<String> frequencyOptions;
  final String? selectedDosageUnit;
  final String? selectedDurationUnit;
  final String? selectedFrequency;
  final Function(String) onNameChanged;
  final Function(String) onDosageChanged;
  final Function(String?) onDosageUnitChanged;
  final Function(String?) onFrequencyChanged;
  final Function(String) onDurationChanged;
  final Function(String?) onDurationUnitChanged;
  final VoidCallback onAdd;

  const MedicationModal({
    super.key,
    required this.nameController,
    required this.dosageController,
    required this.durationAmountController,
    required this.dosageUnits,
    required this.durationUnits,
    required this.frequencyOptions,
    required this.selectedDosageUnit,
    required this.selectedDurationUnit,
    required this.selectedFrequency,
    required this.onNameChanged,
    required this.onDosageChanged,
    required this.onDosageUnitChanged,
    required this.onFrequencyChanged,
    required this.onDurationChanged,
    required this.onDurationUnitChanged,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '💊 Datos del Medicamento',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: nameController,
              label: 'Nombre del medicamento',
              onChanged: onNameChanged,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomTextField(
                    controller: dosageController,
                    label: 'Dosis',
                    onChanged: onDosageChanged,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: CustomDropDown(
                    options: dosageUnits,
                    selectedValue: selectedDosageUnit,
                    onChanged: onDosageUnitChanged,
                    label: 'Unidad',
                    fillColor: const Color(0xFF42A5F5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomDropDown(
              options: frequencyOptions,
              selectedValue: selectedFrequency,
              onChanged: onFrequencyChanged,
              label: 'Frecuencia',
              hintText: 'Seleccionar frecuencia',
              fillColor: const Color(0xFF64B5F6),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomTextField(
                    controller: durationAmountController,
                    label: 'Duración',
                    onChanged: onDurationChanged,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: CustomDropDown(
                    options: durationUnits,
                    selectedValue: selectedDurationUnit,
                    onChanged: onDurationUnitChanged,
                    label: 'Unidad',
                    fillColor: const Color(0xFF42A5F5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF64B5F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Añadir Medicamento',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// Modal para fecha, hora y descripción
class DateTimeDescriptionModal extends StatelessWidget {
  final TextEditingController descriptionController;
  final DateTime? selectedDateTime;
  final Function(String) onDescriptionChanged;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final VoidCallback onConfirm;

  const DateTimeDescriptionModal({
    super.key,
    required this.descriptionController,
    required this.selectedDateTime,
    required this.onDescriptionChanged,
    required this.onPickDate,
    required this.onPickTime,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📅 Fecha, Hora y Notas',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DateTimeButton(
                    icon: Icons.calendar_today,
                    label: selectedDateTime == null
                        ? 'Fecha'
                        : '${selectedDateTime!.day.toString().padLeft(2, '0')}/${selectedDateTime!.month.toString().padLeft(2, '0')}/${selectedDateTime!.year}',
                    onTap: onPickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DateTimeButton(
                    icon: Icons.access_time,
                    label: selectedDateTime == null
                        ? 'Hora'
                        : '${selectedDateTime!.hour.toString().padLeft(2, '0')}:${selectedDateTime!.minute.toString().padLeft(2, '0')}',
                    onTap: onPickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: descriptionController,
              label: 'Instrucciones especiales',
              maxLines: 5,
              minLines: 3,
              onChanged: onDescriptionChanged,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF64B5F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ============================================
// WIDGETS REUTILIZABLES - SECCIONES
// ============================================

/// Sección de información del paciente
class PatientInfoSection extends StatelessWidget {
  final TextEditingController elderIdController;
  final Function(String) onElderIdChanged;

  const PatientInfoSection({
    super.key,
    required this.elderIdController,
    required this.onElderIdChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(icon: '👤', title: 'Información del Paciente'),
          const SizedBox(height: 16),
          CustomTextField(
            controller: elderIdController,
            label: 'ID del adulto mayor',
            onChanged: onElderIdChanged,
          ),
        ],
      ),
    );
  }
}

/// Sección de lista de medicamentos añadidos
class MedicationListSection extends StatelessWidget {
  final List<dynamic> medications;
  final List<String> frequencyOptions;

  const MedicationListSection({
    super.key,
    required this.medications,
    required this.frequencyOptions,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(icon: '✅', title: 'Medicamentos Añadidos'),
          const SizedBox(height: 12),
          ...medications.map(
            (med) => MedicationCard(
              medication: med,
              frequencyText: frequencyOptions[med.frequency],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// WIDGETS REUTILIZABLES - COMPONENTES
// ============================================

/// Widget para crear tarjetas de sección con sombra
class SectionCard extends StatelessWidget {
  final Widget child;

  const SectionCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Widget para títulos de sección con ícono
class SectionTitle extends StatelessWidget {
  final String icon;
  final String title;

  const SectionTitle({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$icon $title',
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0D47A1),
      ),
    );
  }
}

/// Widget para botones de fecha y hora
class DateTimeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DateTimeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF64B5F6), Color(0xFF42A5F5)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade300.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget para botones grandes con ícono opcional
class LargeButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color backgroundColor;
  final double fontSize;
  final VoidCallback? onPressed;

  const LargeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    this.fontSize = 20,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return icon != null
        ? ElevatedButton.icon(
            icon: Icon(icon, size: 30),
            label: Text(
              label,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
            ),
            onPressed: onPressed,
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
            ),
            child: Text(
              label,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
          );
  }
}

/// Widget para mostrar tarjeta de medicamento añadido
class MedicationCard extends StatelessWidget {
  final dynamic medication;
  final String frequencyText;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.frequencyText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE1F5FE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF42A5F5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medication.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Dosis: ${medication.dosage}\nFrecuencia: $frequencyText\nDuración: ${medication.duration} días',
            style: const TextStyle(fontSize: 18, color: Color(0xFF1565C0)),
          ),
        ],
      ),
    );
  }
}
