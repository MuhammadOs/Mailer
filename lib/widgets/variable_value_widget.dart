import 'package:flutter/material.dart';
import 'package:mailer/models/variables_model.dart';
import 'package:mailer/widgets/custom_text_field.dart';

class VariableValueWidget extends StatefulWidget {
  final int itemCount;
  final List<VariableItem> variables;
  final void Function(VariableItem) onVariableRemoved;
  final void Function(VariableItem, String) onVariableValueChanged;

  VariableValueWidget({
    required this.itemCount,
    required this.variables,
    required this.onVariableRemoved,
    required this.onVariableValueChanged,
  });

  @override
  _VariableValueWidgetState createState() => _VariableValueWidgetState();
}

class _VariableValueWidgetState extends State<VariableValueWidget> {
  // ... (rest of the code remains unchanged)

  Widget buildRow(VariableItem item) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 4,
            child: CustomTextField(
              hint: "Variable",
              color: Colors.white,
              initialValue: item.variable,
              onChanged: (value) {
                setState(() {
                  item.variable = value;
                  widget.onVariableValueChanged(item, value);
                });
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: CustomTextField(
              hint: "Value",
              color: Colors.white,
              initialValue: item.value,
              onChanged: (value) {
                setState(() {
                  item.value = value;
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: IconButton(
                onPressed: () {
                  widget.onVariableRemoved(item);
                },
                icon: const Icon(
                  Icons.horizontal_rule_rounded,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addVariableRow() {
    setState(() {
      widget.variables.add(VariableItem(value: "", variable: ""));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Use ListView.builder
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.variables.length,
          itemBuilder: (context, index) {
            if (index < widget.variables.length) {
              return buildRow(widget.variables[index]);
            } else {
              return Container();
            }
          },
        ),
        // Add Variable button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
          child: Row(
            children: [
              const Text(
                "Add Variable",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 22,
                  color: Color(0xff005599),
                ),
              ),
              IconButton(
                onPressed: addVariableRow,
                icon: const Icon(
                  Icons.add,
                  size: 30,
                  color: Color(0xff005599),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
