import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/training_plan.dart';
import '../models/user.dart';

class DatabaseService {
  // final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final userCollection = FirebaseFirestore.instance.collection('Nutzer');
  final trainingCollection = FirebaseFirestore.instance.collection('Uebung');
  final trainingCatalogCollection =
      FirebaseFirestore.instance.collection('Uebungskatalog');

  Future register(String email, String username, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    userCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'Benutzername': username,
      'Email': email,
      'Gewicht': 0,
      'Größe': 0,
      'Plans': []
    });
  }

  Future<void> createTrainingPlan(TrainingPlan entity) async {
    var user = await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter<LakUser>(
            fromFirestore: (snapshot, options) =>
                LakUser.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .get();

    var plans = user.data()!.plans;
    plans.add(entity);

    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore: (snapshot, options) =>
                TrainingPlan.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .update({'Plans': List<dynamic>.from(plans.map((x) => x.toJson()))});
  }

  Future<List<TrainingPlan>> getTrainingPlans() async {
    var user = await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter<LakUser>(
            fromFirestore: (snapshot, options) =>
                LakUser.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .get();

    return user.data()!.plans;
  }
}
