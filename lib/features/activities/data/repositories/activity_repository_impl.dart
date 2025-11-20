import 'package:flutter/material.dart';
import 'package:heraguard_frontend/features/activities/data/datasources/activity_remote_data_sources.dart';
import 'package:heraguard_frontend/features/activities/domain/entities/activity.dart';
import 'package:heraguard_frontend/features/activities/domain/repositories/activity_repository.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDataSources remoteDataSources;

  ActivityRepositoryImpl({required this.remoteDataSources});

  @override
  Future<Activity> addActivity(
    String id,
    String name,
    String frequency,
    TimeOfDay recommendedTime,
    String duration,
    String? notes,
    String? elderId,
    String? doctorId,
    String? caregiverId,
  ) {
    return remoteDataSources.addActivity(
      id,
      name,
      frequency,
      recommendedTime,
      duration,
      notes,
      elderId,
      doctorId,
      caregiverId,
    );
  }
}
