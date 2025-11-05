import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/widgets/card_home.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';

class ElderHome extends StatefulWidget {
  const ElderHome({Key? key}) : super(key: key);

  @override
  _ElderHomeState createState() => _ElderHomeState();
}

class _ElderHomeState extends State<ElderHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hera Guard')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardHome(
              title: 'Tomar medicamento',
              imagePath: 'assets/images/tomar_medicamento.jpg',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            CardHome(
              title: 'Proxima Cita',
              imagePath: 'assets/images/cita_medica.jpg',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            CardHome(
              title: 'Proxima Actividad',
              imagePath: 'assets/images/actividad.png',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
