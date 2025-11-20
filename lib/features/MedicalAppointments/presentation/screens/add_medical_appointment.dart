import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:heraguard_frontend/core/widgets/date_widget.dart';
import 'package:heraguard_frontend/core/widgets/time_widget.dart';

class AddMedicalAppointment extends StatefulWidget {
  const AddMedicalAppointment({super.key});

  @override
  State<AddMedicalAppointment> createState() => _AddMedicalAppointmentState();
}

class _AddMedicalAppointmentState extends State<AddMedicalAppointment> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Colores (sin cambios)
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color accentGreen = Color(0xFF43A047);
  static const Color accentRed = Color(0xFFE53935);
  static const Color cardColor = Colors.white;
  static const Color bgColor = Color(0xFFF5F7FA);

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: primaryBlue,
            onPrimary: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: primaryBlue),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: primaryBlue,
            onPrimary: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: primaryBlue),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null) {
      final timeStr = _selectedTime!.format(context);
      showDialog(
        context: context,
        builder: (_) => ZoomIn(
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: accentGreen, size: 28),
                const SizedBox(width: 8),
                Text('¡Cita Guardada!', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              'Paciente: ${_nameController.text}\n'
              'Fecha: ${_formatDate(_selectedDate!)}\n'
              'Hora: $timeStr\n'
              'Descripción: ${_descriptionController.text}',
              style: GoogleFonts.roboto(fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Completa todos los campos'),
          backgroundColor: accentRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Widget _buildField({required String label, required Widget field}) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: field,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Nueva Cita Médica',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: primaryBlue,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: FadeIn(
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Nombre del paciente
                _buildField(
                  label: 'Nombre del Paciente',
                  field: TextFormField(
                    controller: _nameController,
                    style: GoogleFonts.roboto(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Ej. Juan Pérez',
                      hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey[600]),
                      filled: true,
                      fillColor: cardColor,
                      prefixIcon: const Icon(Icons.person_outline, color: primaryBlue),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: primaryBlue, width: 2),
                      ),
                    ),
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    // DateWidget
                    DateWidget(
                      selectedDate: _selectedDate,
                      onTap: _pickDate,
                      validator: () => _selectedDate == null ? 'Selecciona una fecha' : null,
                    ),
                    const SizedBox(width: 16),
                    // TimeWidget
                    TimeWidget(
                      selectedTime: _selectedTime,
                      onTap: _pickTime,
                      validator: () => _selectedTime == null ? 'Selecciona una hora' : null,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Descripción
                _buildField(
                  label: 'Descripción de la Cita',
                  field: TextFormField(
                    controller: _descriptionController,
                    style: GoogleFonts.roboto(fontSize: 18),
                    minLines: 4,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Motivo de la consulta, síntomas, etc.',
                      hintStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.grey[600]),
                      filled: true,
                      fillColor: cardColor,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(top: 16, left: 4),
                        child: Icon(Icons.note_alt_outlined, color: primaryBlue),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: primaryBlue, width: 2),
                      ),
                    ),
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                ),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: ElasticIn(
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentGreen,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 8,
                            shadowColor: accentGreen.withOpacity(0.4),
                          ),
                          child: Text(
                            'Guardar Cita',
                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElasticIn(
                        delay: const Duration(milliseconds: 100),
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: accentRed,
                            side: const BorderSide(color: accentRed, width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            'Cancelar',
                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}