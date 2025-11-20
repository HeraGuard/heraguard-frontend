import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String name;
  final String frequency;
  final TimeOfDay recommendedTime;
  final String duration;
  final String? notes;
  final String? elderId;
  final String? doctorId;
  final String? caregiverId;

  Activity({
    required this.id,
    required this.name,
    required this.frequency,
    required this.recommendedTime,
    required this.duration,
    this.notes,
    this.elderId,
    this.doctorId,
    this.caregiverId,
  });
}
