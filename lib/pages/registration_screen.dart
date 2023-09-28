import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../loginAndRegistration/Textfield/my_textfield.dart';
import '../loginAndRegistration/button/my_button.dart';

class RegistrationScreen extends StatefulWidget {
  final Function()? onTap;
  const RegistrationScreen({super.key, required this.onTap});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    // text editing Controller
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordCo1ntroller = TextEditingController();

    bool passwordConfirmed() {
      if (passwordController.text == confirmPasswordCo1ntroller.text) {
        return true;
      } else {
        return false;
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

    Future addUserDetails(String username, String email) async {
      await FirebaseFirestore.instance.collection('users').add({
        'Benutzername': username,
        'Email': email,
      });
    }

    //Registration User
    Future registrationUser() async {
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

      if (passwordController.text.length <= 5) {
        Navigator.pop(context);
        showErrorMessage("Passwort zu kurz!");
        return;
      } else if (!passwordConfirmed()) {
        Navigator.pop(context);
        showErrorMessage("Passwörter stimmen nicht überein!");
        return;
      } else if (passwordConfirmed()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        addUserDetails(usernameController.text, emailController.text);
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
                //Titel
                Text(
                  'Registrierung',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                  ),
                ),
                const SizedBox(height: 30),
                //Textfeld Benutzername
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
                MyTextField(
                  controller: usernameController,
                  hintText: 'Benutzername eingeben',
                  obscureText: false,
                ),

                //Textfeld Email
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

                //Textfeld Passwort
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
                MyTextField(
                  controller: passwordController,
                  hintText: 'Passwort eingeben',
                  obscureText: true,
                ),

                //Textfeld Passwort wiederholen

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
                MyTextField(
                  controller: confirmPasswordCo1ntroller,
                  hintText: 'Passwort erneut eingeben',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                //Kein Konto -> weiterleitung Regristration
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

                MyButton(
                  buttonText: 'registrieren',
                  onTap: registrationUser,
                ),
              ],
            ),
          ),
        )));
  }
}
