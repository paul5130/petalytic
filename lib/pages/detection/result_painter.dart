import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ResultPainter extends CustomPainter {
  final bool isFrontCamera;
  final bool debug;
  ResultPainter(
    this.absoluteImageSize,
    this.objects, {
    this.isFrontCamera = false,
    this.debug = false,
  });

  final Size absoluteImageSize;
  final List<DetectedObject> objects;

  @override
  void paint(Canvas canvas, Size size) {
    if (debug) {
      final dbgPaint = Paint()
        ..color = Colors.greenAccent.withValues(alpha: .7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      // Draw canvas border to confirm painter is visible and sized
      canvas.drawRect(Offset.zero & size, dbgPaint);
      debugPrint(
        '🖼️ ResultPainter canvas=${size.width}x${size.height} '
        'image=${absoluteImageSize.width}x${absoluteImageSize.height} '
        'objs=${objects.length} isFront=$isFrontCamera',
      );
    }

    if (isFrontCamera) {
      canvas.translate(size.width, 0);
      canvas.scale(-1, 1);
    }

    if (debug) {
      final dot = Paint()..color = Colors.amberAccent.withValues(alpha: .8);
      canvas.drawCircle(const Offset(12, 12), 6, dot);
    }

    // Fix orientation for portrait mode (MLKit image buffer is landscape)
    final double scaleX = size.width / absoluteImageSize.height;
    final double scaleY = size.height / absoluteImageSize.width;

    if (objects.isEmpty && debug) {
      final tp = TextPainter(
        text: const TextSpan(
          text: 'NO DETECTIONS',
          style: TextStyle(color: Colors.redAccent, fontSize: 14),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2),
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.pinkAccent;

    for (DetectedObject detectedObject in objects) {
      canvas.drawRect(
        Rect.fromLTRB(
          (detectedObject.boundingBox.left * scaleX).clamp(0.0, size.width),
          (detectedObject.boundingBox.top * scaleY).clamp(0.0, size.height),
          (detectedObject.boundingBox.right * scaleX).clamp(0.0, size.width),
          (detectedObject.boundingBox.bottom * scaleY).clamp(0.0, size.height),
        ),
        paint,
      );

      var list = detectedObject.labels;
      for (Label label in list) {
        debugPrint("${label.text}   ${label.confidence.toStringAsFixed(2)}");
        TextSpan span = TextSpan(
          text: label.text,
          style: const TextStyle(fontSize: 25, color: Colors.blue),
        );
        TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        final dx = (detectedObject.boundingBox.left * scaleX + 4).clamp(
          0.0,
          size.width - 20.0,
        );
        final dy = (detectedObject.boundingBox.top * scaleY + 4).clamp(
          0.0,
          size.height - 20.0,
        );
        tp.paint(canvas, Offset(dx, dy));
        break;
      }
    }
  }

  @override
  bool shouldRepaint(ResultPainter oldDelegate) {
    if (debug || oldDelegate.debug) return true;
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.objects.length != objects.length ||
        oldDelegate.isFrontCamera != isFrontCamera;
  }
}
