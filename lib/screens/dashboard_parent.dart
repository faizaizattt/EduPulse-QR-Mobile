import 'package:flutter/material.dart';
import 'select_child.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get child argument safely
    final Child? child = ModalRoute.of(context)?.settings.arguments as Child?;
    if (child == null) {
      return const Scaffold(
        body: Center(child: Text('Tiada maklumat anak dijumpai')),
      );
    }

    // Today's stats
    final Map<String, dynamic> todayStats = {
      'attendance': {'status': 'Hadir', 'time': '7:30 AM'},
      'meal': {'status': 'Sudah Diambil', 'time': '12:30 PM'},
      'behaviorGood': 1,
      'behaviorBad': 0,
    };

    // Weekly stats
    final Map<String, dynamic> weeklyStats = {
      'attendance': 95,
      'mealsCount': '5/5',
      'behaviorScore': 'Cemerlang',
    };

    // Recent activities
    final List<Map<String, dynamic>> recentActivities = [
      {
        'title': 'Hadir ke Sekolah',
        'description': 'Pukul 7:30 AM',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'title': 'Makanan Tengah Hari',
        'description': 'Telah mengambil makanan',
        'icon': Icons.restaurant,
        'color': Colors.blue,
      },
      {
        'title': 'Juara Pidato Peringkat Negeri',
        'description': 'Pencapaian Cemerlang',
        'icon': Icons.emoji_events,
        'color': Colors.purple,
      },
    ];

    // Function to get initials from name
    String getInitials(String name) {
      final parts = name.split(' ');
      return parts[0][0] + (parts.length > 1 ? parts[1][0] : '');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Papan Pemuka Ibu Bapa'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang, Ibu/Bapa!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Child Info Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.purple,
                      child: Text(
                        getInitials(child.name),
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(child.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          'Kelas: ${child.studentClass} • ${child.studentId}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            // Today's Summary Grid
            const Text(
              'Ringkasan Hari Ini',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.5,
              ),
              children: [
                _buildStatCard(
                  'Kehadiran',
                  todayStats['attendance']['status'] as String,
                  todayStats['attendance']['time'] as String,
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatCard(
                  'Makanan',
                  todayStats['meal']['status'] as String,
                  todayStats['meal']['time'] as String,
                  Icons.restaurant,
                  Colors.blue,
                ),
                _buildStatCard(
                  'Tingkah Laku Baik',
                  (todayStats['behaviorGood'] as int).toString(),
                  '',
                  Icons.emoji_events,
                  Colors.green,
                ),
                _buildStatCard(
                  'Tingkah Laku Buruk',
                  (todayStats['behaviorBad'] as int).toString(),
                  '',
                  Icons.warning,
                  Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 16),
            // Weekly Stats
            const Text(
              'Prestasi Mingguan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Purata Kehadiran'),
                        Text('${weeklyStats['attendance']}%'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (weeklyStats['attendance'] as int) / 100,
                      color: Colors.green,
                      backgroundColor: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Makanan Diambil'),
                            Text(
                              weeklyStats['mealsCount'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Penilaian Sahsiah'),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.green[100], borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                weeklyStats['behaviorScore'] as String,
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            // Recent Activities
            const Text(
              'Aktiviti Terkini',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: recentActivities.map((activity) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (activity['color'] as Color).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(activity['icon'] as IconData, color: activity['color'] as Color),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(activity['title'] as String,
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(activity['description'] as String,
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build stat cards
  Widget _buildStatCard(String label, String value, String time, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (time.isNotEmpty) Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
