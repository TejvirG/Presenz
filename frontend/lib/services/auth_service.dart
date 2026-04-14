import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/api_config.dart';

class AuthService {
  // Base URL from api_config.dart → e.g., https://presenz.nordjs.cloud/api
  static const String baseUrl = "$apiBaseUrl/auth";
  static const timeout = Duration(seconds: 10);

  // ---------------- SIGN UP ----------------
  Future<void> signup(String name, String email, String password, String role) async {
    try {
      final uri = Uri.parse("$baseUrl/signup");

      // Ensure proper role capitalization
      final capitalizedRole = role[0].toUpperCase() + role.substring(1);

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "role": capitalizedRole,
        }),
      ).timeout(timeout);

      if (response.statusCode == 201) {
        // Registration successful
        return;
      } else {
        final Map<String, dynamic> resBody = jsonDecode(response.body);
        throw Exception(resBody['error'] ?? resBody['message'] ?? "Failed to register");
      }
    } on TimeoutException {
      throw Exception("Connection timed out. Please check your internet connection.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ---------------- LOGIN ----------------
  Future<UserModel> login(String email, String password) async {
    try {
      final uri = Uri.parse("$baseUrl/login");

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Login Response: $data'); // Debug log
        
        // Check if the response has the expected structure
        if (!data.containsKey('user')) {
          throw Exception("Invalid response format from server");
        }

        Map<String, dynamic> userData = data['user'];
        if (data.containsKey('token')) {
          userData = {...userData, 'token': data['token']};
        }

        // Create user model from the response
        final user = UserModel.fromJson(userData);

        // Save token locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', user.token ?? '');
        await prefs.setString('role', user.role.toLowerCase()); // Ensure lowercase
        await prefs.setString('email', user.email);

        return user;
      } else {
        final Map<String, dynamic> resBody = jsonDecode(response.body);
        throw Exception(resBody['error'] ?? resBody['message'] ?? "Login failed");
      }
    } on TimeoutException {
      throw Exception("Connection timed out. Please check your internet connection.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ---------------- LOGOUT ----------------
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ---------------- GET PROFILE ----------------
  Future<UserModel?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return null;

    final uri = Uri.parse("$baseUrl/profile");

    final response = await http.get(uri, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception("Failed to load profile");
    }
  }

  // ---------------- CHECK AUTH STATE ----------------
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
  
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
