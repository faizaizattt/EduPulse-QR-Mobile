import 'package:flutter/material.dart';
import 'qr_scanner_screen.dart';

class AttendanceSuccessScreen extends StatelessWidget {
  final String scannedCode;
  final String function;

  const AttendanceSuccessScreen({
    super.key,
    required this.scannedCode,
    this.function = 'kehadiran',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kehadiran Berjaya'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 100, color: Colors.green),
              const SizedBox(height: 24),
              Text(
                'Kod QR telah diimbas dengan jayanya!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Kod Imbasan: $scannedCode',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Start scanning next student with the same function
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QrScannerScreen(function: function),
                        ),
                      );
                    },
                    child: const Text('Imbas Pelajar Seterusnya'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Back to app home (root)
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(Navigator.defaultRouteName),
                      );
                    },
                    child: const Text('Kembali ke Halaman Utama'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
