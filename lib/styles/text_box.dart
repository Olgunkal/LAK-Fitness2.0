import 'package:flutter/material.dart';
import 'color.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final String unit;
  final void Function()? onPressed;
  const MyTextBox({super.key, required this.sectionName, required this.text, required this.unit, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: white,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      padding: const EdgeInsets.only(left: 15, bottom:15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          // Kopfzeile mit Bereichsüberschrift und Bearbeitungsbutton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bereich
              Text(
                sectionName,
                style: TextStyle(
                  color: grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Red Hat Displays',
                ),
              ),

              // Bearbeitungs Iconbutton
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.edit,
                  color: white,
                ),
              )
            ]
          ),

          // Kontext: Text mit Einheit
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text
                Text(
                  text,
                  style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Red Hat Displays',
                      ),  
                ),
          
                // Einheit
                Text(
                  unit,
                  style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Red Hat Displays',
                      ),  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}