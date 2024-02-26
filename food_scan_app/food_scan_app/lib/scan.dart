import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
      ),
      body: const ScanScreen(),
    );
  }
}

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Future<void> scanBarcode(BuildContext context) async {
    try {
      var result = await BarcodeScanner.scan();
      Navigator.pushNamed(context, '/product', arguments: result.rawContent);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        // Handle camera access denied
        print("Camera Access Denied");
      } else {
        // Handle other errors
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.qr_code_scanner,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            'Scan a product',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => scanBarcode(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[700], // set button color
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Scan barcode'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/uploadImage'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[700],
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Upload Image'),
          ),
        ],
      ),
    );
  }
}
