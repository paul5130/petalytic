import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:petalytic/pages/detection/camera_service.dart';
import 'package:petalytic/pages/detection/input_image_converter.dart';
import 'package:petalytic/pages/detection/object_detector_service.dart';
import 'package:petalytic/pages/detection/result_painter.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _PhotoCapturePageState();
}

class _PhotoCapturePageState extends State<DetectionPage> {
  final CameraService _cameraService = CameraService();
  final ObjectDetectorService _objectService = ObjectDetectorService();
  bool _isBusy = false;
  final List<DetectedObject> _results = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _cameraService.initialize();
    await _objectService.initialize('assets/ml/object_labeler.tflite');
    _cameraService.startImageStream(_processImage);
    setState(() {});
  }

  Future<void> _processImage(CameraImage cameraImage) async {
    debugPrint('📸 拍攝圖片');
    if (_isBusy) return;
    _isBusy = true;

    try {
      final cameraInfo = CameraInfo(
        cameraDescription: _cameraService.cameraController!.description,
        deviceOrientation:
            _cameraService.cameraController!.value.deviceOrientation,
      );

      final inputImage = InputImageConverter.fromCameraImage(
        cameraImage,
        cameraInfo,
      );
      if (inputImage == null) {
        _isBusy = false;
        return;
      }

      final results = await _objectService.processImage(inputImage);
      debugPrint('✅ 偵測結果數量: ${results.length}');
      _isBusy = false;
      setState(
        () => _results
          ..clear()
          ..addAll(results),
      );
      _isBusy = false;
    } catch (e) {
      debugPrint('❌ 偵測過程發生錯誤: $e');
      _isBusy = false;
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _objectService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraService.cameraController == null ||
        !_cameraService.cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    final previewSize = _cameraService.cameraController!.value.previewSize!;
    // final isLandscape = previewSize.width > previewSize.height;
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text(
      //     'Capture a photo',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: const Color(0xFF1A746B),
      //   iconTheme: const IconThemeData(color: Colors.white),
      // ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: previewSize.height,
                height: previewSize.width,
                child: CameraPreview(_cameraService.cameraController!),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: ResultPainter(
                _cameraService.cameraController!.value.previewSize!,
                _results,
                isFrontCamera:
                    _cameraService
                        .cameraController!
                        .description
                        .lensDirection ==
                    CameraLensDirection.front,
                debug: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> _initCamera() async {
  //   final cameras = await availableCameras();
  //   final backCamera = cameras.firstWhere(
  //     (camera) => camera.lensDirection == CameraLensDirection.back,
  //   );
  //   _cameraController = CameraController(backCamera, ResolutionPreset.medium);
  //   _initializeControllerFuture = _cameraController.initialize();
  //   setState(() {});
  // }

  // Future<void> _tackPicture() async {
  //   try {
  //     await _initializeControllerFuture;
  //     final image = await _cameraController.takePicture();
  //     if (!mounted) {
  //       return;
  //     }
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PhotoResultPage(imagePath: image.path),
  //       ),
  //     );
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }
}
