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

import '../services/database_service.dart';
import '../services/dialog_service.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  // Variablen Dekleartion
  var gewicht = 0;
  var geb = DateTime.now();
  var groesse = 0;
  var email = "";

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
  Future<T> editField<T>(String id, String field) async {
    String newValue = "";

    return await showDialog(
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
            onPressed: () => Navigator.of(context).pop(T == String ? "" : 0),
            child: Text(
              'Abbrechen',
              style: TextStyle(
                  color: white, fontSize: 14, fontFamily: 'Red Hat Displays'),
            ),
          ),

          // save button
          TextButton(
            onPressed: () async => {
              await FirebaseFirestore.instance
                  .collection('Nutzer')
                  .doc(id)
                  .update({
                field: (T == String
                    ? newValue
                    : (newValue.isEmpty ? 0 : int.parse(newValue)))
              }),
              Navigator.of(context).pop(T == String
                  ? newValue
                  : (newValue.isEmpty ? 0 : int.parse(newValue)))
            },
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

  // sign out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final currentuser = FirebaseAuth.instance.currentUser!;
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
      body: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return StreamBuilder<DocumentSnapshot>(
            stream: DatabaseService()
                .userCollection
                .doc(currentuser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;

                groesse = userData['Größe'];
                gewicht = userData['Gewicht'];
                email = userData['Email'];

                return ListView(children: [
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
                      userData['Benutzername'],
                      textAlign: TextAlign
                          .center, // Name muss aus der Datenbank geholt werden
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),

                  // Benutzer Geburtstag
                  MyTextBox(
                    sectionName: 'Geburtstag:',
                    text:
                        '${geb.day.toString()}.${geb.month.toString()}.${geb.year.toString()}',
                    unit: '',
                    onPressed: () => DialogService(context)
                        .date(geb)
                        .then((value) => setState(() => geb = value)),
                  ),

                  // Benutzer Gewicht
                  MyTextBox(
                      sectionName: 'Gewicht:',
                      text: gewicht.toString(),
                      unit: 'kg',
                      onPressed: () => editField<int>(
                              currentuser.uid, 'Gewicht')
                          .then((value) => setState(() => gewicht = value))),

                  // Benutzer Körpergröße
                  MyTextBox(
                    sectionName: 'Größe:',
                    text: groesse.toString(),
                    unit: 'cm',
                    onPressed: () => editField<int>(currentuser.uid, 'Größe')
                        .then((value) => setState(() => groesse = value)),
                  ),

                  // Benutzer Email
                  MyTextBox(
                    sectionName: 'Email:',
                    text: email,
                    unit: '',
                    onPressed: () => editField<String>(currentuser.uid, 'Email')
                        .then((value) => setState(() => email = value)),
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
                ]);
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error${snapshot.error}'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
      }),
    );
  }
}
