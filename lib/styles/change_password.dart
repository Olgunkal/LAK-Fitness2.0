import 'package:flutter/material.dart';
import 'package:lak_fitness/styles/color.dart';

class ChangePassword extends StatefulWidget {
  final void Function(String txt) changePassword;
  const ChangePassword({required this.changePassword, super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final passwordController = TextEditingController();
  final confirmedController = TextEditingController();
  late String password;
  late String confirmedPassword;

  @override
  void dispose() {
    passwordController.dispose();
    confirmedController.dispose();
    super.dispose();
  }

  void save() {
    if (formKey.currentState!.validate()) {
      widget.changePassword(password);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                controller: passwordController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  hintText: 'neues Passwort eingeben',
                  labelText: 'neues Passwort*',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(Icons.remove_red_eye),
                  helperText:
                      'min. 8 Zeichen (Groß- und Kleinbuchstaben, min. eine Zahl)',
                  helperMaxLines: 2,
                ),
                onChanged: (String txt) => password = txt,
                onFieldSubmitted: (String txt) => save(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Passwort ungültig';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 32.0),
              TextFormField(
                controller: confirmedController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  hintText: 'Passwort erneut eingeben',
                  labelText: 'Neues Passwort bestätigen',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(Icons.remove_red_eye),
                ),
                onChanged: (String txt) => confirmedPassword = txt,
                onFieldSubmitted: (String txt) => save(),
                validator: (value) {
                  if (value!.isEmpty || value != passwordController.text) {
                    return 'Passwort stimmt nicht über ein';
                  } else {
                    return null;
                  }
                },
              ),
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
