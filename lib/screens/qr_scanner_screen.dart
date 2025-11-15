// lib/screens/qr_scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'attendance_success_screen.dart';

class QrScannerScreen extends StatefulWidget {
  final String function; // kehadiran, rmt, or sahsiah

  const QrScannerScreen({super.key, required this.function});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _controller = MobileScannerController();
  double _currentZoom = 1.0;
  bool _isNavigating = false;

  String? lastScanned;
  DateTime? lastScanTime;
  final Duration duplicateTimeout = const Duration(seconds: 3);

  final List<double> _zoomLevels = [1.0, 2.5];

  late final AnimationController _animationController;
  late final Animation<double> _glowAnimation;
  late final Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(_animationController);

    _scanLineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _setZoom(double zoom) async {
    try {
      // Clamp zoom to valid range (mobile_scanner supports 0.0 to 1.0)
      final clamped = zoom.clamp(0.0, 1.0);
      // Zoom adjustment is not supported by MobileScannerController in this project,
      // but store the chosen value for the UI state.
      setState(() {
        _currentZoom = clamped;
      });
    } catch (e) {
      debugPrint('Error setting zoom: $e');
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isNavigating || capture.barcodes.isEmpty) return;

    final barcode = capture.barcodes.first;
    final raw = barcode.rawValue;
    if (raw == null || raw.isEmpty) return;

    final now = DateTime.now();
    if (lastScanned != null &&
        lastScanned == raw &&
        lastScanTime != null &&
        now.difference(lastScanTime!) < duplicateTimeout) {
      return;
    }

    lastScanned = raw;
    lastScanTime = now;
    _isNavigating = true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceSuccessScreen(scannedCode: raw),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Imbas Kod QR'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ScannerOverlayPainter(
                      glowOpacity: _glowAnimation.value,
                      scanLineProgress: _scanLineAnimation.value,
                    ),
                  );
                },
              ),
            ),
          ),

          // Zoom buttons
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _zoomLevels.map((zoom) {
                final isSelected = (_currentZoom - zoom).abs() < 0.001;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Colors.blueAccent
                          : Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                    onPressed: () => _setZoom(zoom),
                    child: Text(
                      '${zoom.toStringAsFixed(1)}x',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double glowOpacity;
  final double scanLineProgress;

  const _ScannerOverlayPainter({
    required this.glowOpacity,
    required this.scanLineProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    const frameSize = 300.0;
    final left = (width - frameSize) / 2;
    final top = (height - frameSize) / 2;
    final right = left + frameSize;
    final bottom = top + frameSize;
    const cornerLength = 40.0;
    const cornerWidth = 5.0;

    // Dark overlay using alpha instead of withOpacity
    final overlayPaint = Paint()
      ..color = Colors.black.withAlpha((0.6 * 255).round());
    canvas.saveLayer(Rect.fromLTWH(0, 0, width, height), Paint());
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), overlayPaint);

    // Clear center rectangle
    final clearPaint = Paint()
      ..blendMode = BlendMode.clear
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left, top, right, bottom),
        const Radius.circular(0),
      ),
      clearPaint,
    );

    // Glowing corners
    final glowPaint = Paint()
      ..color = Colors.greenAccent.withAlpha((glowOpacity * 255).round())
      ..strokeWidth = cornerWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Top-left
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      glowPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + cornerLength),
      glowPaint,
    );

    // Top-right
    canvas.drawLine(
      Offset(right - cornerLength, top),
      Offset(right, top),
      glowPaint,
    );
    canvas.drawLine(
      Offset(right, top),
      Offset(right, top + cornerLength),
      glowPaint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(left, bottom - cornerLength),
      Offset(left, bottom),
      glowPaint,
    );
    canvas.drawLine(
      Offset(left, bottom),
      Offset(left + cornerLength, bottom),
      glowPaint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(right - cornerLength, bottom),
      Offset(right, bottom),
      glowPaint,
    );
    canvas.drawLine(
      Offset(right, bottom - cornerLength),
      Offset(right, bottom),
      glowPaint,
    );

    // Scanning line
    final linePaint = Paint()
      ..color = Colors.greenAccent.withAlpha((0.8 * 255).round())
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    final lineY = top + frameSize * scanLineProgress;
    canvas.drawLine(
      Offset(left + 5, lineY),
      Offset(right - 5, lineY),
      linePaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) =>
      oldDelegate.glowOpacity != glowOpacity ||
      oldDelegate.scanLineProgress != scanLineProgress;
}
