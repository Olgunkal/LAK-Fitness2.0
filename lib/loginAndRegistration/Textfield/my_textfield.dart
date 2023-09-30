import 'package:flutter/material.dart';
import 'package:lak_fitness/styles/color.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: TextField(
          style: Theme.of(context).textTheme.bodyMedium,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: purple),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: white),
            ),
            hintText: hintText,
            suffixIcon: IconButton(
              splashRadius: 20,
              onPressed: controller.clear,
              icon: Icon(
                Icons.clear,
                color: white,
              ),
            ),
            hintStyle: TextStyle(color: grey),
          ),
        ));
  }
}
