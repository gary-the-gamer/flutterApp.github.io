import 'package:flutter/material.dart';
import 'package:flutterapp/constants/routes.dart';
import 'package:flutterapp/services/auth/auth_exceptions.dart';
import 'package:flutterapp/services/auth/auth_service.dart';
import 'package:flutterapp/utlities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "Enter your email here"),
            controller: _email,
          ),
          TextField(
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter your passsword here",
            ),
            controller: _password,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Weak password',
                );
              } on EmailAlreadyInUesAuthException {
                await showErrorDialog(
                  context,
                  'Email is already in use',
                );
              } on InvalidEmailInAuthException {
                await showErrorDialog(
                  context,
                  'This is an invalid email address',
                );
              } on GenericAuthException {
                await showErrorDialog(context, "Failed to register");
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(LoginRoute, (route) => false);
            },
            child: const Text('Already regustered? Login here!'),
          )
        ],
      ),
    );
  }
}
