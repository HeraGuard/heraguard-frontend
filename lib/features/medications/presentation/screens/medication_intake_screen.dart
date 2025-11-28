import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:heraguard_frontend/features/medications/presentation/bloc/medication_intake_bloc.dart';
import 'package:heraguard_frontend/features/medications/data/models/medication_intake_dto.dart';

class MedicationIntakeScreen extends StatelessWidget {
  final String intakeId;
  const MedicationIntakeScreen({required this.intakeId, super.key});

  @override
  Widget build(BuildContext context) {
    // Aquí NO creas BlocProvider, ya lo creó el RouteGenerator
    return BlocBuilder<MedicationIntakeBloc, MedicationIntakeState>(
      builder: (context, state) {
        if (state is IntakeLoading) {
          return Scaffold(
            appBar: AppBar(title: const Text("Toma de Medicamento")),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is IntakeFailure) {
          return Scaffold(
            appBar: AppBar(title: const Text("Toma de Medicamento")),
            body: Center(child: Text("Error: ${state.error}")),
          );
        }

        if (state is IntakeLoaded) {
          final intake = state.intake as MedicationIntakeDto;

          final String fecha = DateFormat(
            'dd/MM/yyyy – hh:mm a',
          ).format(intake.scheduledTime);

          return Scaffold(
            appBar: AppBar(title: const Text('Toma de medicamento')),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Medicamento: ${intake.medicationName}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('Dosis: ${intake.dosage}'),
                  const SizedBox(height: 8),
                  Text('Programada: $fecha'),
                  const SizedBox(height: 8),
                  Text('Estado: ${intake.status}'),
                  const Spacer(),
                  if (intake.status == "pending") ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text('Marcar como tomada'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          context.read<MedicationIntakeBloc>().add(
                            ConfirmIntake(
                              intake.intakeId,
                              DateTime.now(),
                              intake.elderId,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.skip_next),
                        label: const Text('Omitir'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: () {
                          context.read<MedicationIntakeBloc>().add(
                            SkipIntake(
                              intake.intakeId,
                              intake.elderId,
                              reason: 'Omitido',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Toma de Medicamento")),
          body: const Center(child: Text('No hay datos.')),
        );
      },
    );
  }
}
