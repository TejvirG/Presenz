import 'package:geolocator/geolocator.dart';
import '../models/attendance_model.dart';
import 'mock_data_service.dart';

class AttendanceService {
  final String? token;
  static const timeout = Duration(seconds: 30);

  AttendanceService({this.token});

  Future<bool> markAttendance({
    required String classId,
    required Position position,
    required bool faceVerified,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // For mock mode: append a new attendance record to sampleAttendance so history updates
    try {
      final classModel = MockDataService.sampleClasses.firstWhere((c) => c.id == classId, orElse: () => MockDataService.sampleClasses.first);

      final newRecord = AttendanceModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        studentId: token ?? 's1',
        className: classModel.name,
        timestamp: DateTime.now(),
        status: AttendanceStatus.present,
        faceVerified: faceVerified,
        location: Position.fromMap({
          'longitude': position.longitude,
          'latitude': position.latitude,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'accuracy': position.accuracy,
          'altitude': position.altitude,
          'heading': position.heading,
          'speed': position.speed,
          'speedAccuracy': position.speedAccuracy,
        }),
      );

      MockDataService.sampleAttendance.insert(0, newRecord);
    } catch (e) {
      // ignore and still return success for mock
    }

    return true; // In a real app, this would send the data to the server
  }

  Future<List<AttendanceModel>> getAttendanceHistory() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return MockDataService.sampleAttendance;
  }

  Future<Map<String, dynamic>> getAttendanceStats() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return MockDataService.getAttendanceStats();
  }

  Future<void> submitBulkAttendance(List<Map<String, dynamic>> attendanceData) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    
    // In a real app, this would make an API call:
    // final response = await http.post(
    //   Uri.parse('$apiBaseUrl/attendance/bulk'),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Authorization': 'Bearer $token',
    //   },
    //   body: jsonEncode({
    //     'attendance': attendanceData,
    //   }),
    // );
    
    // For now, just simulate success
    // You can add this to your mock data service if needed
    return;
  }
}