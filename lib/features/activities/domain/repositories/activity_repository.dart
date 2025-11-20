import 'package:flutter/material.dart';
import 'package:heraguard_frontend/features/activities/domain/entities/activity.dart';

abstract class ActivityRepository {
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
  );
}
