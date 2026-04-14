import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/attendance_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/gradient_appbar.dart';

class TakeAttendancePage extends StatefulWidget {
  final Map<String, dynamic> classData;
  
  const TakeAttendancePage({
    super.key,
    required this.classData,
  });

  @override
  State<TakeAttendancePage> createState() => _TakeAttendancePageState();
}

class _TakeAttendancePageState extends State<TakeAttendancePage> {
  late Position _currentPosition;
  bool _isLoading = true;
  bool _isMarkingAttendance = false;
  final Map<String, bool> _attendanceMap = {};
  final List<Map<String, dynamic>> _studentList = [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _getCurrentLocation();
      await _loadStudentList();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    _currentPosition = await Geolocator.getCurrentPosition();
  }

  Future<void> _loadStudentList() async {
    // In a real app, this would fetch from your backend
    // For now, we'll generate a sample list
    final sectionStudents = List.generate(
      widget.classData['totalStudents'] as int,
      (index) => {
        'id': 'S${index + 1}',
        'name': 'Student ${index + 1}',
        'rollNo': '${widget.classData['courseCode']}-${(index + 1).toString().padLeft(3, '0')}',
        'section': widget.classData['section'],
      },
    );

    setState(() {
      _studentList.addAll(sectionStudents);
      for (var student in sectionStudents) {
        _attendanceMap[student['id']] = false;
      }
    });
  }

  Future<void> _submitAttendance() async {
    if (_isMarkingAttendance) return;

    setState(() => _isMarkingAttendance = true);

    try {
      final attendanceService = AttendanceService(
        token: await AuthService().getToken() ?? '',
      );

      // Prepare attendance data
      final attendanceData = _attendanceMap.entries.map((entry) => {
        'studentId': entry.key,
        'status': entry.value ? 'present' : 'absent',
        'classId': widget.classData['courseCode'],
        'timestamp': DateTime.now().toIso8601String(),
        'location': {
          'latitude': _currentPosition.latitude,
          'longitude': _currentPosition.longitude,
        },
      }).toList();

      // Submit attendance
      await attendanceService.submitBulkAttendance(attendanceData);

      if (!mounted) return;
      Navigator.pop(context, true); // Return success

    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isMarkingAttendance = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: "Take Attendance - ${widget.classData['name']}",
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _initializeData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Class Info Card
                    Card(
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.classData['courseCode']} - ${widget.classData['name']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Section: ${widget.classData['section']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Time: ${widget.classData['time']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Room: ${widget.classData['room']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Quick Actions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  for (var id in _attendanceMap.keys) {
                                    _attendanceMap[id] = true;
                                  }
                                });
                              },
                              child: const Text('Mark All Present'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  for (var id in _attendanceMap.keys) {
                                    _attendanceMap[id] = false;
                                  }
                                });
                              },
                              child: const Text('Mark All Absent'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Student List
                    Expanded(
                      child: ListView.builder(
                        itemCount: _studentList.length,
                        itemBuilder: (context, index) {
                          final student = _studentList[index];
                          return CheckboxListTile(
                            value: _attendanceMap[student['id']] ?? false,
                            onChanged: (bool? value) {
                              setState(() {
                                _attendanceMap[student['id']] = value ?? false;
                              });
                            },
                            title: Text(student['name']),
                            subtitle: Text(student['rollNo']),
                            secondary: CircleAvatar(
                              child: Text(
                                student['name'].substring(0, 1),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _isMarkingAttendance ? null : _submitAttendance,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: _isMarkingAttendance
              ? const CircularProgressIndicator()
              : const Text(
                  'Submit Attendance',
                  style: TextStyle(fontSize: 16),
                ),
        ),
      ),
    );
  }
}