import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/variables_model.dart';

class SaveVariablesService {
  Future<Map<String, dynamic>> saveVariables(List<VariableItem> variableItems) async {
    try {
      final url = "https://d0d0-209-145-62-248.ngrok-free.app/save_variables";

      // Transform the variableItems into the expected format
      List<Map<String, dynamic>> transformedVariablesList =
      variableItems.map((item) => item.toJson()).toList();

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'variables': transformedVariablesList}),
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to save variables: ${response.statusCode}');
      }
    } catch (error) {
      // Handle errors and log additional details
      print('Error saving variables: $error');
      rethrow; // Rethrow the caught error to propagate it further
    }
  }
}

