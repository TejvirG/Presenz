import 'package:geolocator/geolocator.dart';
import '../models/attendance_model.dart';
import '../models/class_model.dart';

class MockDataService {
  static final List<ClassModel> sampleClasses = [
    ClassModel(
      id: '1',
      name: 'Data Structures',
      subject: 'Computer Science',
      courseCode: 'CS201',
      teacherId: 't1',
      day: 'Monday',
      time: '10:30 AM',
      // Thapar University, Patiala (approximate coordinates near the library)
      location: ClassLocation(
        latitude: 30.3430,
        longitude: 76.3860,
        radius: 100,
      ),
    ),
    ClassModel(
      id: '2',
      name: 'Advanced Calculus',
      subject: 'Mathematics',
      courseCode: 'MTH202',
      teacherId: 't2',
      day: 'Wednesday',
      time: '11:30 AM',
      location: ClassLocation(
        latitude: 30.3432,
        longitude: 76.3861,
        radius: 100,
      ),
    ),
    ClassModel(
      id: '3',
      name: 'Digital Electronics',
      subject: 'Electronics',
      courseCode: 'ECE201',
      teacherId: 't3',
      day: 'Tuesday',
      time: '09:30 AM',
      location: ClassLocation(
        latitude: 30.3431,
        longitude: 76.3858,
        radius: 100,
      ),
    ),
    ClassModel(
      id: '4',
      name: 'Operating Systems',
      subject: 'Computer Science',
      courseCode: 'CS301',
      teacherId: 't1',
      day: 'Thursday',
      time: '02:30 PM',
      location: ClassLocation(
        latitude: 30.3429,
        longitude: 76.3862,
        radius: 100,
      ),
    ),
  ];

  static final List<AttendanceModel> sampleAttendance = [
    AttendanceModel(
      id: '1',
      studentId: 's1',
      className: 'Computer Science',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      status: AttendanceStatus.present,
      faceVerified: true,
      location: Position.fromMap({
        'longitude': -122.4194,
        'latitude': 37.7749,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'accuracy': 0.0,
        'altitude': 0.0,
        'heading': 0.0,
        'speed': 0.0,
        'speedAccuracy': 0.0,
      }),
    ),
    AttendanceModel(
      id: '2',
      studentId: 's1',
      className: 'Mathematics',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      status: AttendanceStatus.present,
      faceVerified: true,
      location: Position.fromMap({
        'longitude': -122.4194,
        'latitude': 37.7749,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'accuracy': 0.0,
        'altitude': 0.0,
        'heading': 0.0,
        'speed': 0.0,
        'speedAccuracy': 0.0,
      }),
    ),
    AttendanceModel(
      id: '3',
      studentId: 's1',
      className: 'Physics',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      status: AttendanceStatus.late,
      faceVerified: true,
      location: Position.fromMap({
        'longitude': -122.4194,
        'latitude': 37.7749,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'accuracy': 0.0,
        'altitude': 0.0,
        'heading': 0.0,
        'speed': 0.0,
        'speedAccuracy': 0.0,
      }),
    ),
  ];

  static Map<String, dynamic> getAttendanceStats() {
    return {
      'overallAttendance': 88,
      'monthlyAttendance': 92,
      'todayClasses': 4,
      'totalClasses': 48,
      'attendedClasses': 42,
      'missedClasses': 6,
      'subjects': [
        {
          'name': 'Data Structures',
          'attendance': 90,
          'total': 12,
          'present': 11,
        },
        {
          'name': 'Operating Systems',
          'attendance': 85,
          'total': 12,
          'present': 10,
        },
        {
          'name': 'Computer Networks',
          'attendance': 92,
          'total': 12,
          'present': 11,
        },
        {
          'name': 'Database Systems',
          'attendance': 88,
          'total': 12,
          'present': 10,
        },
      ],
      'nextClass': {
        'name': 'Data Structures',
        'time': '10:30 AM',
        'room': 'LH-201',
        'teacher': 'Dr. Sharma',
      },
    };
  }

  static List<Map<String, dynamic>> getTeacherClasses() {
    return [
      {
        'name': 'Data Structures',
        'courseCode': 'CS201',
        'time': '10:30 AM',
        'totalStudents': 60,
        'presentToday': 55,
        'section': 'CSE-A',
        'room': 'LH-201',
      },
      {
        'name': 'Operating Systems',
        'courseCode': 'CS301',
        'time': '02:30 PM',
        'totalStudents': 65,
        'presentToday': 58,
        'section': 'CSE-B',
        'room': 'LH-301',
      },
      {
        'name': 'Computer Networks',
        'courseCode': 'CS401',
        'time': '11:30 AM',
        'totalStudents': 55,
        'presentToday': 50,
        'section': 'CSE-C',
        'room': 'LH-401',
      },
      {
        'name': 'Database Systems',
        'courseCode': 'CS302',
        'time': '03:30 PM',
        'totalStudents': 62,
        'presentToday': 57,
        'section': 'CSE-A',
        'room': 'LH-202',
      },
    ];
  }

  static List<Map<String, dynamic>> getTeacherStats() {
    return [
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'attendance': 95,
        'classes': [
          {'name': 'Data Structures', 'section': 'CSE-A', 'present': 55, 'total': 60},
          {'name': 'Operating Systems', 'section': 'CSE-B', 'present': 58, 'total': 65},
        ],
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'attendance': 92,
        'classes': [
          {'name': 'Computer Networks', 'section': 'CSE-C', 'present': 50, 'total': 55},
          {'name': 'Database Systems', 'section': 'CSE-A', 'present': 57, 'total': 62},
        ],
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'attendance': 90,
        'classes': [
          {'name': 'Data Structures', 'section': 'CSE-A', 'present': 54, 'total': 60},
          {'name': 'Operating Systems', 'section': 'CSE-B', 'present': 60, 'total': 65},
        ],
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'attendance': 88,
        'classes': [
          {'name': 'Computer Networks', 'section': 'CSE-C', 'present': 48, 'total': 55},
          {'name': 'Database Systems', 'section': 'CSE-A', 'present': 55, 'total': 62},
        ],
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'attendance': 94,
        'classes': [
          {'name': 'Data Structures', 'section': 'CSE-A', 'present': 57, 'total': 60},
          {'name': 'Operating Systems', 'section': 'CSE-B', 'present': 61, 'total': 65},
        ],
      },
    ];
  }
}