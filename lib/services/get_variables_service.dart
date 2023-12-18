import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/variables_model.dart';

class GetVariablesService {
  final String baseUrl;

  GetVariablesService(this.baseUrl);

  Future<VariablesModel> getVariables() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_variables'));

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        return VariablesModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load variables: ${response.statusCode}');
      }
    } catch (error) {
      // Handle errors and log additional details
      print('Error loading variables: $error');
      rethrow; // Rethrow the caught error to propagate it further
    }
  }
}
