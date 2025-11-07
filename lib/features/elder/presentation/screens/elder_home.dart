import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';
import 'package:heraguard_frontend/core/widgets/appbar_widget.dart';
import 'package:heraguard_frontend/core/widgets/card_home.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';

class ElderHome extends StatelessWidget {
  const ElderHome({super.key});

  // Próximas acciones (solo para ver)
  final List<Map<String, dynamic>> _nextActions = const [
    {
      'title': 'Próxima Cita',
      'image': 'assets/images/cita_medica.jpg',
      //'route': AppRoutes.viewMedicalAppointment, // ← Pantalla para VER cita
    },
    {
      'title': 'Próximo Medicamento',
      'image': 'assets/images/tomar_medicamento.jpg',
      //'route': AppRoutes.viewMedication, // ← Pantalla para VER medicamento
    },
    {
      'title': 'Próxima Actividad',
      'image': 'assets/images/actividad.png',
      //'route': AppRoutes.viewActivity, // ← Pantalla para VER actividad
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppbarWidget(title: "HeraGuard"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // ← Espacio para navbar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Saludo
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Text(
                  '¡Hola!',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E88E5),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeInDown(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  'Aquí tienes todo lo que necesitas para tu salud.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Próximas acciones (imágenes grandes)
              FadeInUp(
                duration: const Duration(milliseconds: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Próximas Acciones',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._nextActions.map((action) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildNextActionCard(
                            context: context,
                            title: action['title'],
                            imagePath: action['image'],
                            onTap: () {
                              Navigator.pushNamed(context, action['route']);
                            },
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Tarjetas de acción rápida (AGREGAR)
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acciones Rápidas',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElasticIn(
                            child: CardHome(
                              title: 'Agregar Medicamento',
                              imagePath: 'assets/images/tomar_medicamento.jpg', // ← Ícono pequeño
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.addMedication);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElasticIn(
                            delay: const Duration(milliseconds: 100),
                            child: CardHome(
                              title: 'Agregar Actividad',
                              imagePath: 'assets/images/actividad.png', // ← Ícono pequeño
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.addActivity);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavbarBottom(),
    );
  }

  // Tarjeta grande: Próxima acción (solo ver)
  Widget _buildNextActionCard({
    required BuildContext context,
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Imagen
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
              // Degradado
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
              ),
              // Texto
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toca para ver detalles',
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              // Ripple
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(borderRadius: BorderRadius.circular(20), onTap: onTap),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}