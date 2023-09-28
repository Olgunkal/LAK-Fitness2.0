import 'package:flutter/material.dart';
import 'package:lak_fitness/styles/color.dart';

//Farbpalette
const black = Colors.black;
const lila = Colors.deepPurpleAccent;
const grey = Colors.grey;

//Layout Data
const breiteContainer = 300.0;

ThemeData basisTheme = ThemeData(
    brightness: Brightness.dark,
    dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderSide: BorderSide(color: white)))),
    textTheme: TextTheme(
      titleLarge:
          TextStyle(fontSize: 24, fontFamily: 'Audiowide', color: white),
      titleMedium:
          TextStyle(fontSize: 16, fontFamily: 'Audiowide', color: white),
      titleSmall: TextStyle(
          fontSize: 16,
          fontFamily: 'RedHatDisplay',
          fontWeight: FontWeight.bold,
          color: white),
      bodyLarge:
          TextStyle(fontSize: 16, fontFamily: 'RedHatDisplay', color: white),
      bodyMedium:
          TextStyle(fontSize: 14, fontFamily: 'RedHatDisplay', color: white),
    ));

ThemeData basisThemeF() {
  //Farbpalette
  const black = Colors.black;
  const white = Colors.white;
  const lila = Colors.deepPurpleAccent;

  final basTheme = ThemeData.dark();
  final theme1 = basTheme.copyWith(
    primaryColor: Colors.green,
    colorScheme: const ColorScheme.dark(
      primary: black,
      secondary: lila,
    ),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: white,
        ),
        headlineMedium:
            TextStyle(color: white, fontSize: 30, fontWeight: FontWeight.bold)),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(lila),
        iconColor: MaterialStatePropertyAll<Color>(lila),
      ),
    ),
  );

  return ThemeData(primaryColor: Colors.green);
}
