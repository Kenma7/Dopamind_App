import 'package:flutter/material.dart';
import 'package:dopamind_app/pages/login.dart';

// IMPORT DENGAN PREFIX UNTUK MENGHINDARI CONFLICT
import 'pages/home.dart' as home_page;
import 'pages/meditasipage.dart' as meditation_page;
import 'pages/pulihpage.dart' as pulih_page;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dopamind Mental App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      home: LoginPage(), // HAPUS "const"
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  // HAPUS "const" DARI SEMUA CONSTRUCTOR
  final List<Widget> _pages = [
    home_page.HomePage(), // HAPUS "const"
    meditation_page.MeditationPage(), // HAPUS "const"
    pulih_page.PulihPage(), // HAPUS "const"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement_outlined),
            activeIcon: Icon(Icons.self_improvement),
            label: 'Meditasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.park_outlined),
            activeIcon: Icon(Icons.park),
            label: 'Pulih',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
