import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lak_fitness/loginAndRegistration/Textfield/my_textfield.dart';
import 'package:lak_fitness/loginAndRegistration/button/my_button.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //sign  user
  void signUserIn() async {
    //show loading cirle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // loading circle pop
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // loading circle pop
      Navigator.pop(context);
      // wrong email
      if (e.code == 'user-not-found') {
        // show error
        showErrorMessage('Falsche E-Mail');
      }
      // wrong password
      else if (e.code == 'wrong-password') {
        showErrorMessage('Falsches Passwort');
      }
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.purple,
          title: Center(
              child: Text(
            message,
            style: TextStyle(color: Colors.white),
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 43, 41, 41),
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Titel
                const Text(
                  'Anmeldung',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                  ),
                ),
                const SizedBox(height: 20),
                //Email Textfeld
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
                MyTextField(
                  controller: emailController,
                  hintText: 'E-Mail eingeben',
                  obscureText: false,
                ),

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
                //Kein Konto -> weiterleitung Regristration
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Noch kein Konto? ',
                          style: TextStyle(color: Colors.white)),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Jetzt Registrieren!',
                          style: TextStyle(color: (Colors.blue)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                //anmelde Button
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
