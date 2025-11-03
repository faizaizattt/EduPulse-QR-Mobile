import 'package:flutter/material.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Papan Pemuka Guru'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: const Center(
        child: Text('Selamat datang, Guru!', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
