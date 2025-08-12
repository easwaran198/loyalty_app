import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera preview with QR scanner
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  debugPrint('Scanned code: $code');
                  Navigator.pushNamed(
                    context,
                    '/scanneddetails',
                    arguments: code,
                  );
                  // Handle the scanned code here
                  break; // Optional: stop after first valid scan
                }
              }
            },
          ),

          // Overlay UI
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: Stack(
                children: [
                  // Back button
                  Positioned(
                    top: 40,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Instructional text
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: const [
                        Text(
                          "Scan QR Code",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                          child: Text(
                            "Scan the QR code to instantly capture your invoice and coupon details.",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scan area with yellow brackets
                  Center(
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: CustomPaint(
                        painter: ScanAreaPainter(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🎨 Custom painter for yellow corner brackets
class ScanAreaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const bracketLength = 30.0;

    // Top-left
    canvas.drawLine(Offset(0, 0), Offset(bracketLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, bracketLength), paint);

    // Top-right
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - bracketLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, bracketLength), paint);

    // Bottom-left
    canvas.drawLine(Offset(0, size.height), Offset(bracketLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - bracketLength), paint);

    // Bottom-right
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - bracketLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - bracketLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
