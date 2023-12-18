import 'package:flutter/material.dart';
import 'package:mailer/views/home_view.dart';
import 'package:mailer/widgets/custom_button.dart';
import 'package:mailer/widgets/custom_text_field.dart';
import '../services/get_variables_service.dart';
import '../services/login_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? errorMessage;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "EgyMailer",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 32,
                            color: Color(0xff005599)),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Image(
                        image: AssetImage("assets/images/img.jpeg"),
                        height: 50,
                        width: 50,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 80),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xff005599),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Login",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hint: "Username/Gmail",
                              color: Colors.white,
                              controller: usernameController,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hint: "Password",
                              color: Colors.white,
                              obscureText: !isPasswordVisible,
                              // Toggle visibility
                              controller: passwordController,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            if (errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            CustomButton(
                              text: "Login",
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final response = await LoginService(
                                            'https://d0d0-209-145-62-248.ngrok-free.app')
                                        .loginUser(
                                      usernameController.text,
                                      passwordController.text,
                                    );

                                    if (response['success']) {
                                      // Login successful, handle accordingly
                                      print(
                                          'Login successful. Response: $response');
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeView(),
                                        ),
                                      );
                                    } else {
                                      // Login failed, show error message
                                      setState(() {
                                        errorMessage = response['message'];
                                      });
                                      print(
                                          'Login failed. Message: ${response['message']}');
                                    }
                                  } catch (error) {
                                    // Handle login error
                                    setState(() {
                                      errorMessage = 'Error during login';
                                    });
                                    print('Error during login: $error');
                                  }
                                }
                              },
                            ),
                            /*CustomButton(text: "SKIP", onPressed: (){
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const HomeView(),
                                ),
                              );
                            })*/
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
