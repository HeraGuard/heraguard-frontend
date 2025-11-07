import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';

class ElderAlert extends StatelessWidget {
const ElderAlert({ super.key });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Alert elder')],
        ),
      ),
      bottomNavigationBar: NavbarBottom(),
    );
  }
}