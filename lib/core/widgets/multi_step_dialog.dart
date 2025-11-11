import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class MultiStepDialog extends StatefulWidget {
  final String title;
  final List<DialogStep> steps;
  final Function(Map<String, dynamic>) onComplete;

  const MultiStepDialog({
    Key? key,
    required this.title,
    required this.steps,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<MultiStepDialog> createState() => _MultiStepDialogState();
}

class _MultiStepDialogState extends State<MultiStepDialog> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final Map<String, dynamic> _formData = {};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < widget.steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      // Último paso, enviar datos
      widget.onComplete(_formData);
      Navigator.of(context).pop();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.bgColor,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título y botón de cerrar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Indicador de progreso
            Row(
              children: List.generate(
                widget.steps.length,
                (index) => Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index <= _currentStep
                          ? AppColors.primaryBlue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Contenido de los pasos
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.steps.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: widget.steps[index].buildContent(_formData),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Botones de navegación
            Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.primaryBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Atrás',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 10),
                Expanded(
                  flex: _currentStep > 0 ? 1 : 1,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      _currentStep == widget.steps.length - 1
                          ? 'Confirmar'
                          : 'Siguiente',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DialogStep {
  final String title;
  final Widget Function(Map<String, dynamic> formData) buildContent;

  DialogStep({required this.title, required this.buildContent});
}
