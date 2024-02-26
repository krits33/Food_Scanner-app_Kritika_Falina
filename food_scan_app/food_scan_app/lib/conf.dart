import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';

// Camera configuration
CameraLensDirection cameraToUse = CameraLensDirection.back;
List<CameraDescription> cameras = []; // Add cameras variable

// Logger configuration
Logger log = Logger(
  printer: PrettyPrinter(),
);

void infoFlash(String message, {BuildContext? context}) {
  log.i(message); // Log the info using logger

  // Display the info message using a SnackBar
  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

void errorScreen(String message, {BuildContext? context}) {
  log.e(message); // Log the error using logger

  // Display the error message using a SnackBar
  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

Completer<Null> _readyCompleter = Completer<Null>();

Future<Null> get onConfReady => _readyCompleter.future;

initConf() async {
  Directory documentsDirectory;

  documentsDirectory = await getApplicationDocumentsDirectory();
  File file = File('${documentsDirectory.path}/beep.mp3');
  if (!file.existsSync()) {
    List<int> bytes;
    try {
      ByteData data = await rootBundle.load("assets/beep.mp3");
      bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    } catch (e) {
      throw ("Unable to copy asset");
    }
    try {
      await file.writeAsBytes(bytes);
    } catch (e) {
      throw ("Unable to write data from asset");
    }
  }
  _readyCompleter.complete();
}
