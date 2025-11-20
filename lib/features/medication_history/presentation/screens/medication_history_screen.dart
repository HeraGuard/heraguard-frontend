import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heraguard_frontend/core/constants/app_colors.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/widgets/custom_app_bar_bryan.dart';
import 'package:heraguard_frontend/features/medications/data/datasources/medication_local_data_source.dart';
import 'package:heraguard_frontend/features/medications/data/repositories/medication_repository_impl.dart';
import '../bloc/medication_history_bloc.dart';
import '../bloc/medication_history_event.dart';
import '../bloc/medication_history_state.dart';
import '../widgets/medication_history_card.dart';

class MedicationHistoryScreen extends StatelessWidget {
  const MedicationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el userId desde los argumentos de navegación
    final userId = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return BlocProvider(
      create: (context) => MedicationHistoryBloc(
        medicationRepository: MedicationRepositoryImpl(
          localDataSource: MedicationLocalDataSource(),
          apiClient: ApiClient(),
        ),
      )..add(LoadMedicationHistoryEvent(userId)),
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: const CustomAppBar(title: 'Historial de Medicamentos'),
        body: BlocBuilder<MedicationHistoryBloc, MedicationHistoryState>(
          builder: (context, state) {
            if (state is MedicationHistoryLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accentGreen),
              );
            }

            if (state is MedicationHistoryError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar historial',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: GoogleFonts.poppins(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<MedicationHistoryBloc>().add(
                            LoadMedicationHistoryEvent(userId),
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGreen,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is MedicationHistoryEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sin medicamentos',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Aún no hay medicamentos registrados',
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            if (state is MedicationHistoryLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<MedicationHistoryBloc>().add(
                    LoadMedicationHistoryEvent(userId),
                  );
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: state.medications.length,
                  itemBuilder: (context, index) {
                    return MedicationHistoryCard(
                      medication: state.medications[index],
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
