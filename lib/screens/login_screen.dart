// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Mock users
  final Map<String, Map<String, String>> mockUsers = {
    'teacher@edu.com': {
      'password': '123456',
      'name': 'Guru Contoh',
      'role': 'teacher',
    },
    'parent@edu.com': {
      'password': '123456',
      'name': 'Ibu Bapa Contoh',
      'role': 'parent',
    },
  };

  // Fungsi login mock
  Future<Map<String, dynamic>> mockLogin(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay

    if (mockUsers.containsKey(email)) {
      if (mockUsers[email]!['password'] == password) {
        return {
          'status': true,
          'token': 'mock_token_123456', // fake token
          'user': {
            'name': mockUsers[email]!['name'],
            'role': mockUsers[email]!['role'],
          },
        };
      } else {
        return {'status': false, 'message': 'Kata laluan salah'};
      }
    } else {
      return {'status': false, 'message': 'Emel tidak ditemui'};
    }
  }

  Future<void> _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sila isi semua ruangan')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final response = await mockLogin(email, password);

    setState(() => _isLoading = false);

    if (response['status']) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);
      await prefs.setString('role', response['user']['role']);

      String role = response['user']['role'];
      String name = response['user']['name'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selamat datang, $name')),
      );

      // ✅ Navigate berdasarkan peranan
      if (role == 'teacher') {
        Navigator.pushReplacementNamed(context, '/teacher_dashboard');
      } else if (role == 'parent') {
        Navigator.pushReplacementNamed(context, '/select_child_screen');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Log masuk gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.qr_code_2, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                "EduPulse QR",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Log Masuk Guru / Ibu Bapa",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              // Emel
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Emel',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),

              // Kata laluan
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Kata Laluan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),

              // Butang Log Masuk
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Log Masuk',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
