import 'package:flutter/material.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({super.key});

  @override
  State<AddActivity> createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  late TextEditingController _nameController;
  late TextEditingController _frequencyController;
  late TextEditingController _recommendedTimeController;
  late TextEditingController _durationController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _frequencyController = TextEditingController();
    _recommendedTimeController = TextEditingController();
    _durationController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _frequencyController.dispose();
    _recommendedTimeController.dispose();
    _durationController.dispose();
    _notesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Add Activity")],
        ),
      ),
    );
  }
}
