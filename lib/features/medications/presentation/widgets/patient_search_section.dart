import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/widgets/animated_field_wrapper_bryan.dart';
import 'package:heraguard_frontend/features/user_search/presentation/widgets/user_search_field.dart';

class PatientSearchSection extends StatelessWidget {
  final Function(String) onPatientSelected;

  const PatientSearchSection({super.key, required this.onPatientSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedFieldWrapper(
      label: 'Buscar Paciente',
      field: UserSearchField(
        roleId: 1,
        onUserSelected: (user) {
          onPatientSelected(user.id.toString());
          print('Usuario seleccionado: ${user.name} ${user.email}');
        },
      ),
    );
  }
}
