import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get_it/get_it.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';
import 'package:heraguard_frontend/core/widgets/animated_field_wrapper_bryan.dart';
import 'package:heraguard_frontend/core/widgets/appbar_widget.dart';
import 'package:heraguard_frontend/core/widgets/custom_button.dart';
import 'package:heraguard_frontend/core/widgets/custom_drop_down.dart';
import 'package:heraguard_frontend/core/widgets/custom_text_field.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';
import 'package:heraguard_frontend/features/activities/domain/usecases/add_activity_usecase.dart';
import 'package:heraguard_frontend/features/activities/presentation/bloc/activity_bloc.dart';
import 'package:heraguard_frontend/features/medications/presentation/widgets/patient_search_section.dart';
import 'package:heraguard_frontend/features/user_search/data/datasources/user_search_remote_datasource.dart';
import 'package:heraguard_frontend/features/user_search/data/repositories/user_search_repository_impl.dart';
import 'package:heraguard_frontend/features/user_search/domain/usecases/search_users_usecase.dart';
import 'package:heraguard_frontend/features/user_search/presentation/bloc/user_search_bloc.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  late TextEditingController _nameController;
  late TextEditingController _recommendedTimeController;
  late TextEditingController _notesController;

  String? _selectedFrequency;
  String? _selectedDuration;
  String _selectedElderId = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _recommendedTimeController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _recommendedTimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  final List<String> _frequency = [
    'Una sola vez',
    'Diario',
    'Cada 2 días',
    'Lunes a Viernes',
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

  void _onPatientSelected(String elderId, {String elderName = ''}) {
    setState(() {
      _selectedElderId = elderId;
    });
  }

  void _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _recommendedTimeController.text =
            '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _addActivity(BuildContext context) {
    if (_nameController.text.isEmpty ||
        _selectedFrequency == null ||
        _selectedDuration == null ||
        _recommendedTimeController.text.isEmpty ||
        _selectedElderId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final timeParts = _recommendedTimeController.text.split(':');
    final recommendedTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    context.read<ActivityBloc>().add(
      AddActivity(
        name: _nameController.text,
        frequency: _selectedFrequency!,
        recommendedTime: recommendedTime,
        duration: _selectedDuration!,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        elderId: _selectedElderId,
        doctorId: null,
        caregiverId: null,
      ),
    );
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
          create: (context) => ActivityBloc(
            addActivityUsecase: GetIt.instance<AddActivityUsecase>(),
          ),
        ),
      ],
      child: BlocListener<ActivityBloc, ActivityState>(
        listener: (context, state) {
          if (state is ActivityAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Actividad programada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.doctorHome,
              (route) => false,
            );
          } else if (state is ActivityError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppbarWidget(title: 'Programar Actividad'),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      PatientSearchSection(
                        onPatientSelected: _onPatientSelected,
                      ),
                      const SizedBox(height: 20),
                      AnimatedFieldWrapper(
                        label: 'Nombre de la Actividad',
                        field: CustomTextField(
                          controller: _nameController,
                          label: '',
                          keyboardType: TextInputType.text,
                          textCap: TextCapitalization.words,
                        ),
                        durationMs: 500,
                      ),
                      const SizedBox(height: 16),
                      AnimatedFieldWrapper(
                        label: 'Frecuencia',
                        field: CustomDropDown(
                          options: _frequency,
                          selectedValue: _selectedFrequency,
                          onChanged: _onFrequencyChanged,
                          label: '',
                          hintText: 'Seleccione la frecuencia',
                          fillColor: Colors.blue.shade100,
                        ),
                        durationMs: 600,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AnimatedFieldWrapper(
                              label: 'Hora Recomendada',
                              field: CustomTextField(
                                controller: _recommendedTimeController,
                                label: '',
                                icon: Icons.access_time,
                                readOnly: true,
                                onTap: _selectTime,
                                hintText: 'HH:MM',
                              ),
                              durationMs: 700,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AnimatedFieldWrapper(
                              label: 'Duración',
                              field: CustomDropDown(
                                options: _duration,
                                selectedValue: _selectedDuration,
                                onChanged: _onDurationChanged,
                                label: '',
                                hintText: 'Seleccione',
                                fillColor: Colors.blue.shade100,
                              ),
                              durationMs: 700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AnimatedFieldWrapper(
                        label: 'Notas (Opcional)',
                        field: CustomTextField(
                          controller: _notesController,
                          label: '',
                          maxLines: 5,
                          minLines: 3,
                        ),
                        durationMs: 800,
                      ),
                      const SizedBox(height: 30),
                      BlocBuilder<ActivityBloc, ActivityState>(
                        builder: (context, state) {
                          return FadeInUp(
                            duration: const Duration(milliseconds: 900),
                            child: CustomButton(
                              text: state is ActivityLoading
                                  ? 'Programando...'
                                  : 'Programar Actividad',
                              onPressed: state is ActivityLoading
                                  ? null
                                  : () => _addActivity(context),
                              width: 220,
                              height: 55,
                              fontSize: 20,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: CustomButton(
                          text: 'Cancelar',
                          onPressed: () => Navigator.pop(context),
                          backgroundColor: Colors.red,
                          width: 220,
                          height: 55,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: NavbarBottom(),
        ),
      ),
    );
  }
}
