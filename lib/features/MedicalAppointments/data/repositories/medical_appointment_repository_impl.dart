/*
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/network/endpoints.dart';
import 'package:heraguard_frontend/features/MedicalAppointments/data/models/medical_appointment.dart';
import 'package:heraguard_frontend/features/MedicalAppointments/domain/repositories/medical_appointment_repository.dart';

class MedicalAppointmentRepositoryImpl implements MedicalAppointmentRepository {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<MedicalAppointment> createMedicalAppointment(MedicalAppointment medicalAppointment) async {
    final response = await _apiClient.post(
      Endpoints.medicalAppointment,
      medicalAppointment.toJson(),
    );
    return MedicalAppointment.fromJson(response.data);
  }

  @override
  Future<List<MedicalAppointment>> getMedicalAppointments() async {
    final response = await _apiClient.get(Endpoints.medicalAppointment);
    final List<dynamic> responseData = response.data;
    return responseData.map((json) => MedicalAppointment.fromJson(json)).toList();
  }

  @override
  Future<MedicalAppointment> getMedicalAppointmentById(String medicalAppointmentId) async {
    final response = await _apiClient.get('${Endpoints.medicalAppointment}/$medicalAppointmentId');
    return MedicalAppointment.fromJson(response.data);
  }

  @override
  Future<MedicalAppointment> updateMedicalAppointment(MedicalAppointment medicalAppointment) async {
    final response = await _apiClient.dio.put(
      '${Endpoints.medicalAppointment}/${medicalAppointment.medicalAppointmentId}',
      data: medicalAppointment.toJson(),
    );
    return MedicalAppointment.fromJson(response.data);
  }

  @override
  Future<void> deleteMedicalAppointment(String medicalAppointmentId) async {
    await _apiClient.delete('${Endpoints.medicalAppointment}/$medicalAppointmentId');
  }
}
*/