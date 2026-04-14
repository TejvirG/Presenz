class ReportModel {
  final int totalUsers;
  final int totalClasses;
  final int totalAttendance;

  ReportModel({
    required this.totalUsers,
    required this.totalClasses,
    required this.totalAttendance,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        totalUsers: json['totalUsers'],
        totalClasses: json['totalClasses'],
        totalAttendance: json['totalAttendance'],
      );
}
