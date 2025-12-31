import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class CameraInfo {
  CameraInfo({
    required this.cameraDescription,
    required this.deviceOrientation,
  });
  final CameraDescription cameraDescription;
  final DeviceOrientation deviceOrientation;
}

class InputImageConverter {
  static InputImage? fromCameraImage(CameraImage image, CameraInfo cameraInfo) {
    try {
      final rotation = _getImageRotation(cameraInfo);
      if (rotation == null) {
        debugPrint('InputImageConverter._getImageRotation failed');
        return null;
      }
      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null ||
          (Platform.isIOS && format != InputImageFormat.bgra8888) ||
          (Platform.isAndroid && format != InputImageFormat.nv21)) {
        debugPrint('InputImageConverter._getImageFormat failed');
        return null;
      }
      if (image.planes.isEmpty) {
        debugPrint('InputImageConverter._getImagePlanes failed');
        return null;
      }
      final plane = image.planes.first;
      final bytes = plane.bytes;
      final imageWidth = image.width;
      final imageHeight = image.height;
      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(imageWidth.toDouble(), imageHeight.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: plane.bytesPerRow,
        ),
      );
    } catch (e) {
      debugPrint('InputImageConverter.convertCameraImage failed: $e');
      return null;
    }
  }

  /// 根據裝置與相機資訊判斷正確的影像旋轉角度
  static InputImageRotation? _getImageRotation(CameraInfo cameraInfo) {
    const orientations = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };

    final sensorOrientation = cameraInfo.cameraDescription.sensorOrientation;
    final deviceOrientation = orientations[cameraInfo.deviceOrientation];
    if (deviceOrientation == null) return null;

    if (Platform.isIOS) {
      return InputImageRotationValue.fromRawValue(sensorOrientation);
    }

    if (Platform.isAndroid) {
      var rotationCompensation = deviceOrientation;

      if (cameraInfo.cameraDescription.lensDirection ==
          CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }

      return InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    return null;
  }
}
