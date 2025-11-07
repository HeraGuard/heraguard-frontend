import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';

class ElderNotifications extends StatelessWidget {
const ElderNotifications({ super.key });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Notifications Elder')],
        ),
      ),
      bottomNavigationBar: NavbarBottom(),
    );
  }
}