import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {

  // provider to handle firebase operations
  static final collection = FirebaseFirestore.instance.collection('task');
  int totalTasks = 0;

  void setTotalTasks(int index) {
    totalTasks = index;
    notifyListeners();
    print('getTaskFromFirebase${totalTasks}');
  }

  int get getTotalTasks => totalTasks;

  addTask(BuildContext context, userId,var data) async {
    await collection.doc(userId).collection(userId).doc().set(data);
    totalTasks = await collection.snapshots().length;
    notifyListeners();
  }

  updateTask(BuildContext context,userId,var data, docId) async {
    await collection.doc(userId).collection(userId).doc(docId).update(data);
  }

  deleteTask(docId) async {
    await collection.doc(docId).delete();
  }

  getTaskFromFirebase() async {
    var tasks = collection.get();
    totalTasks = await collection.snapshots().length;
    notifyListeners();
    return tasks;
  }
}
