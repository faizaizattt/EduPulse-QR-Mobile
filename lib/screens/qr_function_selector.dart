import 'package:flutter/material.dart';
import 'qr_scanner_screen.dart';

class QrFunctionSelector extends StatelessWidget {
  const QrFunctionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Fungsi QR'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sila pilih fungsi yang ingin digunakan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildFunctionCard(
              context,
              title: 'Kehadiran',
              description: 'Imbas kod QR untuk rekod kehadiran',
              icon: Icons.check_circle_outline,
              color: Colors.green,
              function: 'kehadiran',
            ),
            const SizedBox(height: 16),
            _buildFunctionCard(
              context,
              title: 'RMT',
              description: 'Imbas kod QR untuk rrekod kehadiran RMT',
              icon: Icons.assignment_outlined,
              color: Colors.blue,
              function: 'rmt',
            ),
            const SizedBox(height: 16),
            _buildFunctionCard(
              context,
              title: 'Sahsiah',
              description: 'Imbas kod QR untuk penilaian sahsiah',
              icon: Icons.star_outline,
              color: Colors.purple,
              function: 'sahsiah',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String function,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QrScannerScreen(function: function),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha((0.2 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
