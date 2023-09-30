import 'package:flutter/material.dart';
import 'package:lak_fitness/styles/color.dart';

ThemeData basisTheme = ThemeData(
    brightness: Brightness.dark,
    dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderSide: BorderSide(color: white)))),
    textTheme: TextTheme(
      labelLarge:
          TextStyle(fontSize: 45, fontFamily: 'Audiowide', color: white),
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
      bodySmall:
          TextStyle(fontSize: 12, fontFamily: 'RedHatDisplay', color: white),
    ));
