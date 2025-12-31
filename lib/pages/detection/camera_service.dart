import 'dart:io';

import 'package:camera/camera.dart';

class CameraService {
  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;
  Future<void> initialize() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );
    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
      // imageFormatGroup: ImageFormatGroup.yuv420,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    await _cameraController!.initialize();
  }

  void startImageStream(Function(CameraImage) onImageStream) {
    _cameraController?.startImageStream(onImageStream);
  }

  void dispose() {
    _cameraController?.dispose();
  }
}
