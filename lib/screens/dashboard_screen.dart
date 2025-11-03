import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock child info
    final childInfo = {
      'name': 'Ahmad bin Ali',
      'class': '5A',
      'studentId': 'S2025001',
    };

    final todayStats = {
      'attendance': {'status': 'present', 'time': '7:30 AM'},
      'meal': {'status': 'claimed', 'time': '12:30 PM'},
      'behavior': {'good': 1, 'bad': 0},
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Ibu Bapa"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Selamat Datang 👋",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            const Text("Maklumat terkini tentang anak anda"),

            // 🧒 Child Info Card
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                title: Text(childInfo['name']!),
                subtitle: Text("Kelas ${childInfo['class']} • ${childInfo['studentId']}"),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text("AA",
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text("Ringkasan Hari Ini",
                style: Theme.of(context).textTheme.titleMedium),

            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildStatCard(
                  context,
                  icon: Icons.check_circle,
                  title: "Kehadiran",
                  value: todayStats['attendance']!['status'] == 'present'
                      ? 'Hadir'
                      : 'Tidak Hadir',
                  color: Colors.green,
                  subtitle: todayStats['attendance']!['time']!,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.restaurant,
                  title: "Makanan",
                  value: todayStats['meal']!['status'] == 'claimed'
                      ? 'Sudah Diambil'
                      : 'Belum',
                  color: Colors.blue,
                  subtitle: todayStats['meal']!['time']!,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.thumb_up,
                  title: "Tingkah Laku Baik",
                  value: todayStats['behavior']!['good'].toString(),
                  color: Colors.green,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.warning,
                  title: "Tingkah Laku Buruk",
                  value: todayStats['behavior']!['bad'].toString(),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String value,
      required Color color,
      String? subtitle}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value, style: Theme.of(context).textTheme.titleMedium),
            if (subtitle != null)
              Text(subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
