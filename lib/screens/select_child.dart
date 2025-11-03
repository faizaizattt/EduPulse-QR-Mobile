import 'package:flutter/material.dart';
import 'dashboard_parent.dart';

class Child {
  final String name;
  final String studentClass;
  final String studentId;
  final int attendanceRate;

  Child({
    required this.name,
    required this.studentClass,
    required this.studentId,
    required this.attendanceRate,
  });
}

// Mock child database
final List<Child> children = [
  Child(name: 'Ahmad Hakim', studentClass: '3 Amanah', studentId: 'S2025001', attendanceRate: 95),
  Child(name: 'Nur Aisyah', studentClass: '5 Bestari', studentId: 'S2025002', attendanceRate: 88),
];

class SelectChildScreen extends StatelessWidget {
  const SelectChildScreen({super.key});

  String getInitials(String name) {
    final parts = name.split(' ');
    return parts[0][0] + (parts.length > 1 ? parts[1][0] : '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Anak'), backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sila pilih anak anda:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: children.length,
                itemBuilder: (context, index) {
                  final child = children[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/parent_dashboard', arguments: child);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.purple,
                              child: Text(getInitials(child.name), style: const TextStyle(color: Colors.white, fontSize: 18)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(child.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('Kelas: ${child.studentClass} • ${child.studentId}', style: const TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: child.attendanceRate / 100,
                                    backgroundColor: Colors.grey[300],
                                    color: Colors.green,
                                  ),
                                  const SizedBox(height: 4),
                                  Text('${child.attendanceRate}% kehadiran', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.purple),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
