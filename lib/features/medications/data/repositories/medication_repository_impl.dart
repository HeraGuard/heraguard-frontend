import 'package:flutter/widgets.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/network/endpoints.dart';
import 'package:heraguard_frontend/features/medications/data/models/medication_intake_dto.dart';
import 'package:heraguard_frontend/features/medications/domain/entities/medication_intake.dart';
import '../../domain/entities/medication.dart';
import '../../domain/repositories/medication_repository.dart';
import '../datasources/medication_local_data_source.dart';
import '../models/medication_dto.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationLocalDataSource localDataSource;
  final ApiClient apiClient;
  /*
  final MedicationNotificationScheduler _notificationScheduler =
      MedicationNotificationScheduler();*/

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

    final isConnected =
        connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);

    if (isConnected) {
      try {
        final response = await apiClient.post(Endpoints.prescriptions, {
          'elderId': elderId,
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
          for (var medication in medications) {
            /*await _notificationScheduler.scheduleMedicationNotifications(
              medication,
            );*/

            await localDataSource.deleteAllTempByNameAndElder(
              name: medication.name,
              elderId: medication.elderId,
            );
          }
          return;
        }
      } catch (e) {
        await _saveLocallyAsPending(medications, elderId);
      }
    } else {
      await _saveLocallyAsPending(medications, elderId);
    }
  }

  Future<void> _saveLocallyAsPending(
    List<Medication> medications,
    String elderId, {
    bool isOffline = false,
  }) async {
    if (!isOffline) {
      return;
    }
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
      /*await _notificationScheduler.scheduleMedicationNotifications(
        medWithElder,
      );*/
    }
  }

  @override
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
        debugPrint('Error sincronizando grupo de ${entry.key}: $e');
      }
    }
  }

  @override
  Future<List<Medication>> getMedicationsByUser(String userId) async {
    List<Medication> result = [];
    try {
      final response = await apiClient.get('/api/Medication/user/$userId');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        final remoteMeds = data
            .map((json) => MedicationDto.fromJson(json))
            .toList();
        result.addAll(remoteMeds);
      } else {
        throw Exception(
          'Error al obtener medicamentos: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error al obtener historial: $e');
      rethrow;
    }

    try {
      final localMeds = await localDataSource.getPendingMedicationsByElder(
        userId,
      );
      final remoteIds = result.map((e) => e.medicationId).toSet();

      for (final med in localMeds) {
        if (!remoteIds.contains(med.medicationId)) {
          result.add(med);
        }
      }
    } catch (e) {
      debugPrint(' Error al obtener medicamentos locales: $e');
    }

    return result;
  }

  @override
  Future<void> deleteMedication(String medicationId) async {
    try {
      //await _notificationScheduler.cancelMedicationNotifications(medicationId);

      if (medicationId.startsWith('temp_')) {
        await localDataSource.deleteMedication(medicationId);
        return;
      }

      final response = await apiClient.delete('/api/Medication/$medicationId');

      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw Exception('Error al eliminar: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error al eliminar medicamento: $e');
      rethrow;
    }
  }

  @override
  Future<void> confirmIntake({
    required String intakeId,
    required DateTime actualTime,
    required String userId,
    String? notes,
  }) async {
    await apiClient.post('/api/medication-intake/confirm', {
      'ScheduleId': intakeId,
      'ActualTime': actualTime.toIso8601String(),
      'ConfirmedByUserId': userId,
      'Notes': notes,
    });
  }

  @override
  Future<void> skipIntake({
    required String intakeId,
    required String userId,
    String? reason,
  }) async {
    await apiClient.post('/api/medication-intake/skip', {
      'ScheduleId': intakeId,
      'UserId': userId,
      'Reason': reason,
    });
  }

  @override
  Future<MedicationIntake> getIntakeById(String intakeId) async {
    final response = await apiClient.get('/api/medication-intake/$intakeId');

    if (response.statusCode == 200) {
      return MedicationIntakeDto.fromJson(response.data);
    }
    throw Exception('No se encontró la toma');
  }
}
