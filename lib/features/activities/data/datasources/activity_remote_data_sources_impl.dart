import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/network/api_client.dart';
import 'package:heraguard_frontend/core/network/endpoints.dart';
import 'package:heraguard_frontend/features/activities/data/datasources/activity_remote_data_sources.dart';
import 'package:heraguard_frontend/features/activities/data/models/activity_model.dart';

class ActivityRemoteDataSourcesImpl implements ActivityRemoteDataSources {
  final ApiClient apiClient;

  ActivityRemoteDataSourcesImpl({required this.apiClient});

  @override
  Future<ActivityModel> addActivity(
    String id,
    String name,
    String frequency,
    TimeOfDay recommendedTime,
    String duration,
    String? notes,
    String? elderId,
    String? doctorId,
    String? caregiverId,
  ) async {
    final response = await apiClient.post(Endpoints.addActivity, {
      'name': name,
      'frequency': frequency,
      'recommendedTime': '${recommendedTime.hour}:${recommendedTime.minute}:00',
      'duration': duration,
      'notes': notes,
      'elderId': elderId,
      'doctorId': doctorId,
      'caregiverId': caregiverId,
    });
    return ActivityModel.fromJson(response.data);
  }
}
