import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mailer/services/get_variables_service.dart';
import 'package:mailer/services/save_variables_service.dart';
import 'package:mailer/services/send_mail_service.dart';
import 'package:mailer/widgets/custom_button.dart';
import 'package:mailer/widgets/custom_text_field.dart';
import 'package:mailer/widgets/variable_value_widget.dart';
import '../models/variables_model.dart';
import '../widgets/custom_upload_row.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  File? _pickedFile;
  late String title = '';
  late String body = '';
  late List<VariableItem> variables = [];
  bool isFetchingVariables = false;
  bool isSavingVariables = false;
  bool isSendingMail = false;

  @override
  void initState() {
    super.initState();
    fetchVariables();
  }

  void toggleLoading(bool value,
      {bool isFetch = false, bool isSave = false, bool isSend = false}) {
    setState(() {
      isFetchingVariables = isFetch;
      isSavingVariables = isSave;
      isSendingMail = isSend;
    });
  }

  void fetchVariables() async {
    try {
      setState(() {
        toggleLoading(true, isFetch: true);
      });

      VariablesModel variablesModel = await GetVariablesService(
        'https://d0d0-209-145-62-248.ngrok-free.app',
      ).getVariables();

      setState(() {
        variables = variablesModel.variables;
      });
      setState(() {
        toggleLoading(false, isFetch: true);
        isFetchingVariables = false;
      });
    } catch (error) {
      handleFetchError(error);
    }
  }

  void handleFetchError(dynamic error) {
    // Handle the specific error scenarios
    String errorMessage = 'Failed to load variables.';

    if (error is FormatException) {
      errorMessage = 'Unexpected format in response: $error';
    } else if (error is Exception) {
      errorMessage = 'An unexpected error occurred: $error';
    }

    setState(() {
      toggleLoading(false, isFetch: true);
    });

    // Display error message to the user if needed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void saveVariables() async {
    try {
      setState(() {
        toggleLoading(true, isSave: true);
      });

      // Show loading indicator for saving variables
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saving variables...'),
          duration: Duration(seconds: 3),
        ),
      );

      await SaveVariablesService().saveVariables(variables).then((_) {
        // Hide loading indicator for saving variables
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Variables saved successfully'),
            duration: Duration(seconds: 3),
          ),
        );
        setState(() {
          isSavingVariables = false;
        });
      });
    } catch (error) {
      //print('Error saving variables: $error');
    }
  }

  void onVariableValueChanged(VariableItem variable, String value) {
    int index = variables.indexOf(variable);
    if (index != -1) {
      setState(() {
        variables[index] = VariableItem(
          value: value,
          variable: variable.variable,
        );
      });
    }
  }

  void sendMail() async {
    setState(() {
      toggleLoading(true, isSend: true);
    });
    try {
      if (title.isEmpty || body.isEmpty || _pickedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields and upload a file.'),
            duration: Duration(seconds: 3),
          ),
        );
        setState(() {
          isSendingMail = false;
        });
        return;
      }
      final response =
          await SendMailService('https://d0d0-209-145-62-248.ngrok-free.app')
              .sendMail(
        title,
        body,
        _pickedFile!,
      );
      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mail sent successfully'),
            duration: Duration(seconds: 3),
          ),
        );
        setState(() {
          isSendingMail = false;
        });
        print('Mail sent successfully. Response: $response');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending mail: ${response['message']}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error sending mail'),
          duration: Duration(seconds: 3),
        ),
      );
      //print('Error sending mail: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            "Mailer",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: Color(0xff005599),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomUploadRow(
                            text: "Mailing List",
                            onFilePicked: (File pickedFile) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('File uploaded'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              //print('Picked file: ${pickedFile.path}');
                              setState(() {
                                _pickedFile = pickedFile;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    CustomTextField(
                      hint: "Mail Title",
                      color: Colors.white,
                      onChanged: (value) {
                        title = value ?? '';
                      },
                    ),
                    CustomTextField(
                      hint: "Mail Body",
                      color: Colors.white,
                      maxLines: 3,
                      onChanged: (value) {
                        body = value ?? '';
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: Color(0xff005599),
                      ),
                      onPressed: () {
                        fetchVariables();
                      },
                    ),
                    if (isFetchingVariables)
                      const CircularProgressIndicator()
                    else
                      VariableValueWidget(
                        itemCount: variables.length,
                        variables: variables,
                        onVariableRemoved: (VariableItem variable) {
                          setState(() {
                            variables.remove(variable);
                          });
                        },
                        onVariableValueChanged: onVariableValueChanged,
                      ),
                  ],
                ),
                Column(
                  children: [
                    if (isSavingVariables)
                      const CircularProgressIndicator()
                    else
                      CustomButton(
                        text: "Save",
                        onPressed: () => saveVariables(),
                      ),
                    if (isSendingMail)
                      const CircularProgressIndicator()
                    else
                      CustomButton(
                        text: "Send",
                        onPressed: () async => sendMail(),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
