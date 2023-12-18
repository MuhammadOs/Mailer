class VariablesModel {
  List<VariableItem> variables;

  VariablesModel({
    required this.variables,
  });

  factory VariablesModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('variables') && json['variables'] is List) {
      List<dynamic> variablesList = json['variables'];
      List<VariableItem> variableItems = variablesList
          .whereType<Map<String, dynamic>>() // Filter out unexpected items
          .map((item) => VariableItem.fromJson(item))
          .toList();

      return VariablesModel(variables: variableItems);
    } else {
      throw Exception('Unexpected format for variables');
    }
  }

  Map<String, dynamic> toJson() {
    return {'variables': variables.map((item) => item.toJson()).toList()};
  }
}

class VariableItem {
  String value;
  String variable;

  VariableItem({
    required this.value,
    required this.variable,
  });

  factory VariableItem.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('value') && json.containsKey('variable')) {
      return VariableItem(
        value: json['value'],
        variable: json['variable'],
      );
    } else {
      throw Exception('Unexpected format for variables item');
    }
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'variable': variable};
  }
}
