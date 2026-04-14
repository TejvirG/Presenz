import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceRecognitionService {
  late CameraController _controller;
  late FaceDetector _faceDetector;

  Future<void> initialize(CameraDescription camera) async {
    _controller = CameraController(camera, ResolutionPreset.medium);
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
      ),
    );
    await _controller.initialize();
  }

  CameraController get controller => _controller;

  Future<bool> detectFace() async {
    try {
      final image = await _controller.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final faces = await _faceDetector.processImage(inputImage);
      return faces.isNotEmpty;
    } catch (e) {
      print("Face detection error: $e");
      return false;
    }
  }

  void dispose() {
    _controller.dispose();
    _faceDetector.close();
  }
}