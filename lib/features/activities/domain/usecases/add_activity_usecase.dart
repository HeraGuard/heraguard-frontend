import 'package:flutter/material.dart';
import 'package:heraguard_frontend/features/activities/domain/entities/activity.dart';
import 'package:heraguard_frontend/features/activities/domain/repositories/activity_repository.dart';

class AddActivityUsecase {
  final ActivityRepository repository;

  AddActivityUsecase(this.repository);

  Future<Activity> call(
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
    return repository.addActivity(
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
