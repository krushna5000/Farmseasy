import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // ✅ Base URL for local backend (use 10.0.2.2 for Android Emulator)
  static const String baseUrl = "http://localhost:5000";

  // Common headers used in all requests
  static Map<String, String> _headers({String? token, String? deviceId}) {
    return {
      'Authorization': token ?? '',
      'Device-Id': deviceId ?? 'flutter-device',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// ✅ Send OTP (New + Existing Users)
  static Future<bool> sendOtp(String mobile, {String? fullName, String? deviceId}) async {
    final url = Uri.parse('$baseUrl/api/auth/send-otp');

    // For existing users, full_name can be omitted
    final Map<String, dynamic> payload = {
      "phone_number": mobile,
      if (fullName != null && fullName.isNotEmpty) "full_name": fullName,
    };

    final response = await http.post(
      url,
      headers: _headers(deviceId: deviceId),
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? "Failed to send OTP");
    }
  }

  /// ✅ Verify OTP
  static Future<Map<String, dynamic>> verifyOtp(String mobile, String otp, {String? deviceId}) async {
    final url = Uri.parse('$baseUrl/api/auth/verify-otp');

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
      throw Exception(error['message'] ?? "OTP verification failed");
    }

    throw Exception("Unexpected response from server");
  }
}
