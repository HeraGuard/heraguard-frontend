import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/network/endpoints.dart';
import 'package:heraguard_frontend/features/MedicalAppointments/datasources/medical_appointments_local_sources.dart';
import '../../domain/entities/medical_appointment.dart';
import '../../domain/repositories/medical_appointment_repository.dart';
import '../models/medical_appointment_dto.dart';

class MedicalAppointmentRepositoryImpl implements MedicalAppointmentRepository {
  final MedicalAppointmentLocalDataSource localDataSource;
  final ApiClient apiClient;

  MedicalAppointmentRepositoryImpl({
    required this.localDataSource,
    required this.apiClient,
  });

  @override
  Future<void> addMedicalAppointment(MedicalAppointment appointment) async {
    final dto = MedicalAppointmentDto.fromDomain(appointment);

    final hasConnection = (await Connectivity().checkConnectivity())
        .where((r) => r == ConnectivityResult.mobile || r == ConnectivityResult.wifi || r == ConnectivityResult.vpn)
        .isNotEmpty;

    if (hasConnection) {
      try {
        await _sendToBackend(dto);
        await localDataSource.insertAppointmentAsSynced(dto);
        return;
      } catch (e) {
        await _saveLocallyAsPending(dto);
      }
    } else {
      await _saveLocallyAsPending(dto);
    }
  }

  Future<void> _sendToBackend(MedicalAppointmentDto dto) async {
    final payload = {
      "nameOfPatient": dto.nameOfPatient,
      "date": "${dto.date.year}-${dto.date.month.toString().padLeft(2, '0')}-${dto.date.day.toString().padLeft(2, '0')}",
      "time": "${dto.time}:00",
      "description": dto.description,
      "doctorId": dto.doctorId,
      "caregiverId": dto.caregiverId,
      "elderId": dto.elderId,
    };
    final response = await apiClient.post(
      Endpoints.medicalAppointment,
      payload,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error ${response.statusCode}: ${response.data}');
    }
  }

  Future<void> _saveLocallyAsPending(MedicalAppointmentDto dto) async {
    await localDataSource.insertAppointmentAsPending(dto);
  }

  @override
  Future<void> syncPendingAppointments() async {
    final pendientes = await localDataSource.getPendingAppointments();
    if (pendientes.isEmpty) return;

    for (var dto in pendientes) {
      try {
        await _sendToBackend(dto);
        await localDataSource.deleteAppointment(dto.medicalAppointmentId);
      } catch (e) {
        // Esto es intencionalmente vacío para ignorar errores.
      }
    }
  }
}