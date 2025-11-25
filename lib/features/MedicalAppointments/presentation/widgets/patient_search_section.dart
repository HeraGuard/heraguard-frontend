import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/widgets/animated_field_wrapper_bryan.dart';
import 'package:heraguard_frontend/features/auth/data/models/auth_response.dart';
import 'package:heraguard_frontend/features/user_search/presentation/widgets/user_search_field.dart';

class PatientSearchSectionAppointment extends StatelessWidget {
  final Function(String elderId, String elderName) onPatientSelected;

  const PatientSearchSectionAppointment({
    super.key,
    required this.onPatientSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedFieldWrapper(
      label: 'Buscar Paciente',
      field: UserSearchField(
        roleId: 1,
        onUserSelected: (User user) {
          final elderId = user.id.toString();
          final elderName = '${user.name} ${user.lastName}'.trim();
          
          onPatientSelected(elderId, elderName);
        },
      ),
    );
  }
}