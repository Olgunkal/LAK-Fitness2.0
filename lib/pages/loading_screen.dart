import 'package:flutter/material.dart';
import 'package:lak_fitness/loginAndRegistration/auth_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const AuthPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 43, 41, 41),
      body: Container(
        child: Center(
          child: Text('LAK-Fitness',
              style: TextStyle(
                color: Colors.purple,
                fontSize: 54,
              )),
        ),
      ),
    );
  }
}
