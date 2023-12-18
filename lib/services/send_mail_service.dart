import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SendMailService {
  final String baseUrl;

  SendMailService(this.baseUrl);

  Future<Map<String, dynamic>> sendMail(
      String subject, String body, File emailsFile) async {
    try {
      final String url = '$baseUrl/send_mail';

      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['subject'] = subject
        ..fields['body'] = body
        ..files
            .add(await http.MultipartFile.fromPath('emails', emailsFile.path));

      final http.Response response =
          await http.Response.fromStream(await request.send());
      print(response.headers);
      print(response);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception(
            'There is an error with status code ${response.statusCode} with body ${response.body}');
      }
    } catch (error) {
      throw error;
    }
  }
}
