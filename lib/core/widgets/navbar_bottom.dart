import 'package:flutter/material.dart';
import 'package:heraguard_frontend/core/constants/role_config.dart';
import 'package:heraguard_frontend/core/extensions/auth_context.dart';
import 'package:heraguard_frontend/core/providers/app_provider.dart';
import 'package:provider/provider.dart';

class NavbarBottom extends StatefulWidget {
  const NavbarBottom({super.key});

  @override
  State<NavbarBottom> createState() => _NavbarBottomState();
}

class _NavbarBottomState extends State<NavbarBottom> {
  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final navRoutes = RoleConfig.getNavBarRoutes(context.userRole.role);

    return BottomNavigationBar(
      currentIndex: appProvider.currentNavIndex,
      items: navRoutes
          .map(
            (route) =>
                BottomNavigationBarItem(icon: route.icon, label: route.label),
          )
          .toList(),
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          context.read<AppProvider>().setNavIndex(index);
        });
        Navigator.pushNamed(context, navRoutes[index].path);
      },
    );
  }
}
