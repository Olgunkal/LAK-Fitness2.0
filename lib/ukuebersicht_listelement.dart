import 'package:flutter/material.dart';
import 'package:lak_fitness/basis_theme.dart';
import 'package:lak_fitness/pages/uebungskatalog_uebungen.dart';

// Startseite Listenelement
class UkueListenelement extends StatelessWidget {
  //Konstruktor
  final String uebungskatalogName;
  const UkueListenelement(this.uebungskatalogName, {super.key});

  @override
  Widget build(BuildContext context) {
    //Funktion bei Auswahl eines Übungskatalogs
    void uebungsKatalogAuswahl() {
      Navigator.push<Widget>(
          context,
          MaterialPageRoute<Widget>(
              builder: (BuildContext context) => UebungskatalogUebungen(
                  uebungskatalogName: uebungskatalogName)));
    }

    return Container(
      //Layout
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
          color: black,
          border: Border(bottom: BorderSide(color: lila, width: 2.0))),

      // Listenelemente
      child: ListTile(
        title: Center(
          child: Text(
            uebungskatalogName,
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
        ),
        onTap: uebungsKatalogAuswahl,
      ),
    );
  }
}
