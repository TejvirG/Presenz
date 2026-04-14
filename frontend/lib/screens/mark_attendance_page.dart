import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
// removed google_maps_flutter as location will be shown as text only
// no map math needed
import '../models/class_model.dart';
import '../services/face_detection_service.dart';
import '../services/attendance_service.dart';
import '../services/auth_service.dart';

class MarkAttendancePage extends StatefulWidget {
  final ClassModel classData;
  final CameraDescription camera;
  final Position position;

  const MarkAttendancePage({
    super.key,
    required this.classData,
    required this.camera,
    required this.position,
  });

  @override
  State<MarkAttendancePage> createState() => _MarkAttendancePageState();
}

class _MarkAttendancePageState extends State<MarkAttendancePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late FaceDetectionService _faceDetectionService;
  bool _processing = false;
  bool _faceVerified = false;
  bool _faceOpened = false;
  bool _cameraDisposed = false;
  String? _locationText; // will hold the textual location shown after verification

  @override
  void initState() {
    super.initState();
    _faceDetectionService = FaceDetectionService();
    // Camera is initialized on-demand when the user opens the verifier.
  }

  // Initialize camera when user taps Open Camera
  Future<void> _openFaceVerify() async {
    try {
      if (_cameraDisposed) {
        _cameraDisposed = false;
      }

      _controller = CameraController(
        widget.camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      _initializeControllerFuture = _controller.initialize().catchError((error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Camera init failed: $error')),
          );
        }
        return Future.error(error);
      });

      setState(() {
        _faceOpened = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open camera: $e')),
        );
      }
    }
  }
  Future<void> _verifyFace() async {
    if (_processing) return;
    setState(() => _processing = true);

    try {
      // Simulate face verification for demo
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _faceVerified = true;
        _processing = false;
        // show textual current location
        _locationText = '${widget.position.latitude.toStringAsFixed(6)}, ${widget.position.longitude.toStringAsFixed(6)} (accuracy ${widget.position.accuracy} m)';
      });
    } catch (e) {
      setState(() => _processing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Face verification failed: $e')),
        );
      }
    }
  }

  Future<void> _markAttendance() async {
    if (!_faceVerified) return;

    try {
      final token = await AuthService().getToken();
      final attendanceService = AttendanceService(token: token);

      await attendanceService.markAttendance(
        classId: widget.classData.id,
        position: widget.position,
        faceVerified: true,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance marked successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    // Dispose camera controller if not already disposed
    try {
      if (!_cameraDisposed) {
        _controller.dispose();
        _cameraDisposed = true;
      }
    } catch (_) {}
    _faceDetectionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Give Attendance'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(_faceVerified ? Icons.check : Icons.camera_alt),
                      label: Text(_faceVerified ? 'Face Verified' : 'Open Camera'),
                      onPressed: () async {
                        if (_faceOpened) {
                          // close camera
                          try {
                            if (!_cameraDisposed) {
                              await _controller.dispose();
                              _cameraDisposed = true;
                            }
                          } catch (_) {}
                          setState(() => _faceOpened = false);
                        } else {
                          await _openFaceVerify();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Preview area: either camera preview or map
            Expanded(
              child: Container(
                color: Colors.black12,
                child: Center(
                  child: _faceOpened
                      ? FutureBuilder<void>(
                          future: _initializeControllerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Camera error: ${snapshot.error}');
                            }
                            if (snapshot.connectionState == ConnectionState.done) {
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  CameraPreview(_controller),
                                  Center(
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue, width: 2),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return const CircularProgressIndicator();
                          },
                        )
                      : const Text('Open Camera to begin verification'),
                ),
              ),
            ),

            // Status, location text and submit
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _StatusItem(label: 'Face Verification', verified: _faceVerified),
                  const SizedBox(height: 12),
                  if (_locationText != null) ...[
                    Text('Current location: $_locationText'),
                    const SizedBox(height: 12),
                  ],
                  ElevatedButton(
                    onPressed: _faceVerified ? _markAttendance : () async {
                      // If not verified yet, verify then mark
                      await _verifyFace();
                      if (_faceVerified) await _markAttendance();
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    child: const Text('Submit Attendance'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  final bool verified;

  const _StatusItem({
    required this.label,
    required this.verified,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          verified ? Icons.check_circle : Icons.error,
          color: verified ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(label),
        const Spacer(),
        Text(
          verified ? 'Verified' : 'Not Verified',
          style: TextStyle(
            color: verified ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}