import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  
  bool _isProcessing = false;

  Future<bool> verifyFace(CameraImage image, CameraDescription camera) async {
    if (_isProcessing) return false;
    _isProcessing = true;

    try {
      final List<int> bytes = [];
      for (final Plane plane in image.planes) {
        bytes.addAll(plane.bytes);
      }

      const format = InputImageFormat.bgra8888;
      final metadata = InputImageMetadata(
        size: ui.Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg, // Adjust based on camera orientation
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      final inputImage = InputImage.fromBytes(
        bytes: Uint8List.fromList(bytes),
        metadata: metadata,
      );

      // Process the image
      final faces = await _faceDetector.processImage(inputImage);

      // Verify face is clearly visible and centered
      if (faces.length == 1) {
        final face = faces[0];
        
        // Check if face is looking at camera
        if (face.headEulerAngleY != null && face.headEulerAngleY! < 10 &&
            face.headEulerAngleZ != null && face.headEulerAngleZ! < 10) {
          
          // Check if face is clear enough (based on confidence)
          if (face.leftEyeOpenProbability != null && face.leftEyeOpenProbability! > 0.9 &&
              face.rightEyeOpenProbability != null && face.rightEyeOpenProbability! > 0.9) {
            return true;
          }
        }
      }

      return false;
    } catch (e) {
      print('Error in face detection: $e');
      return false;
    } finally {
      _isProcessing = false;
    }
  }

  void dispose() {
    _faceDetector.close();
  }
}