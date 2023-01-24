import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterapp/Views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Views/register_view.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HommePage(),
    ),
  );
}

class HommePage extends StatelessWidget {
  const HommePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              print(user);
              if (user?.emailVerified ?? false) {
              } else {
                return const VerifyEmailView();
              }
              return const Text("Done");
            default:
              return const Text('Loading.....');
          }
        },
      ),
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Please   verify  your  email  address: "),
        TextButton(
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              user?.sendEmailVerification();
            },
            child: const Text("Send email verification"))
      ],
    );
  }
}
