import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import '../../widgets/gradient_appbar.dart';
import '../../widgets/stat_item.dart';
import '../../models/class_model.dart';
import '../../models/attendance_model.dart';
import '../../services/auth_service.dart';
import '../../services/attendance_service.dart';
import '../mark_attendance_page.dart';
import '../attendance_history_page.dart';
import '../../services/mock_data_service.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  late Future<Map<String, dynamic>> _dashboardData;
  final _authService = AuthService();
  late AttendanceService _attendanceService;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final token = await _authService.getToken();
    _attendanceService = AttendanceService(token: token);
    setState(() {
      _dashboardData = _loadDashboardData();
    });
  }

  Future<Map<String, dynamic>> _loadDashboardData() async {
    try {
      final stats = await _attendanceService.getAttendanceStats();
      final history = await _attendanceService.getAttendanceHistory();
      
      // Group by subject/class
      final Map<String, List<AttendanceModel>> byClass = {};
      for (var record in history) {
        final className = record.className;
        if (!byClass.containsKey(className)) {
          byClass[className] = [];
        }
        byClass[className]!.add(record);
      }

      // Calculate percentage for each class
      final Map<String, double> percentages = {};
      byClass.forEach((className, records) {
        final total = records.length;
        final present = records.where((r) => r.status == AttendanceStatus.present).length;
        percentages[className] = (present / total) * 100;
      });

      return {
        'stats': stats,
        'history': history,
        'percentages': percentages,
      };
    } catch (e) {
      print('Error loading dashboard data: $e');
      rethrow;
    }
  }

  Future<void> _giveAttendance() async {
    try {
      // Check location permission first
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission is required')),
          );
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission is permanently denied. Please enable it in settings.'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      // Let the student pick a class from available sample classes (mock)
      final selected = await showDialog<ClassModel?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select Class'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: MockDataService.sampleClasses.length,
                itemBuilder: (context, index) {
                  final c = MockDataService.sampleClasses[index];
                  return ListTile(
                    title: Text(c.name),
                    subtitle: Text('${c.courseCode} • ${c.time}'),
                    onTap: () => Navigator.pop(context, c),
                  );
                },
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ],
          );
        },
      );

      if (selected == null) return;

      // Get location first
      if (!mounted) return;
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Location service took too long to respond');
        },
      );

      // Then initialize camera
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras available on this device');
      }

      // Find front camera
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MarkAttendancePage(
            classData: selected,
            camera: frontCamera,
            position: position,
          ),
        ),
      );

      // Refresh dashboard after returning
      setState(() {
        _dashboardData = _loadDashboardData();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: "Student Dashboard"),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _dashboardData = _loadDashboardData();
          });
        },
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dashboardData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error: ${snapshot.error}"),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _dashboardData = _loadDashboardData();
                        });
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            final data = snapshot.data!;
            final stats = data['stats'] as Map<String, dynamic>;
            final percentages = data['percentages'] as Map<String, double>;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Attendance Overview Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Attendance Overview",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StatItem(
                              label: "Overall",
                              value: "${stats['overallAttendance']}%",
                            ),
                            StatItem(
                              label: "This Month",
                              value: "${stats['monthlyAttendance']}%",
                            ),
                            StatItem(
                              label: "Today",
                              value: "${stats['todayClasses']} Classes",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Subject-wise Attendance
                const Text(
                  "Subject-wise Attendance",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...percentages.entries.map((entry) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(entry.key),
                    subtitle: LinearProgressIndicator(
                      value: entry.value / 100,
                      backgroundColor: Colors.grey[200],
                    ),
                    trailing: Text(
                      "${entry.value.toStringAsFixed(1)}%",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AttendanceHistoryPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.history),
                        label: const Text("View History"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _giveAttendance,
                        icon: const Icon(Icons.check_circle),
                        label: const Text("Give Attendance"),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
