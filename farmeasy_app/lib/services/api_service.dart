// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   // ⚙️ Base URL — update according to your backend (for emulator use 10.0.2.2)
//   static const String baseUrl = 'http://10.0.2.2:5000/api/v1';

//   /// ✅ Check if user already exists
//   static Future<bool> checkUserExists(String mobile) async {
//     final url = Uri.parse('$baseUrl/users/check');
//     final body = jsonEncode({'mobile': mobile});

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );

//       print('🔍 checkUserExists → ${response.statusCode}, ${response.body}');
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data['exists'] == true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       print('⚠️ Error in checkUserExists: $e');
//       return false;
//     }
//   }

//   /// ✅ Send OTP to user
//   static Future<bool> sendOtp(String mobile) async {
//     final url = Uri.parse('$baseUrl/users/send-otp');
//     final body = jsonEncode({'mobile': mobile});

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );

//       print('📩 sendOtp → ${response.statusCode}, ${response.body}');
//       return response.statusCode == 200;
//     } catch (e) {
//       print('⚠️ Error in sendOtp: $e');
//       return false;
//     }
//   }

//   /// ✅ Create new user account
//   static Future<bool> createUser(String mobile, String name) async {
//     final url = Uri.parse('$baseUrl/users/create');
//     final body = jsonEncode({'mobile': mobile, 'name': name});

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );

//       print('🧾 createUser → ${response.statusCode}, ${response.body}');
//       return response.statusCode == 200 || response.statusCode == 201;
//     } catch (e) {
//       print('⚠️ Error in createUser: $e');
//       return false;
//     }
//   }

//   /// ✅ Verify OTP
//   static Future<Map<String, dynamic>?> verifyOtp(String mobile, String otp) async {
//     final url = Uri.parse('$baseUrl/users/verify-otp');
//     final body = jsonEncode({'mobile': mobile, 'otp': otp});

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: body,
//       );

//       print('✅ verifyOtp → ${response.statusCode}, ${response.body}');
//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       }
//       return null;
//     } catch (e) {
//       print('⚠️ Error in verifyOtp: $e');
//       return null;
//     }
//   }
// }
