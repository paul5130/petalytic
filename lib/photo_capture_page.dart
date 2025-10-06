import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:petalytic/photo_result_page.dart';

class PhotoCapturePage extends StatefulWidget {
  const PhotoCapturePage({super.key});

  @override
  State<PhotoCapturePage> createState() => _PhotoCapturePageState();
}

class _PhotoCapturePageState extends State<PhotoCapturePage> {
  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _initCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Capture a photo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A746B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _initializeControllerFuture != null
          ? FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.done &&
                        _cameraController.value.isInitialized)
                    ? Stack(
                        children: [
                          Positioned.fill(
                            child: CameraPreview(_cameraController),
                          ),
                          Positioned(
                            bottom: 40,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: GestureDetector(
                                onTap: _tackPicture,
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator());
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );
    _cameraController = CameraController(backCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController.initialize();
    setState(() {});
  }

  Future<void> _tackPicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _cameraController.takePicture();
      if (!mounted) {
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoResultPage(imagePath: image.path),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
