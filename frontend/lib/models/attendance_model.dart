import 'package:geolocator/geolocator.dart';

enum AttendanceStatus { present, absent, late }

class AttendanceModel {
  final String id;
  final String studentId;
  final String className;
  final DateTime timestamp;
  final AttendanceStatus status;
  final bool faceVerified;
  final Position? location;

  AttendanceModel({
    required this.id,
    required this.studentId,
    required this.className,
    required this.timestamp,
    required this.status,
    required this.faceVerified,
    this.location,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['_id'] as String,
      studentId: json['studentId'] as String,
      className: json['classId']['name'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: AttendanceStatus.values.firstWhere(
        (e) => e.toString() == 'AttendanceStatus.${json['status']}',
      ),
      faceVerified: json['faceVerified'] as bool? ?? false,
      location: json['location'] != null
          ? Position.fromMap({
              'longitude': json['location']['longitude'] as double,
              'latitude': json['location']['latitude'] as double,
              'timestamp': (DateTime.parse(json['location']['timestamp'] as String).millisecondsSinceEpoch),
              'accuracy': json['location']['accuracy'] as double,
              'altitude': json['location']['altitude'] as double,
              'speed': json['location']['speed'] as double,
              'speedAccuracy': json['location']['speedAccuracy'] as double,
              'heading': json['location']['heading'] as double,
            })
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'studentId': studentId,
        'className': className,
        'timestamp': timestamp.toIso8601String(),
        'status': status.toString().split('.').last,
        'faceVerified': faceVerified,
        'location': location != null
            ? {
                'longitude': location!.longitude,
                'latitude': location!.latitude,
                'timestamp': location!.timestamp.toIso8601String(),
                'accuracy': location!.accuracy,
                'altitude': location!.altitude,
                'heading': location!.heading,
                'speed': location!.speed,
                'speedAccuracy': location!.speedAccuracy,
              }
            : null,
      };
}
