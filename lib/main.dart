import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/select_child.dart';
import 'screens/dashboard_parent.dart';

void main() {
  runApp(const EduPulseApp());
}

class EduPulseApp extends StatelessWidget {
  const EduPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduPulse QR',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/teacher_dashboard': (context) => Scaffold(
              appBar: AppBar(title: const Text('Halaman Guru')),
              body: const Center(child: Text('Selamat datang, Guru!')),
            ),
        '/pilih_anak': (context) => const SelectChildScreen(),
        '/parent_dashboard': (context) => const ParentDashboardScreen(),
      },
    );
  }
}
