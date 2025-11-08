import 'package:heraguard_frontend/features/elder/domain/entities/elder.dart';

class ElderModel extends Elder {
  ElderModel({
    required super.id,
    required super.name,
    required super.lastName,
    required super.email,
  });

  factory ElderModel.fromJson(Map<String, dynamic> json) {
    return ElderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'lastName': lastName, 'email': email};
  }
}
