import 'package:flutter/material.dart';
import 'color.dart';

final ButtonStyle buttonPrimary = ElevatedButton.styleFrom(
  minimumSize: const Size(150, 35),
  backgroundColor: purple,
  elevation: 0,
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)
    ),
  )
);

final TextButtonThemeData buttonDatepicker = TextButtonThemeData(
  style: TextButton.styleFrom(
    minimumSize: const Size(150, 35),
    foregroundColor: white,
    backgroundColor: purple,
    elevation: 1,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
      ),
    )
  )
);