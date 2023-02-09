import 'dart:developer' as devtools show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterapp/Views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/Views/notes_view.dart';
import 'package:flutterapp/Views/register_view.dart';
import 'package:flutterapp/Views/verify_email_view.dart';
import 'package:flutterapp/constants/routes.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HommePage(),
      routes: {
        notesRoute: (context) => const NotesView(),
        LoginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HommePage extends StatelessWidget {
  const HommePage({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
