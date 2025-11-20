import 'package:flutter/material.dart';
import 'package:heraguard_frontend/features/activities/data/models/activity_model.dart';

abstract class ActivityRemoteDataSources {
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
  );
}
