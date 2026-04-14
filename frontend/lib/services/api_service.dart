import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_config.dart';

class ApiService {
  String? token;

  ApiService({this.token});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Future<dynamic> get(String endpoint) async {
    token ??= await _getToken();
    final res = await http.get(Uri.parse('$apiBaseUrl/$endpoint'), headers: headers);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body);
    } else {
      throw Exception('GET $endpoint failed: ${res.statusCode}');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    token ??= await _getToken();
    final res = await http.post(
      Uri.parse('$apiBaseUrl/$endpoint'),
      headers: headers,
      body: json.encode(body),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body);
    } else {
      throw Exception('POST $endpoint failed: ${res.statusCode}');
    }
  }

  Future<bool> registerFace(String faceData) async {
    final res = await post('face/register', {'faceData': faceData});
    return res['message'] == 'Face registered successfully';
  }

  Future<bool> verifyFace(String faceData) async {
    final res = await post('face/verify', {'faceData': faceData});
    return res['message'] == 'Face verified successfully';
  }

  Future<bool> markAttendance({
    required String subject,
    required double latitude,
    required double longitude,
    required bool faceVerified,
  }) async {
    final res = await post('attendance/mark', {
      'subject': subject,
      'latitude': latitude,
      'longitude': longitude,
      'faceVerified': faceVerified,
    });
    return res['message'] == 'Attendance marked successfully';
  }

  Future<bool> setClassLocation(String subject, double latitude, double longitude) async {
    final res = await post('classes/set-location', {
      'subject': subject,
      'latitude': latitude,
      'longitude': longitude,
    });
    return res != null;
  }
}
