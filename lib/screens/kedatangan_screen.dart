import 'package:flutter/material.dart';
import 'qr_function_selector.dart';

class KedatanganScreen extends StatefulWidget {
  const KedatanganScreen({super.key});

  @override
  State<KedatanganScreen> createState() => _KedatanganScreenState();
}

class _KedatanganScreenState extends State<KedatanganScreen> {
  String? selectedClass;

  // Mock data
  final List<Map<String, dynamic>> students = [
    {
      'name': 'Ahmad bin Ali',
      'class': '5A',
      'status': 'Hadir',
      'time': '7:30 AM',
    },
    {
      'name': 'Siti Nurhaliza',
      'class': '5A',
      'status': 'Hadir',
      'time': '7:25 AM',
    },
    {
      'name': 'Muhammad Hakimi',
      'class': '5A',
      'status': 'Tidak Hadir',
      'time': '-',
    },
    {'name': 'Nurul Ain', 'class': '5A', 'status': 'Hadir', 'time': '7:35 AM'},
    {
      'name': 'Khairul Azman',
      'class': '5B',
      'status': 'Hadir',
      'time': '7:28 AM',
    },
    {
      'name': 'Farah Liyana',
      'class': '5B',
      'status': 'Tidak Hadir',
      'time': '-',
    },
    {
      'name': 'Amirul Hakim',
      'class': '5B',
      'status': 'Hadir',
      'time': '7:32 AM',
    },
    {
      'name': 'Zainab Karim',
      'class': '4A',
      'status': 'Hadir',
      'time': '7:29 AM',
    },
    {
      'name': 'Hassan Ibrahim',
      'class': '4A',
      'status': 'Hadir',
      'time': '7:27 AM',
    },
    {
      'name': 'Aisyah Hani',
      'class': '4A',
      'status': 'Tidak Hadir',
      'time': '-',
    },
    {
      'name': 'Danial Ariff',
      'class': '6A',
      'status': 'Hadir',
      'time': '7:31 AM',
    },
    {
      'name': 'Nadia Sofea',
      'class': '6A',
      'status': 'Hadir',
      'time': '7:26 AM',
    },
  ];

  List<String> getClassList() {
    return students.map((s) => s['class'] as String).toSet().toList()..sort();
  }

  List<Map<String, dynamic>> getStudentsByClass(String className) {
    return students.where((s) => s['class'] == className).toList();
  }

  @override
  Widget build(BuildContext context) {
    final classes = getClassList();

    return Scaffold(
      appBar: AppBar(title: const Text('Kehadiran Pelajar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: selectedClass == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pilih Kelas:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: classes.length,
                      itemBuilder: (context, index) {
                        final className = classes[index];
                        final classStudents = getStudentsByClass(className);
                        final total = classStudents.length;
                        final hadir = classStudents
                            .where((s) => s['status'] == 'Hadir')
                            .length;
                        final percent = ((hadir / total) * 100).round();

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text('Kelas $className'),
                            subtitle: Text(
                              '$hadir daripada $total pelajar hadir ($percent%)',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () =>
                                setState(() => selectedClass = className),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => setState(() => selectedClass = null),
                      ),
                      Text(
                        'Kelas $selectedClass',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: getStudentsByClass(selectedClass!).length,
                      itemBuilder: (context, index) {
                        final student = getStudentsByClass(
                          selectedClass!,
                        )[index];
                        final hadir = student['status'] == 'Hadir';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(student['name']),
                            subtitle: Text(
                              hadir
                                  ? 'Hadir pada ${student['time']}'
                                  : 'Tidak hadir',
                            ),
                            trailing: Icon(
                              hadir ? Icons.check_circle : Icons.cancel,
                              color: hadir ? Colors.green : Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.qr_code),
                      label: const Text(
                        'Imbas Kod QR Pelajar',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QrFunctionSelector(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
