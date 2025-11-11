import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            const CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage('assets/images.jpeg'),
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 16),

            // Name
            const Text(
              'Cikgu Ahmad',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Guru Disiplin | SK Sri Siakap',
              style: TextStyle(color: Colors.grey[600]),
            ),

            const SizedBox(height: 20),
            const Divider(),

            // Info Cards
            _buildInfoCard(Icons.email, 'Emel', 'teacher@edu.com'),
            _buildInfoCard(Icons.phone, 'No. Telefon', '012-3456789'),
            _buildInfoCard(Icons.badge, 'No. Staff', 'TCH0123'),
            _buildInfoCard(Icons.location_on, 'Lokasi', 'Kuala Lumpur, Malaysia'),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add logout or edit profile action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Fungsi log keluar belum tersedia.")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Log Keluar",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.withOpacity(0.1),
          child: Icon(icon, color: Colors.indigo),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
