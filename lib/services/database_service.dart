import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../models/exercise.dart';
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
      'Geburtsdatum': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'Gewicht': 0,
      'Größe': 0,
      'Plans': []
    });
  }

  Future<LakUser> getCurrentUser() async {
    var document = await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter<LakUser>(
            fromFirestore: (snapshot, options) =>
                LakUser.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .get();

    return document.data()!;
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

  Future updateBirthday(DateTime date) async {
    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore: (snapshot, options) =>
                TrainingPlan.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .update({'Geburtsdatum': DateFormat('yyyy-MM-dd').format(date)});
  }

  Future updateUserData(
      {DateTime? birthday, int? weight, int? height, String? email}) async {
    Map<Object, Object> update = {};

    if (birthday != null) {
      update['Geburtsdatum'] = DateFormat('yyyy-MM-dd').format(birthday);
    }

    if (weight != null) {
      update['Gewicht'] = weight;
    }

    if (height != null) {
      update['Größe'] = height;
    }

    if (email != null) {
      update['Email'] = email;
    }

    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore: (snapshot, options) =>
                TrainingPlan.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .update(update);
  }

  Future<void> removeExercise(String id, String exercise) async {
    var user = await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter<LakUser>(
            fromFirestore: (snapshot, options) =>
                LakUser.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .get();

    var data = user.data()!;
    var plans = data.plans.where((element) => element.name == id);
    plans.first.exercises.removeWhere((element) => element.name == exercise);

    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore: (snapshot, options) =>
                LakUser.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .update({'Plans': List<dynamic>.from(plans.map((x) => x.toJson()))});
  }

  Future<void> addExercise(String id, Exercise exercise) async {
    var user = await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter<LakUser>(
            fromFirestore: (snapshot, options) =>
                LakUser.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .get();

    var data = user.data()!;
    var plans = data.plans.where((element) => element.name == id);
    plans.first.exercises.add(exercise);

    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore: (snapshot, options) =>
                LakUser.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .update({'Plans': List<dynamic>.from(plans.map((x) => x.toJson()))});
  }

  Future<void> createExercise(Exercise exercise) async {}

  Future<List<Exercise>> getExercises(String id) async {
    var user = await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter<LakUser>(
            fromFirestore: (snapshot, options) =>
                LakUser.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .get();

    var plans = user.data()!.plans;
    var found = plans.where((element) => element.name == id);

    log(id);

    return found.first.exercises;
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
