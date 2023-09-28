import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  // final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final userCollection = FirebaseFirestore.instance.collection('Nutzer');
  final trainingCollection = FirebaseFirestore.instance.collection('Uebung');
  final trainingCatalogCollection =
      FirebaseFirestore.instance.collection('Uebungskatalog');

  Future register(String email, String username, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    DatabaseService()
        .userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'Benutzername': username,
      'Email': email,
      'Gewicht': 0,
      'Größe': 0
    });
  }
}
