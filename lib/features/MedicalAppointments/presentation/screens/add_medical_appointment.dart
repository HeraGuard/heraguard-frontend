import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heraguard_frontend/core/constants/app_colors.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/widgets/custom_app_bar_bryan.dart';
import 'package:heraguard_frontend/core/widgets/date_widget.dart';
import 'package:heraguard_frontend/core/widgets/time_widget.dart';
import 'package:heraguard_frontend/features/MedicalAppointments/data/repositories/medical_appointment_repository_impl.dart';
import 'package:heraguard_frontend/features/MedicalAppointments/datasources/medical_appointments_local_sources.dart';
import 'package:heraguard_frontend/features/MedicalAppointments/domain/entities/medical_appointment.dart';
import 'package:heraguard_frontend/features/MedicalAppointments/presentation/bloc/medical_appointment_bloc.dart';
import 'package:heraguard_frontend/features/MedicalAppointments/presentation/bloc/medical_appointment_event.dart';
import 'package:heraguard_frontend/features/MedicalAppointments/presentation/bloc/medical_appointment_state.dart';
import 'package:heraguard_frontend/features/MedicalAppointments/presentation/widgets/description_field.dart';
import 'package:heraguard_frontend/features/MedicalAppointments/presentation/widgets/patient_search_section.dart';
import 'package:heraguard_frontend/features/MedicalAppointments/presentation/widgets/save_appointment_button.dart';
import 'package:heraguard_frontend/features/user_search/data/datasources/user_search_remote_datasource.dart';
import 'package:heraguard_frontend/features/user_search/data/repositories/user_search_repository_impl.dart';
import 'package:heraguard_frontend/features/user_search/domain/usecases/search_users_usecase.dart';
import 'package:heraguard_frontend/features/user_search/presentation/bloc/user_search_bloc.dart';

class AddMedicalAppointment extends StatefulWidget {
  const AddMedicalAppointment({super.key});

  @override
  State<AddMedicalAppointment> createState() =>
      _AddMedicalAppointmentPageState();
}

class _AddMedicalAppointmentPageState extends State<AddMedicalAppointment> {
  String _selectedElderId = '';
  String _selectedElderName = '';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _descriptionController = TextEditingController();

  String? get currentDoctorId => null;
  String? get currentDoctorName => 'Dr. Juan Pérez';

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      setState(() {});
    });
  }

  void _onPatientSelected(String elderId, String elderName) {
    setState(() {
      _selectedElderId = elderId;
      _selectedElderName = elderName;
    });
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _saveAppointment(BuildContext context) {
    if (_selectedElderId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Debes seleccionar un paciente',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Debes seleccionar fecha y hora',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Debes agregar una descripción',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final appointment = MedicalAppointment(
      medicalAppointmentId: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      nameOfPatient: _selectedElderName,
      date: _selectedDate!,
      time:
          '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
      description: _descriptionController.text.trim(),
      doctorId: currentDoctorId,
      caregiverId: null,
      elderId: _selectedElderId,
      doctorName: currentDoctorName,
      caregiverName: null,
      elderName: _selectedElderName,
    );

    context
        .read<MedicalAppointmentBloc>()
        .add(AddMedicalAppointmentEvent(appointment));
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserSearchBloc(
            searchUsersUseCase: SearchUsersUseCase(
              UserSearchRepositoryImpl(
                remoteDataSource: UserSearchRemoteDataSourceImpl(
                  apiClient: ApiClient(),
                ),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => MedicalAppointmentBloc(
            repository: MedicalAppointmentRepositoryImpl(
              localDataSource: MedicalAppointmentLocalDataSource(),
              apiClient: ApiClient(),
            ),
          ),
        ),
      ],
      child: BlocListener<MedicalAppointmentBloc, MedicalAppointmentState>(
        listener: (context, state) {
          if (state is MedicalAppointmentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Cita médica guardada exitosamente',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: AppColors.accentGreen,
                duration: const Duration(seconds: 2),
              ),
            );
            setState(() {
              _selectedElderId = '';
              _selectedElderName = '';
              _selectedDate = null;
              _selectedTime = null;
              _descriptionController.clear();
            });
          } else if (state is MedicalAppointmentSyncSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Citas sincronizadas ✓',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: AppColors.accentGreen,
              ),
            );
          } else if (state is MedicalAppointmentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error: ${state.error}',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.bgColor,
          appBar: const CustomAppBar(title: 'Agendar Cita Médica'),
          body: BlocBuilder<MedicalAppointmentBloc, MedicalAppointmentState>(
            builder: (context, state) {
              return Stack(
                children: [
                  FadeIn(
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView(
                        children: [
                          PatientSearchSectionAppointment(
                            onPatientSelected: _onPatientSelected,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              DateWidget(
                                selectedDate: _selectedDate,
                                onTap: _selectDate,
                              ),
                              const SizedBox(width: 16),
                              TimeWidget(
                                selectedTime: _selectedTime,
                                onTap: _selectTime,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          DescriptionField(
                            controller: _descriptionController,
                          ),
                          const SizedBox(height: 32),
                          SaveAppointmentButton(
                            isEnabled: _selectedElderId.isNotEmpty &&
                                _selectedDate != null &&
                                _selectedTime != null &&
                                _descriptionController.text.trim().isNotEmpty &&
                                state is! MedicalAppointmentLoading,
                            onPressed: () => _saveAppointment(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state is MedicalAppointmentLoading)
                    Container(
                      color: Colors.black26,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}