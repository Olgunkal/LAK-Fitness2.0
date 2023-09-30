import 'package:flutter/material.dart';

import '../styles/button.dart';
import '../styles/color.dart';

class DialogService {
  final BuildContext context;

  DialogService(this.context);

  // Dialog mit Ladekreis
  Future progress() async {
    await showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(white),
          ),
        );
      },
    );
  }

  Future error(String message) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: purple,
          title: Center(
              child: Text(
            message,
            style: TextStyle(color: white),
          )),
        );
      },
    );
  }

  Future<DateTime?> date(DateTime initial) async {
    return await showDatePicker(
      context: context,
      helpText: 'wähle Geburtsdatum aus',
      cancelText: 'Abbrechen',
      confirmText: 'Speichern',
      fieldLabelText: 'Geburtsdatum',
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2500),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme(
              brightness: Brightness.dark,
              surface: purple,
              background: background,
              error: Colors.red[400]!,
              primary: white,
              secondary: purple,
              onSurface: white,
              onBackground: purple,
              onError: white,
              onPrimary: purple,
              onSecondary: white,
            ),
            textTheme: TextTheme(
              bodySmall: TextStyle(
                fontFamily: 'Red Hat Displays',
                fontSize: 14,
                color: white,
              ),
              labelSmall: TextStyle(
                fontFamily: 'Red Hat Displays',
                fontSize: 14,
                color: white,
              ),
              labelLarge: TextStyle(
                fontFamily: 'Red Hat Displays',
                fontSize: 16,
                color: white,
              ),
            ),
            textButtonTheme: buttonDatepicker,
          ),
          child: child!,
        );
      },
    );
  }
}
