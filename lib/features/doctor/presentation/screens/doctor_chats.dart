import 'package:flutter/material.dart';

class DoctorChats extends StatelessWidget {
  const DoctorChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Chats del doc')],
        ),
      ),
    );
  }
}
