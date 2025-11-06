import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/network/endpoints.dart';

import '../../domain/entities/medication.dart';
import '../../domain/repositories/medication_repository.dart';
import '../models/medication_dto.dart';
import '../models/prescription_request_dto.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final ApiClient apiClient = ApiClient();

  @override
  Future<void> addPrescription({
    required String elderId,
    required DateTime date,
    required List<Medication> medications,
  }) async {
    final dto = PrescriptionRequestDto(
      elderId: elderId,
      date: date.toUtc().toIso8601String(),
      medications: medications.map(MedicationDto.fromDomain).toList(),
    );
    try {
      final response = await apiClient.post(
        Endpoints.prescriptions, // endpoint centralizado
        dto.toJson(),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al enviar prescripción');
      }
    } catch (e) {
      rethrow;
    }
  }
}
