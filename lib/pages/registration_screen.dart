import 'package:flutter/material.dart';
import 'package:lak_fitness/styles/button.dart';
import 'package:lak_fitness/styles/color.dart';
import '../loginAndRegistration/Textfield/my_textfield.dart';
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
        backgroundColor: background,
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Titel
                Text(
                  'Registrierung',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 30),
                // Benutzername Textfeld Überschrift
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Benutzername',
                          style: Theme.of(context).textTheme.bodyLarge),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('E-Mail',
                          style: Theme.of(context).textTheme.bodyLarge),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Passwort',
                          style: Theme.of(context).textTheme.bodyLarge),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Passwort bestätigen',
                          style: Theme.of(context).textTheme.bodyLarge),
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
                // Kein Konto -> weiterleitung Registrierungstext
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Schon Registriert? ',
                          style: Theme.of(context).textTheme.bodySmall),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Jetzt Anmelden!',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'RedHatDisplay',
                              color: purple),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Kein Konto -> weiterleitung Regristration Button
                ElevatedButton(
                    onPressed: registerUser,
                    style: buttonPrimary,
                    child: Text(
                      'registrieren',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
              ],
            ),
          ),
        )));
  }
}
