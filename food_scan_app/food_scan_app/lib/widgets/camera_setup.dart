import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../conf.dart';

class CameraSetup extends StatefulWidget {
  const CameraSetup({
    required Key key,
  }) : super(key: key);

  @override
  CameraSetupState createState() => CameraSetupState();
}

class CameraSetupState extends State<CameraSetup> {
  late CameraController _cameraController;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final CameraDescription selectedCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == cameraToUse,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
    );

    await _cameraController.initialize();

    if (!mounted) {
      return;
    }

    setState(() {
      isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isCameraInitialized
        ? Positioned(
            right: 25.0,
            bottom: 85.0,
            child: GestureDetector(
              child: const Icon(Icons.switch_video,
                  color: Colors.grey, size: 45.0),
              onTap: () {
                String txt;
                if (_cameraController.description.lensDirection ==
                    CameraLensDirection.front) {
                  _cameraController = CameraController(
                    cameras.firstWhere(
                      (camera) =>
                          camera.lensDirection == CameraLensDirection.back,
                    ),
                    ResolutionPreset.medium,
                  );
                  txt = "back";
                } else {
                  _cameraController = CameraController(
                    cameras.firstWhere(
                      (camera) =>
                          camera.lensDirection == CameraLensDirection.front,
                    ),
                    ResolutionPreset.medium,
                  );
                  txt = "front";
                }

                _cameraController.initialize().then((_) {
                  if (mounted) {
                    setState(() {});
                  }
                });

                infoFlash("Using the $txt camera");
              },
            ),
          )
        : Container();
  }
}
