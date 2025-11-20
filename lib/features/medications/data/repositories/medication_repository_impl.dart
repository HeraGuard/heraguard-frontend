import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/network/endpoints.dart';
import '../../domain/entities/medication.dart';
import '../../domain/repositories/medication_repository.dart';
import '../datasources/medication_local_data_source.dart';
import '../models/medication_dto.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationLocalDataSource localDataSource;
  final ApiClient apiClient;

  MedicationRepositoryImpl({
    required this.localDataSource,
    required this.apiClient,
  });

  @override
  Future<void> addPrescription({
    required String elderId,
    required DateTime date,
    required List<Medication> medications,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      try {
        // Formato que coincide con CreatePrescriptionCommand
        final response = await apiClient.post(Endpoints.prescriptions, {
          'elderId':
              elderId, // ← C# espera "ElderId" pero JSON es case-insensitive por defecto
          'doctorId': null,
          'date': DateTime.now().toUtc().toIso8601String(),
          'medications': medications
              .map(
                (med) => {
                  'name': med.name,
                  'description': med.description,
                  'dosage': med.dosage,
                  'frequency': med.frequency,
                  'duration': med.duration,
                  'startDate': med.startDate.toUtc().toIso8601String(),
                  'doctorId': null,
                  'caregiverId': null,
                  'elderId': elderId,
                },
              )
              .toList(),
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          return;
        }
      } catch (e) {
        print('Error al sincronizar con backend: $e');
        await _saveLocallyAsPending(medications, elderId);
        return;
      }
    } else {
      await _saveLocallyAsPending(medications, elderId);
    }
  }

  Future<void> _saveLocallyAsPending(
    List<Medication> medications,
    String elderId,
  ) async {
    for (var med in medications) {
      final medWithElder = Medication(
        medicationId:
            'temp_${DateTime.now().millisecondsSinceEpoch}_${medications.indexOf(med)}',
        name: med.name,
        description: med.description,
        dosage: med.dosage,
        frequency: med.frequency,
        duration: med.duration,
        startDate: med.startDate,
        doctorId: med.doctorId,
        elderId: elderId,
        caregiverId: med.caregiverId,
        doctorName: med.doctorName,
        caregiverName: med.caregiverName,
        elderName: med.elderName,
      );

      final dto = MedicationDto.fromDomain(medWithElder);
      await localDataSource.insertMedicationAsPending(dto);
    }
  }

  Future<void> syncPendingMedications() async {
    final pendientes = await localDataSource.getPendingMedications();
    if (pendientes.isEmpty) return;

    final Map<String, List<MedicationDto>> groupedByElder = {};
    for (var med in pendientes) {
      if (!groupedByElder.containsKey(med.elderId)) {
        groupedByElder[med.elderId] = [];
      }
      groupedByElder[med.elderId]!.add(med);
    }

    for (var entry in groupedByElder.entries) {
      try {
        final response = await apiClient.post(Endpoints.prescriptions, {
          'elderId': entry.key,
          'doctorId': null,
          'date': DateTime.now().toIso8601String(),
          'medications': entry.value
              .map(
                (e) => {
                  'name': e.name,
                  'description': e.description,
                  'dosage': e.dosage,
                  'frequency': e.frequency,
                  'duration': e.duration,
                  'startDate': e.startDate.toIso8601String(),
                  'doctorId': e.doctorId,
                  'caregiverId': e.caregiverId,
                  'elderId': e.elderId,
                },
              )
              .toList(),
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          for (var med in entry.value) {
            await localDataSource.deleteMedication(med.medicationId);
          }
        }
      } catch (e) {
        print('Error sincronizando grupo de ${entry.key}: $e');
      }
    }
  }

  @override
  Future<List<Medication>> getMedicationsByUser(String userId) async {
    try {
      final response = await apiClient.get('/api/Medication/user/$userId');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => MedicationDto.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al obtener medicamentos: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error al obtener historial: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMedication(String medicationId) async {
    try {
      print('🗑️ Eliminando medicamento: $medicationId');

      final response = await apiClient.delete('/api/Medication/$medicationId');

      print('✅ Response status: ${response.statusCode}');

      // Solo valida que NO sea un error (2xx = éxito)
      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw Exception('Error al eliminar: ${response.statusCode}');
      }

      print('✅ Medicamento eliminado exitosamente');
    } catch (e) {
      print('❌ Error al eliminar medicamento: $e');
      rethrow;
    }
  }
}
