import 'package:flutter/material.dart';
import 'package:heraguard_frontend/features/activities/domain/entities/activity.dart';

class ActivityModel extends Activity {
  ActivityModel({
    required super.id,
    required super.name,
    required super.frequency,
    required super.recommendedTime,
    required super.duration,
    super.notes,
    super.elderId,
    super.doctorId,
    super.caregiverId,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['activityId'] ?? '',
      name: json['name'] ?? '',
      frequency: json['frequency'] ?? '',
      recommendedTime: _parseTime(json['recommendedTime']),
      duration: json['duration'] ?? '',
      notes: json['notes'],
      elderId: json['elderId'],
      doctorId: json['doctorId'],
      caregiverId: json['caregiverId'],
    );
  }

  static TimeOfDay _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      return const TimeOfDay(hour: 12, minute: 0);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'frequency': frequency,
      'recommendedTime': '${recommendedTime.hour}:${recommendedTime.minute}:00',
      'duration': duration,
      'notes': notes,
      'elderId': elderId,
      'doctorId': doctorId,
      'caregiverId': caregiverId,
    };
  }
}
