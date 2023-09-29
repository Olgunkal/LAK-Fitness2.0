import 'package:flutter/material.dart';
import 'package:lak_fitness/pages/login_screen.dart';
import 'package:lak_fitness/pages/registration_screen.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPage();
}

class _LoginOrRegisterPage extends State<LoginOrRegisterPage> {
  // Anmeldebildschirm anzeigen auf 'true' gesetzt
  bool showLoginPage = true;

  // Wechsel zwischen Anmelde- und Registrierungsbildschirm seite
  void tooglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wenn 'true', zeige Anmeldebildschirm
    if (showLoginPage) {
      return LoginScreen(
        onTap: tooglePages,
      );
      // Sonst Registrierungsbildchirm anzeigen
    } else {
      return RegistrationScreen(
        onTap: tooglePages,
      );
    }
  }
}
