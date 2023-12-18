import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl;

  LoginService(this.baseUrl);

  Future<Map<String, dynamic>> loginUser(String username, String password) async {
    try {
      final String url = '$baseUrl/login';

      final Map<String, dynamic> body = {
        'username': username,
        'password': password,
      };

      final http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Invalid username or password');
      }
    } catch (error) {
      throw error;
    }
  }
}
