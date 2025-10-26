import 'package:flutter/material.dart';

class ToggleRole extends StatelessWidget {
  final String? selectedRole;
  final ValueChanged<String?> onRoleChanged;

  const ToggleRole({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona tu rol',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 10),
        ToggleButtons(
          isSelected: [
            selectedRole == 'adulto_mayor',
            selectedRole == 'cuidador',
            selectedRole == 'doctor',
          ],
          onPressed: (int index) {
            String newRole;
            switch (index) {
              case 0:
                newRole = 'adulto_mayor';
                break;
              case 1:
                newRole = 'cuidador';
                break;
              case 2:
                newRole = 'doctor';
                break;
              default:
                newRole = 'adulto_mayor';
            }
            onRoleChanged(newRole);
          },
          borderColor: Colors.grey,
          selectedBorderColor: const Color(0xFF0040FF),
          borderRadius: BorderRadius.circular(8),
          selectedColor: Colors.white,
          fillColor: const Color(0xFF0040FF),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Adulto Mayor',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Cuidador',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Doctor',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
