import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lak_fitness/loginAndRegistration/Textfield/my_textfield.dart';
import 'package:lak_fitness/loginAndRegistration/button/my_button.dart';

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
        backgroundColor: const Color.fromARGB(255, 43, 41, 41),
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Titel
                const Text(
                  'Anmeldung',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                  ),
                ),
                const SizedBox(height: 20),
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
                // Passwort Textfeld Überschrift
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
                      const Text('Noch kein Konto? ',
                          style: TextStyle(color: Colors.white)),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Jetzt Registrieren!',
                          style: TextStyle(color: (Colors.blue)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                // Anmelde Button
                MyButton(
                  buttonText: 'anmelden',
                  onTap: signUserIn,
                ),
              ],
            ),
          ),
        )));
  }
}
