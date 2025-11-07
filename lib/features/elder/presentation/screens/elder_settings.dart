import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';

class ElderSettings extends StatelessWidget {
const ElderSettings({ super.key });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Settings Elder')],
        ),
      ),
      bottomNavigationBar: NavbarBottom(),
    );
  }
}