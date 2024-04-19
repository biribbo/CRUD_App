import 'package:crud_app/widgets/input_text_field.dart';
import 'package:flutter/material.dart';
import '../../service/auth_service.dart';

class LoginPage extends StatefulWidget {
  final AuthService _authService;
  final Function loginAttempt;

  const LoginPage(
      {super.key, required AuthService authService, required this.loginAttempt})
      : _authService = authService;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputTextField(controller: usernameController, text: "Username"),
            const SizedBox(height: 16.0),
            InputTextField(controller: passwordController, text: "Password"),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                bool loggedIn = await widget._authService.login(
                  usernameController.text,
                  passwordController.text,
                );
                if (loggedIn) {
                  widget.loginAttempt();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
