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
import '../models/user.dart';
import '../services/database_service.dart';
import '../services/dialog_service.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  // Default Werte des Users
  LakUser user = LakUser(
      email: "",
      username: "",
      birthday: DateTime.now(),
      weight: 0,
      height: 0,
      plans: [],
      trainings: []);

  void changePassword(String password) {
    Navigator.of(context).pop();
  }

  // Neues Passwort anlegen
  void newPassword() {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return ChangePassword(changePassword: changePassword);
      },
    );
  }

  Uint8List? image;
  // Profilbild aktualisieren
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  // Bearbeitung der Nutzereigenschaften
  Future<T> editField<T>(String id, String field, var defaultValue) async {
    String newValue = "";

    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: background,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        title: Text(
          '$field änderen',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        content: TextField(
          autofocus: true,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: "Hier eingeben",
            hintStyle: TextStyle(color: grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // Abbrechen Button
          TextButton(
            onPressed: () => Navigator.of(context).pop(defaultValue),
            child: Text(
              'Abbrechen',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          // Speichern Button
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
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  // Abmelden
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
          // Abmelde Button
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
              // Abfrage ob Benutzer Daten vorhanden sind
              if (snapshot.hasData) {
                user = LakUser.fromJson(
                    snapshot.data!.data() as Map<String, dynamic>);

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
                    // Name des aktuellen Benutzers
                    child: Text(
                      user.username,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),

                  // Geburtstag des aktuellen Benutzers
                  MyTextBox(
                    sectionName: 'Geburtstag:',
                    text:
                        '${user.birthday.day.toString()}.${user.birthday.month.toString()}.${user.birthday.year.toString()}',
                    unit: '',
                    // Änderung des Geburtsdatums
                    onPressed: () => {
                      DialogService(context)
                          .date(user.birthday)
                          .then((value) async => {
                                setState(() =>
                                    user.birthday = value ?? DateTime.now()),
                                await DatabaseService()
                                    .updateUserData(birthday: user.birthday)
                              }),
                    },
                  ),

                  // Gewicht des akutellen Benutzers
                  MyTextBox(
                      sectionName: 'Gewicht:',
                      text: user.weight.toString(),
                      unit: 'kg',
                      // Änderung des Gewichts
                      onPressed: () => editField<int>(
                              currentuser.uid, 'Gewicht', user.weight)
                          .then((value) async => {
                                setState(() => user.weight = value),
                                await DatabaseService()
                                    .updateUserData(weight: user.weight)
                              })),

                  // Körpergröße des aktuellen Benutzers
                  MyTextBox(
                    sectionName: 'Größe:',
                    text: user.height.toString(),
                    unit: 'cm',
                    // Änderung der Körpergröße
                    onPressed: () =>
                        editField<int>(currentuser.uid, 'Größe', user.height)
                            .then((value) async => {
                                  setState(() => user.height = value),
                                  await DatabaseService()
                                      .updateUserData(height: user.height)
                                }),
                  ),

                  // Email des aktuellen Benutzers
                  MyTextBox(
                    sectionName: 'Email:',
                    text: user.email,
                    unit: '',
                    // Änderung des Emails
                    onPressed: () =>
                        editField<String>(currentuser.uid, 'Email', user.email)
                            .then((value) async => {
                                  setState(() => user.email = value),
                                  await DatabaseService()
                                      .updateUserData(email: user.email)
                                }),
                  ),

                  // Passwort ändern
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 32, right: 20),
                    child: ElevatedButton(
                        // Änderung des Passwortes
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
