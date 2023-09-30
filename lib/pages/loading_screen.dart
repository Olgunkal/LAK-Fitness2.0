import 'package:flutter/material.dart';
import 'package:lak_fitness/loginAndRegistration/auth_page.dart';
import 'package:lak_fitness/styles/color.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

// Ladebildschirm lädt 2 sekunden und leitet weiter an AuthPage
class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const AuthPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LAK-Fitness',
                  style: TextStyle(
                    color: purple,
                    fontSize: 45,
                    fontFamily: 'Audiowide',
                  )),
              const SizedBox(
                height: 32,
              ),
              Icon(
                Icons.fitness_center_outlined,
                size: 80,
                color: purple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
