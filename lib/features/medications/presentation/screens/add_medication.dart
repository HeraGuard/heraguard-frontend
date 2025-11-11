import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heraguard_frontend/core/constants/app_colors.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/widgets/custom_app_bar_bryan.dart';
import 'package:heraguard_frontend/features/medications/presentation/widgets/add_medication_button.dart';
import 'package:heraguard_frontend/features/medications/presentation/widgets/add_medication_dialog.dart';
import 'package:heraguard_frontend/features/medications/presentation/widgets/empty_medications_widget.dart';
import 'package:heraguard_frontend/features/medications/presentation/widgets/medication_card_widget.dart';
import 'package:heraguard_frontend/features/medications/presentation/widgets/patient_search_section.dart';
import 'package:heraguard_frontend/features/medications/presentation/widgets/print_prescription_button.dart';
import 'package:heraguard_frontend/features/user_search/data/datasources/user_search_remote_datasource.dart';
import 'package:heraguard_frontend/features/user_search/data/repositories/user_search_repository_impl.dart';
import 'package:heraguard_frontend/features/user_search/domain/usecases/search_users_usecase.dart';
import 'package:heraguard_frontend/features/user_search/presentation/bloc/user_search_bloc.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final List<Map<String, dynamic>> _medications = [];
  String _selectedElderId = '';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _onPatientSelected(String elderId) {
    setState(() {
      _selectedElderId = elderId;
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onTimeSelected(TimeOfDay time) {
    setState(() {
      _selectedTime = time;
    });
  }

  void _onMedicationAdded(Map<String, dynamic> medication) {
    setState(() {
      _medications.add(medication);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Medicamento agregado', style: GoogleFonts.poppins()),
        backgroundColor: AppColors.accentGreen,
      ),
    );
  }

  void _removeMedication(int index) {
    setState(() {
      _medications.removeAt(index);
    });
  }

  void _printPrescription() {
    DateTime prescriptionDateTime = DateTime.now();
    if (_selectedDate != null && _selectedTime != null) {
      prescriptionDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    }

    final prescription = {
      "elderId": _selectedElderId,
      "date": prescriptionDateTime.toIso8601String(),
      "medications": _medications,
    };

    print('=== RECETA COMPLETA ===');
    print(prescription);
    print('======================');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Receta impresa en consola ✓',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppColors.accentGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserSearchBloc(
        searchUsersUseCase: SearchUsersUseCase(
          UserSearchRepositoryImpl(
            remoteDataSource: UserSearchRemoteDataSourceImpl(
              apiClient: ApiClient(),
            ),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: const CustomAppBar(title: 'Recetar Medicamento'),
        body: FadeIn(
          duration: const Duration(milliseconds: 500),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                PatientSearchSection(onPatientSelected: _onPatientSelected),
                const SizedBox(height: 32),

                AddMedicationButton(
                  onPressed: () => _showAddMedicationDialog(context),
                ),
                const SizedBox(height: 24),

                _buildMedicationsList(),
                const SizedBox(height: 32),

                PrintPrescriptionButton(
                  isEnabled:
                      _medications.isNotEmpty && _selectedElderId.isNotEmpty,
                  onPressed: _printPrescription,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddMedicationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddMedicationDialog(
        selectedDate: _selectedDate,
        selectedTime: _selectedTime,
        onDateSelected: _onDateSelected,
        onTimeSelected: _onTimeSelected,
        onMedicationAdded: _onMedicationAdded,
      ),
    );
  }

  Widget _buildMedicationsList() {
    if (_medications.isEmpty) {
      return const EmptyMedicationsWidget();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Medicamentos Agregados',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _medications.length,
          itemBuilder: (context, index) {
            return FadeInLeft(
              duration: const Duration(milliseconds: 400),
              child: MedicationCardWidget(
                medication: _medications[index],
                onDelete: () => _removeMedication(index),
              ),
            );
          },
        ),
      ],
    );
  }
}
