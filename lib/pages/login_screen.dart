import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lak_fitness/loginAndRegistration/Textfield/my_textfield.dart';
import 'package:lak_fitness/styles/button.dart';
import 'package:lak_fitness/styles/color.dart';

import '../services/dialog_service.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Benutzer Anmelden
  void signUserIn() async {
    // Ladezirkel anzeigen
    DialogService(context).progress();

    try {
      // Anmeldung mit Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pop(context);
      // Fehler werden abgefangen
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        await DialogService(context).error('Falsche E-Mail');
      } else if (e.code == 'wrong-password') {
        await DialogService(context).error('Falsches Passwort');
      } else {
        await DialogService(context).error('Falsches Passwort');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Titel
                Text(
                  'Anmeldung',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 20),
                // Email Textfeld Überschrift
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'E-Mail',
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
                // Email Textfeld
                MyTextField(
                  controller: emailController,
                  hintText: 'E-Mail eingeben',
                  obscureText: false,
                ),
                // Passwort Textfeld Überschrift
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
                //Passwort Textfeld
                MyTextField(
                  controller: passwordController,
                  hintText: 'Passwort eingeben',
                  obscureText: true,
                ),

                const SizedBox(height: 10),
                // Kein Konto -> weiterleitung Regristration
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Noch kein Konto? ',
                          style: Theme.of(context).textTheme.bodySmall),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Jetzt Registrieren!',
                          style: TextStyle(
                              color: purple,
                              fontSize: 12,
                              fontFamily: 'RedHatDisplay'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                // Anmelde Button
                ElevatedButton(
                    onPressed: signUserIn,
                    style: buttonPrimary,
                    child: Text(
                      'anmelden',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
              ],
            ),
          ),
        )));
  }
}
