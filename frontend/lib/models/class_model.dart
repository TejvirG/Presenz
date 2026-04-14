class ClassLocation {
  final double latitude;
  final double longitude;
  final double radius; // in meters

  ClassLocation({
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  factory ClassLocation.fromJson(Map<String, dynamic> json) {
    return ClassLocation(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      radius: json['radius'] as double,
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      };
}

class ClassModel {
  final String id;
  final String name;
  final String subject;
  final String courseCode;
  final String teacherId;
  final ClassLocation? location;
  final String day;
  final String time;

  ClassModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.courseCode,
    required this.teacherId,
    this.location,
    required this.day,
    required this.time,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      courseCode: json['courseCode'] as String,
      teacherId: json['teacherId'] as String,
      location: json['location'] != null
          ? ClassLocation.fromJson(json['location'])
          : null,
      day: json['schedule']['day'] ?? '',
      time: json['schedule']['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'subject': subject,
        'courseCode': courseCode,
        'teacherId': teacherId,
        'location': location?.toJson(),
        'schedule': {
          'day': day,
          'time': time,
        },
      };
}
