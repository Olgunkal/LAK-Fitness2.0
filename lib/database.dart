import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final currentuser = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference nutzer =
      FirebaseFirestore.instance.collection('Nutzer');
  final CollectionReference uebung =
      FirebaseFirestore.instance.collection('Uebung');
  final CollectionReference uebungskatalog =
      FirebaseFirestore.instance.collection('Uebungskatalog');

  Future setBenutzer(
    String benutzername,
    String email,
  ) async {
    await nutzer.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'Benutzername': benutzername,
      'Email': email,
      'Gewicht': 80,
      'Größe': 180,
    });
  }

  Stream getGroesse() {
    return nutzer.doc(currentuser).snapshots();
  }
  //Future updateGroesse(double groesse) async{
  //  await
  //}
}
//body: StreamBuilder<DocumentSnapshot>(
//    stream: Database().nutzer.doc(currentuser.uid).snapshots(),
//  builder: (context, snapshot) {
//   if (snapshot.hasData) {
//    final userData = snapshot.data!.data() as Map<String, dynamic>;

Future<void> connectToFirebase() async {
  Database database = Database();
  Stream stGetGroesse = database.getGroesse();
}
