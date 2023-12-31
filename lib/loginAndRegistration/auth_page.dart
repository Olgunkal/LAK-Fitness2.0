import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lak_fitness/homepage.dart';
import 'package:lak_fitness/loginAndRegistration/login_or_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // Benutzer ist eingeloggt => leitet weiter zur Homepage
              if (snapshot.hasData) {
                return const HomePage();
              }
              // Bentzer ist nicht eingeloggt => leitet weiter zu LoginOrRegisterPage
              else {
                return const LoginOrRegisterPage();
              }
            }));
  }
}
