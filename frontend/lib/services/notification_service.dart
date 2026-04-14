import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';
import '../utils/api_config.dart';

class NotificationService {
  final String? token;
  static const timeout = Duration(seconds: 10);

  NotificationService({this.token});

  Future<List<NotificationModel>> getNotifications() async {
    final uri = Uri.parse("$apiBaseUrl/notifications");
    final headers = token != null ? {"Authorization": "Bearer $token"} : null;
    
    final response = await http.get(uri, headers: headers).timeout(timeout);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load notifications");
    }
  }

  Future<NotificationModel> createNotification({
    required String message,
    required String role,
    String? type,
  }) async {
    if (token == null) throw Exception("Not authenticated");

    final uri = Uri.parse("$apiBaseUrl/notifications");
    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "message": message,
        "role": role,
        if (type != null) "type": type,
      }),
    ).timeout(timeout);

    if (response.statusCode == 201) {
      return NotificationModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create notification");
    }
  }
}