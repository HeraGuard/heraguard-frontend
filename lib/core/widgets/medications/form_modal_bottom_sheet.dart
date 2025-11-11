import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

class FormModalBottomSheet extends StatefulWidget {
  final String title;
  final List<FormFieldConfig> fields;
  final Function(Map<String, dynamic>) onSubmit;

  const FormModalBottomSheet({
    Key? key,
    required this.title,
    required this.fields,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<FormModalBottomSheet> createState() => _FormModalBottomSheetState();
}

class _FormModalBottomSheetState extends State<FormModalBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var field in widget.fields) {
      _controllers[field.key] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> formData = {};
      _controllers.forEach((key, controller) {
        formData[key] = controller.text;
      });
      widget.onSubmit(formData);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Barra de arrastre
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              // Título
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              // Campos del formulario
              ...widget.fields.map((field) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: _controllers[field.key],
                    decoration: InputDecoration(
                      hintText: field.hint,
                      hintStyle: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                      filled: true,
                      fillColor: AppColors.cardColor,
                      prefixIcon: field.icon != null
                          ? Icon(field.icon, color: AppColors.primaryBlue)
                          : null,
                      contentPadding: const EdgeInsets.all(20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.primaryBlue,
                          width: 2,
                        ),
                      ),
                    ),
                    maxLines: field.maxLines,
                    validator: field.validator,
                  ),
                );
              }).toList(),
              const SizedBox(height: 10),
              // Botón de envío
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    'Guardar',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class FormFieldConfig {
  final String key;
  final String hint;
  final IconData? icon;
  final int maxLines;
  final String? Function(String?)? validator;

  FormFieldConfig({
    required this.key,
    required this.hint,
    this.icon,
    this.maxLines = 1,
    this.validator,
  });
}
