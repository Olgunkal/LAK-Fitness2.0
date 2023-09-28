import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lak_fitness/styles/button.dart';
import 'package:lak_fitness/styles/color.dart';
import 'package:lak_fitness/styles/text_box.dart';
import 'package:lak_fitness/styles/utils.dart';
import 'package:lak_fitness/styles/change_password.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  // Variablen Dekleartion
  var geb = DateTime.now();
  var startZeitraum = DateTime(2021);
  var endeZeitraum = DateTime(2500);

  // user
  //final currentUser = FirebaseAuth.instance.currentUser!;

  void changePassword(String password) {
    Navigator.of(context).pop();
  }

  void newPassword() {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return ChangePassword(changePassword: changePassword);
      },
    );
  }

  Uint8List? image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  //final usersCollection = FirebaseFirestore.instance.collection('Users');

  // Bearbeitung der Nutzereigenschaften
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: background,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        title: Text(
          '$field änderen',
          style: const TextStyle(fontSize: 14, fontFamily: 'Red Hat Displays'),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(
            color: white,
            fontSize: 14,
            fontFamily: 'Red Hat Displays',
          ),
          decoration: InputDecoration(
            hintText: "Hier eingeben",
            hintStyle: TextStyle(color: grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Abbrechen',
              style: TextStyle(
                  color: white, fontSize: 14, fontFamily: 'Red Hat Displays'),
            ),
          ),

          // save button
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text(
              'Speichern',
              style: TextStyle(
                  color: white, fontSize: 14, fontFamily: 'Red Hat Displays'),
            ),
          ),
        ],
      ),
    );

    // update firestore
    //if (newValue.trim().length > 0) {
    // await usersCollection.doc(currentUser.email).update({field: newValue});
    //}
  }

  Future<void> editGeb() async {
    await showDatePicker(
      context: context,
      helpText: 'wähle Geburtsdatum aus',
      cancelText: 'Abbrechen',
      confirmText: 'Speichern',
      fieldLabelText: 'Geburtsdatum',
      initialDate: geb,
      firstDate: startZeitraum,
      lastDate: endeZeitraum,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme(
              brightness: Brightness.dark,
              surface: purple,
              background: background,
              error: Colors.red[400]!,
              primary: white,
              secondary: purple,
              onSurface: white,
              onBackground: purple,
              onError: white,
              onPrimary: purple,
              onSecondary: white,
            ),
            textTheme: TextTheme(
              bodySmall: TextStyle(
                fontFamily: 'Red Hat Displays',
                fontSize: 14,
                color: white,
              ),
              labelSmall: TextStyle(
                fontFamily: 'Red Hat Displays',
                fontSize: 14,
                color: white,
              ),
              labelLarge: TextStyle(
                fontFamily: 'Red Hat Displays',
                fontSize: 16,
                color: white,
              ),
            ),
            textButtonTheme: buttonDatepicker,
          ),
          child: child!,
        );
      },
    ).then(
      (value) {
        if (value != null) {
          // Datenbankeinbindung write und update

          setState(() {
            geb = value;
          });
        }
      },
    );
  }

  // sign out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(
          'Profil',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: background,
        shadowColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: signUserOut, icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: ListView(children: [
        // Profilbild
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: purple,
              width: 2,
            ),
          ),
          child: Stack(children: [
            image != null
                ? CircleAvatar(
                    radius: 50,
                    child: ClipOval(
                      child: Image.memory(image!,
                          width: 150, height: 150, fit: BoxFit.cover),
                    ),
                  )
                : const Icon(
                    Icons.account_circle,
                    size: 100.0,
                  ),
            Positioned(
              bottom: -15,
              left: 65,
              child: IconButton(
                onPressed: selectImage,
                icon: const Icon(Icons.add_a_photo),
                color: white,
              ),
            )
          ]),
        ),

        // Benutzername
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            textAlign: TextAlign.center,
            'Max Mustermann', // Name muss aus der Datenbank geholt werden
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),

        // Benutzer Geburtstag
        MyTextBox(
          sectionName: 'Geburtstag:',
          text:
              '${geb.day.toString()}.${geb.month.toString()}.${geb.year.toString()}',
          unit: '',
          onPressed: () => editGeb(),
        ),

        // Benutzer Gewicht
        MyTextBox(
          sectionName: 'Gewicht:',
          text: '80',
          unit: 'kg',
          onPressed: () => editField('Gewicht'),
        ),

        // Benutzer Körpergröße
        MyTextBox(
          sectionName: 'Größe:',
          text: '180',
          unit: 'cm',
          onPressed: () => editField('Größe'),
        ),

        // Benutzer Email
        MyTextBox(
          sectionName: 'Email:',
          text: 'currentUser.Email!',
          unit: '',
          onPressed: () => editField('Email'),
        ),

        // Passwort ändern
        Container(
          margin: const EdgeInsets.only(left: 20, top: 32, right: 20),
          child: ElevatedButton(
              onPressed: newPassword,
              style: buttonPrimary,
              child: Text(
                'Passwort ändern',
                style: Theme.of(context).textTheme.bodyLarge,
              )),
        ),
      ]),
    );
  }
}
