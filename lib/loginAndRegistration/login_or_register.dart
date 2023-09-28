import 'package:flutter/material.dart';
import 'package:lak_fitness/pages/login_screen.dart';
import 'package:lak_fitness/pages/registration_screen.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPage();
}

class _LoginOrRegisterPage extends State<LoginOrRegisterPage> {
  // login seite anzeigen
  bool showLoginPage = true;

  //wechsel zwischen login und register seite
  void tooglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(
        onTap: tooglePages,
      );
    } else {
      return RegistrationScreen(
        onTap: tooglePages,
      );
    }
  }
}
