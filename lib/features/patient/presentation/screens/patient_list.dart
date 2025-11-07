import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';
import 'package:heraguard_frontend/core/widgets/appbar_widget.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'Pacientes'),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Doctor Pacientes Nueva rura')],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addPatient);
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.person_add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavbarBottom(),
    );
  }
}
