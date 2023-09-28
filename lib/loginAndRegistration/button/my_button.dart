import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonText;
  final Function()? onTap;
  const MyButton({super.key, required this.onTap, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 90),
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(buttonText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              )),
        ),
      ),
    );
  }
}
