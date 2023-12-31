import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lak_fitness/styles/color.dart';

// Widget zur Passwortänderung
class ChangePassword extends StatefulWidget {
  final void Function(String txt) changePassword;
  const ChangePassword({required this.changePassword, super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmedController = TextEditingController();
  bool obsTxt = true;

  late String password;
  late String confirmedPassword;

  var auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmedController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    // TODO Check old password

    if (newPasswordController.text != confirmedController.text) {
      // TODO Error
      return;
    }

    // Passwortaktualisierung in Firebase
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: currentUser!.email!, password: oldPasswordController.text);

    try {
      await user!.reauthenticateWithCredential(cred);
      await user.updatePassword(newPasswordController.text);
    } finally {
      Navigator.pop(context);
    }
  }

  hideOffOn(bool obscureText) {
    if (obscureText == true) {
      obsTxt = false;
    } else {
      obsTxt = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ausgabe als AlertDialog
    return AlertDialog(
      backgroundColor: background,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      content: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: oldPasswordController,
                style: Theme.of(context).textTheme.bodyMedium,
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: purple),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: white),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  hintText: 'altes Passwort eingeben',
                  labelText: 'altes Passwort*',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(Icons.remove_red_eye),
                ),
                onChanged: (String txt) => password = txt,

                // Fehlermeldung bei ungültiger Eingabe
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Passwort ungültig';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 25.0),
              TextFormField(
                controller: newPasswordController,
                style: Theme.of(context).textTheme.bodyMedium,
                obscureText: obsTxt,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: purple),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: white),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  hintText: 'neues Passwort eingeben',
                  labelText: 'neues Passwort*',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: IconButton(
                    onPressed: hideOffOn(obsTxt),
                    icon: const Icon(Icons.remove_red_eye),
                  ),
                  helperText: 'min. 6 Zeichen ',
                  helperMaxLines: 2,
                ),
                onChanged: (String txt) => password = txt,

                // Fehlermeldung bei ungültiger Eingabe
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Passwort ungültig';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 19.0),
              TextFormField(
                controller: confirmedController,
                style: Theme.of(context).textTheme.bodyMedium,
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: purple),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: white),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  hintText: 'Passwort erneut eingeben',
                  labelText: 'Neues Passwort bestätigen',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(Icons.remove_red_eye),
                ),
                onChanged: (String txt) => confirmedPassword = txt,

                // Fehlermeldung wenn Passwörter nicht übereinstimmen
                validator: (value) {
                  if (value!.isEmpty || value != newPasswordController.text) {
                    return 'Passwort stimmt nicht über ein';
                  } else {
                    return null;
                  }
                },
              ),

              //Bestätigen-Button
              const SizedBox(height: 16.0),
              IconButton(
                onPressed: save,
                icon: Icon(
                  Icons.check,
                  color: purple,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
