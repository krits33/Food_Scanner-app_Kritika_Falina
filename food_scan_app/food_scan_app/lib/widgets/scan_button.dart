import 'package:flutter/material.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20.0,
      bottom: 50.0,
      child: FloatingActionButton(
        backgroundColor: Colors.yellow[700],
        child: const Icon(Icons.qr_code_scanner),
        onPressed: () => Navigator.of(context).pushNamed("/scan"),
      ),
    );
  }
}
