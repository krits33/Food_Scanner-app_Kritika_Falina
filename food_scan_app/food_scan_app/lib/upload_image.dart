import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'search_result.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  late Interpreter? _interpreter;
  late File _image;
  final _picker = ImagePicker();
  late List<String> _labels;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadModelAndLabels();
  }

  Future<void> _loadModelAndLabels() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model_unquant.tflite');
      final labelsFile = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsFile.split('\n');
    } catch (e) {
      // Handle initialization error
      print('Error initializing model: $e');
    }
  }

  Future<void> _getImageAndProcess() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await _classifyImage(_image);
      } else {
        setState(() {
          _isProcessing = false;
        });
      }
    } catch (e) {
      // Handle image picking error
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error picking image: $e'),
            behavior: SnackBarBehavior.floating),
      );
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _classifyImage(File image) async {
    if (_interpreter == null) return;

    try {
      var input = image.readAsBytesSync();
      var output = List.filled(1, List.filled(5, 0.0));
      _interpreter!.run(input, output);

      // Assuming output is a list of labels with probabilities, pick the label with highest probability
      var predictedLabelIndex =
          output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));
      var predictedLabel = _labels[predictedLabelIndex];

      setState(() {
        _isProcessing = false;
      });

      // Send the predicted label to SearchResultsPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(productName: predictedLabel),
        ),
      );
    } catch (e) {
      // Handle classification error
      print('Error classifying image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error classifying image: $e'),
            behavior: SnackBarBehavior.floating),
      );
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image_search,
              size: 200,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose an Image',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isProcessing ? null : _getImageAndProcess,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_interpreter != null) {
      _interpreter!.close();
    }
    super.dispose();
  }
}
