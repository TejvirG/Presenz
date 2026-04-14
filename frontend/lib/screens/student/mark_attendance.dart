import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../services/face_recognition_service.dart';
import '../../services/gps_service.dart';
import '../../services/api_service.dart';
import '../../widgets/gradient_button.dart';

class MarkAttendancePage extends StatefulWidget {
  final String subject;
  const MarkAttendancePage({super.key, required this.subject});

  @override
  State<MarkAttendancePage> createState() => _MarkAttendancePageState();
}

class _MarkAttendancePageState extends State<MarkAttendancePage> {
  late FaceRecognitionService _faceService;
  bool _isInitialized = false;
  bool _isMarking = false;
  CameraDescription? _camera;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final cameras = await availableCameras();
    _camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first);
    _faceService = FaceRecognitionService();
    await _faceService.initialize(_camera!);
    setState(() => _isInitialized = true);
  }

  Future<void> _markAttendance() async {
    if (!_isInitialized) return;
    setState(() => _isMarking = true);

    final img = await _faceService.controller.takePicture();
    final bytes = await File(img.path).readAsBytes();
    final base64Face = base64Encode(bytes);

    final faceOk = await ApiService().verifyFace(base64Face);
    if (!faceOk) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Face not verified")));
      setState(() => _isMarking = false);
      return;
    }

    final pos = await GpsService().getCurrentLocation();
    if (pos == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Location not found")));
      setState(() => _isMarking = false);
      return;
    }

    final success = await ApiService().markAttendance(
      subject: widget.subject,
      latitude: pos.latitude,
      longitude: pos.longitude,
      faceVerified: true,
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success
            ? "Attendance marked successfully"
            : "Failed to mark attendance")));

    setState(() => _isMarking = false);
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
      appBar: AppBar(title: Text("Mark Attendance - ${widget.subject}")),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: _faceService.controller.value.aspectRatio,
            child: CameraPreview(_faceService.controller),
          ),
          const SizedBox(height: 20),
          GradientButton(
            text: _isMarking ? "Marking..." : "Mark Attendance",
            onPressed: _isMarking ? null : () => _markAttendance(),
          )
        ],
      ),
    );
  }
