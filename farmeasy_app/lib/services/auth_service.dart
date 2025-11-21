import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // ✅ Base URL for local backend (use 10.0.2.2 for Android Emulator)
  static const String baseUrl = "http://192.168.1.4:5000";

  // Common headers used in all requests
  static Map<String, String> _headers({String? token, String? deviceId}) {
    return {
      'Authorization': token ?? '',
      'Device-Id': deviceId ?? 'flutter-device',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// ✅ Send Login OTP (Existing Users)
  static Future<bool> sendLoginOtp(String mobile, {String? deviceId}) async {
    final url = Uri.parse('$baseUrl/api/auth/login/send-otp');

    final response = await http.post(
      url,
      headers: _headers(deviceId: deviceId),
      body: jsonEncode({
        "phone_number": mobile,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? "Failed to send login OTP");
    }
  }

  /// ✅ Send Register OTP (New Users)
  static Future<bool> sendRegisterOtp(String mobile, String fullName, {String? deviceId}) async {
    final url = Uri.parse('$baseUrl/api/auth/register/send-otp');

    final response = await http.post(
      url,
      headers: _headers(deviceId: deviceId),
      body: jsonEncode({
        "phone_number": mobile,
        "full_name": fullName,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? "Failed to send register OTP");
    }
  }

  /// ✅ Verify Login OTP
  static Future<Map<String, dynamic>> verifyLoginOtp(String mobile, String otp, {String? deviceId}) async {
    final url = Uri.parse('$baseUrl/api/auth/login/verify-otp');

    final response = await http.post(
      url,
      headers: _headers(deviceId: deviceId),
      body: jsonEncode({
        "phone_number": mobile,
        "otp": otp,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        // Return token + user data
        return {
          "token": data["token"],
          "user": data["user"],
          "message": data["message"],
        };
      }
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? "Login OTP verification failed");
    }

    throw Exception("Unexpected response from server");
  }

  /// ✅ Verify Register OTP
  static Future<Map<String, dynamic>> verifyRegisterOtp(String mobile, String otp, {String? deviceId}) async {
    final url = Uri.parse('$baseUrl/api/auth/register/verify-otp');

    final response = await http.post(
      url,
      headers: _headers(deviceId: deviceId),
      body: jsonEncode({
        "phone_number": mobile,
        "otp": otp,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        // Return token + user data
        return {
          "token": data["token"],
          "user": data["user"],
          "message": data["message"],
        };
      }
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? "Register OTP verification failed");
    }

    throw Exception("Unexpected response from server");
  }
}
