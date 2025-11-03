import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  // Fungsi login (sementara menggunakan API Reqres)
  Future<Map<String, dynamic>> realLogin(String email, String password) async {
    final url = Uri.parse('https://reqres.in/api/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Contoh data pengguna (sementara)
        return {
          'status': true,
          'token': data['token'],
          'user': {
            'name': 'Guru Contoh',
            'role': email.contains("parent") ? 'parent' : 'teacher',
          },
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'status': false,
          'message': data['error'] ?? 'Ralat log masuk',
        };
      }
    } on SocketException {
      return {'status': false, 'message': 'Tiada sambungan internet'};
    } catch (e) {
      return {'status': false, 'message': 'Ralat sistem: $e'};
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

    final response = await realLogin(email, password);

    setState(() => _isLoading = false);

    if (response['status']) {
      // Simpan token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selamat datang, ${response['user']['name']}')),
      );

      // Arahkan mengikut peranan
      if (response['user']['role'] == 'parent') {
        Navigator.pushReplacementNamed(context, '/parent_dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/teacher_dashboard');
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
