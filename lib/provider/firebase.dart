import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elred_assignment/widget/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'handle_response.dart';


class FirebaseProvider extends ChangeNotifier {
  // provider to handle firebase operations
  late FirebaseResponse responseAddingTask;
  late FirebaseResponse responseUpdatingTask;
  late FirebaseResponse responseDeletingTask;

  initializingState() {
    responseAddingTask = FirebaseResponse.initial('Add Task');
    responseUpdatingTask = FirebaseResponse.initial('Update Task');
    responseDeletingTask = FirebaseResponse.initial('Delete Task');
  }

  FirebaseResponse get getResponseAddingTask => responseAddingTask;

  FirebaseResponse get getResponseUpdatingTask => responseUpdatingTask;

  FirebaseResponse get getResponseDeletingTask => responseDeletingTask;

  static final collection = FirebaseFirestore.instance.collection('task');
  int totalTasks = 0;


  int get getTotalTasks => totalTasks;

  delayForSeconds(int second) async {
    await Future.delayed(Duration(seconds: second));
  }

  addTask(BuildContext context, userId, var data) async {
    responseAddingTask = FirebaseResponse.loading('adding task...');
    notifyListeners();
    await delayForSeconds(2);
    try {
      await collection.doc(userId).collection(userId).doc().set(data);
      responseAddingTask = FirebaseResponse.completed('task added successfully!');
      Util.snackBar(
          context: context,
          data: responseAddingTask.message!,
          color: Colors.green);
      notifyListeners();
    } on FirebaseException catch (e) {
      responseAddingTask = FirebaseResponse.error('error on adding task');
      Util.snackBar(
          context: context,
          data: e.code,
          color: Colors.red);
      notifyListeners();
      print('Failed with error code: ${e.code}');
    }
  }

  updateTask(BuildContext context, userId, var data, docId) async {
    responseUpdatingTask = FirebaseResponse.loading('updating task...');
    notifyListeners();
    await delayForSeconds(2);
    try {
      await collection.doc(userId).collection(userId).doc(docId).update(data);
      responseUpdatingTask = FirebaseResponse.completed('task updated successfully!');
      Util.snackBar(
          context: context,
          data: responseUpdatingTask.message!,
          color: Colors.green);
      notifyListeners();
    } on FirebaseException catch (e) {
      responseUpdatingTask = FirebaseResponse.error('error on updating task');
      Util.snackBar(
          context: context,
          data: e.code,
          color: Colors.red);
      notifyListeners();
    }
  }

  deleteTask(BuildContext context,docId) async {
    print('deleteTask:: $docId');
    final user = FirebaseAuth.instance.currentUser;
    responseDeletingTask = FirebaseResponse.loading('deleting task...');
    Util.snackBar(
        context: context,
        data: responseDeletingTask.message!,
        color: Colors.green);
    notifyListeners();
    await delayForSeconds(2);
    try {
      await collection.doc(user!.uid).collection(user.uid).doc(docId).delete();
      responseDeletingTask =
          FirebaseResponse.completed('task deleted successfully!');
      Util.snackBar(
          context: context,
          data: responseDeletingTask.message!,
          color: Colors.green);
      notifyListeners();
    } on FirebaseException catch (e) {
      responseDeletingTask = FirebaseResponse.error('error on deleting task');
      Util.snackBar(
          context: context,
          data: e.code,
          color: Colors.red);
      notifyListeners();
    }
  }

  getTaskFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    collection.doc(user!.uid).collection(user.uid).get().then((myDocuments) {
      totalTasks = myDocuments.docs.length;
      notifyListeners();
    });
  }
}

