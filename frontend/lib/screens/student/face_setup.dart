import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/face_recognition_service.dart';
import '../../widgets/gradient_button.dart';

class FaceSetupPage extends StatefulWidget {
  const FaceSetupPage({super.key});

  @override
  State<FaceSetupPage> createState() => _FaceSetupPageState();
}

class _FaceSetupPageState extends State<FaceSetupPage> {
  late FaceRecognitionService _faceService;
  bool _isInitialized = false;
  bool _isRegistering = false;
  CameraDescription? _camera;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first);
    _faceService = FaceRecognitionService();
    await _faceService.initialize(_camera!);
    setState(() => _isInitialized = true);
  }

  Future<void> _registerFace() async {
    if (!_isInitialized) return;
    setState(() => _isRegistering = true);

    final hasFace = await _faceService.detectFace();
    if (!hasFace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No face detected")));
      setState(() => _isRegistering = false);
      return;
    }

    final img = await _faceService.controller.takePicture();
    final bytes = await File(img.path).readAsBytes();
    final base64Face = base64Encode(bytes);

    final success = await ApiService().registerFace(base64Face);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success ? "Face registered!" : "Failed to register")));

    setState(() => _isRegistering = false);
  }

  @override
  void dispose() {
    _faceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Face Setup")),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: _faceService.controller.value.aspectRatio,
            child: CameraPreview(_faceService.controller),
          ),
          const SizedBox(height: 20),
          GradientButton(
            text: _isRegistering ? "Registering..." : "Register Face",
            onPressed: _isRegistering ? null : _registerFace,
          )
        ],
      ),
    );
  }
}
