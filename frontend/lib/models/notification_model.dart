class NotificationModel {
  final String id;
  final String message;
  final String role;
  final DateTime timestamp;
  final String? senderId;
  final String? type;

  NotificationModel({
    required this.id,
    required this.message,
    required this.role,
    required this.timestamp,
    this.senderId,
    this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      message: json['message'] ?? '',
      role: json['role'] ?? 'all',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      senderId: json['senderId'],
      type: json['type'],
    );
  }
}