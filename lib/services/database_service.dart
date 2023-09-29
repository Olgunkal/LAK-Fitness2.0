import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/current_exercise_state.dart';
import '../models/exercise.dart';
import '../models/training.dart';
import '../models/training_plan.dart';
import '../models/user.dart';

class DatabaseService {
  // final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final userCollection = FirebaseFirestore.instance.collection('Nutzer');
  final exerciseCollection = FirebaseFirestore.instance.collection('Uebung');
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

  Future<List<TrainingPlan>> appendTrainingPlan(TrainingPlan entity) async {
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

    return plans;
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
    plans.first.exerciseStates
        .removeWhere((element) => element.exercise.name == exercise);

    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore: (snapshot, options) =>
                LakUser.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .update({'Plans': List<dynamic>.from(plans.map((x) => x.toJson()))});
  }

  Future<void> checkoutExercise(CurrentExerciseState exerciseState) async {
    var user = await getCurrentUser();

    var training = Training(
        date: DateTime.now(),
        exercise: exerciseState.exercise.name,
        weight: exerciseState.weight,
        repetion: exerciseState.repetions,
        sets: exerciseState.sets);

    user.trainings.add(training);

    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore: (snapshot, options) =>
                LakUser.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .update({
      'Trainings': List<dynamic>.from(user.trainings.map((x) => x.toJson()))
    });
  }

  Future<void> addExerciseToPlan(String plan, Exercise exercise) async {
    var user = await getCurrentUser();

    var exerciseState = CurrentExerciseState(
        exercise: exercise, weight: 0, sets: 0, repetions: 0);

    user.plans
        .firstWhere((element) => element.name == plan)
        .exerciseStates
        .add(exerciseState);

    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore: (snapshot, options) =>
                LakUser.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .update(
            {'Plans': List<dynamic>.from(user.plans.map((x) => x.toJson()))});
  }

  Future<void> updateExerciseState(
      String planName, CurrentExerciseState exerciseState) async {
    var user = await getCurrentUser();

    var plan = user.plans.firstWhere((element) => element.name == planName);
    var found = plan.exerciseStates.firstWhere(
        (element) => element.exercise.id == exerciseState.exercise.id);

    found.repetions = exerciseState.repetions;
    found.weight = exerciseState.weight;
    found.sets = exerciseState.sets;

    await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore: (snapshot, options) =>
                LakUser.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .update(
            {'Plans': List<dynamic>.from(user.plans.map((x) => x.toJson()))});
  }

  Future<Exercise> createExercise(
      String name, String description, String catalog) async {
    var entity = Exercise(
        id: const Uuid().v1(),
        name: name,
        description: description,
        catalog: catalog);

    await exerciseCollection
        .withConverter<Exercise>(
            fromFirestore: (snapshot, options) =>
                Exercise.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .add(entity);

    return entity;
  }

  Future<List<Training>> getTrainingsByName(String name) async {
    var user = await getCurrentUser();

    return user.trainings.toList();
  }

  Future<TrainingPlan> getTrainingPlan(String name) async {
    final user = await getCurrentUser();
    return user.plans.firstWhere((element) => element.name == name);
  }

  Future<List<Exercise>> getExercisesByCatalog(String catalog) async {
    var result = await exerciseCollection
        .withConverter<Exercise>(
            fromFirestore: (snapshot, options) =>
                Exercise.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .where('Übungskatalog', isEqualTo: catalog)
        .get();

    return result.docs.map((e) => e.data()).toList();
  }

  Future<List<CurrentExerciseState>> getExercisesByPlan(String id) async {
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

    return found.first.exerciseStates.toList();
  }

  Future<List<Exercise>> getExercises() async {
    var result = await exerciseCollection
        .withConverter<Exercise>(
            fromFirestore: (snapshot, options) =>
                Exercise.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .get();

    return result.docs.map((e) => e.data()).toList();
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

  Future<LakUser> getCurrentUser() async {
    var user = await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter<LakUser>(
            fromFirestore: (snapshot, options) =>
                LakUser.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson())
        .get();

    return user.data()!;
  }
}
