import 'package:flutter/material.dart';

import 'package:lak_fitness/pages/analyse.dart';
import 'package:lak_fitness/pages/startseite.dart';
import 'package:lak_fitness/pages/profil.dart';

import 'package:lak_fitness/styles/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Index für Navigationsbar
  int currentIndex = 1;
  // Die 3 Bildschirme der App
  final List<Widget> _pages = [
    const Analysebildschirm(),
    const Startseite(),
    const Profil(),
  ];

  // Ändert ensprechend des Indexes auf die Bildschirme von der Liste
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: navigationbar(),
    );
  }

  // Navigationsbar
  Widget navigationbar() => BottomNavigationBar(
        backgroundColor: background,
        iconSize: 30.0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: purple,
        unselectedItemColor: white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        //Icons der Navigationsbar (Analyse, Home, Profil)
        items: const [
          BottomNavigationBarItem(
            label: 'Analyse',
            icon: Icon(Icons.bar_chart_rounded),
            tooltip: 'Profil',
          ),
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
            tooltip: 'Profil',
          ),
          BottomNavigationBarItem(
            label: 'Profil',
            icon: Icon(Icons.account_circle_rounded),
            tooltip: 'Profil',
          ),
        ],
        // Änderung des Indexes nachdem man auf Icon gedrückt hat
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      );
}
