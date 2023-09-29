import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../loginAndRegistration/Textfield/my_textfield.dart';
import '../loginAndRegistration/button/my_button.dart';

import '../services/database_service.dart';
import '../services/dialog_service.dart';

class RegistrationScreen extends StatefulWidget {
  final Function()? onTap;
  const RegistrationScreen({super.key, required this.onTap});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    // Variablen zum Speichern der Eingabe
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    // Benutzer Registrieren
    Future registerUser() async {
      // Ladezirkel anzeigen
      DialogService(context).progress();
      // Fehler werden abgefangen
      if (passwordController.text.length <= 5) {
        Navigator.pop(context);
        DialogService(context).error("Passwort zu kurz!");
        return;
      } else if (passwordController.text != confirmPasswordController.text) {
        Navigator.pop(context);
        DialogService(context).error("Passwörter stimmen nicht überein!");
        return;
      }
      // Registrierung mit Firebase
      try {
        await DatabaseService().register(emailController.text,
            usernameController.text, passwordController.text);
      } finally {
        Navigator.pop(context);
      }
    }

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 43, 41, 41),
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Titel
                Text(
                  'Registrierung',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                  ),
                ),
                const SizedBox(height: 30),
                // Benutzername Textfeld Überschrift
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Benutzername',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
                // Benutzername Textfeld
                MyTextField(
                  controller: usernameController,
                  hintText: 'Benutzername eingeben',
                  obscureText: false,
                ),

                // Email Textfeld Überschrift
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('E-Mail',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
                // Email Textfeld
                MyTextField(
                  controller: emailController,
                  hintText: 'E-Mail eingeben',
                  obscureText: false,
                ),

                // Passwort Textfeld
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Passwort',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
                // Passwort Textfeld
                MyTextField(
                  controller: passwordController,
                  hintText: 'Passwort eingeben',
                  obscureText: true,
                ),
                // Passwort Textfeld erneut eingeben Titel
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Passwort bestätigen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
                // Passwort Textfeld erneut eingeben
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Passwort erneut eingeben',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                // Kein Konto -> weiterleitung Regristration Text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Schon Registriert? ',
                          style: TextStyle(color: Colors.white)),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Jetzt Anmelden!',
                          style: TextStyle(color: (Colors.blue)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Kein Konto -> weiterleitung Regristration Button
                MyButton(
                  buttonText: 'registrieren',
                  onTap: registerUser,
                ),
              ],
            ),
          ),
        )));
  }
}
