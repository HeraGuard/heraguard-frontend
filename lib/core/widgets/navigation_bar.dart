import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  final int userRoleId; // 1=adulto_mayor, 2=cuidador, 3=doctor

  const NavigationBar({Key? key, required this.userRoleId}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 0;

  late List<BottomNavigationBarItem> _navItems;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _setupNavigation();
  }

  void _setupNavigation() {
    switch (widget.userRoleId) {
      case 3: // Doctor
        _navItems = const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificaciones'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pacientes'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ];
        _pages = const [
          Center(child: Text('Home Doctor')),
          Center(child: Text('Chats Doctor')),
          Center(child: Text('Notificaciones Doctor')),
          Center(child: Text('Pacientes Doctor')),
          Center(child: Text('Ajustes Doctor')),
        ];
        break;
      case 1: // Adulto Mayor
        _navItems = const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificaciones'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Alerta'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ];
        _pages = const [
          Center(child: Text('Home Adulto Mayor')),
          Center(child: Text('Chats Adulto Mayor')),
          Center(child: Text('Notificaciones Adulto Mayor')),
          Center(child: Text('Alerta Adulto Mayor')),
          Center(child: Text('Ajustes Adulto Mayor')),
        ];
        break;
      case 2: // Cuidador
        _navItems = const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificaciones'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pacientes'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ];
        _pages = const [
          Center(child: Text('Home Cuidador')),
          Center(child: Text('Chats Cuidador')),
          Center(child: Text('Notificaciones Cuidador')),
          Center(child: Text('Pacientes Cuidador')),
          Center(child: Text('Ajustes Cuidador')),
        ];
        break;
      default:
        _navItems = const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        ];
        _pages = const [
          Center(child: Text('Home')),
        ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}

