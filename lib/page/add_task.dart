import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elred_assignment/model/task.dart';
import 'package:elred_assignment/widget/date.dart';
import 'package:elred_assignment/provider/firebase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AddTask extends StatefulWidget {
  AddTask({Key? key, this.task, required this.isUpdate}) : super(key: key);
  var task;
  final bool isUpdate;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _controllerTaskName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();
  bool saving = false;
  bool isConnected = false;

  checkConnectivity(context) async {
    isConnected = false;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      isConnected = true;
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isConnected = true;
      // I am connected to a wifi network.
    } else if (connectivityResult == ConnectivityResult.none) {
      isConnected = false;
    } else {
      isConnected = false;
    }
  }
  String buttonText='Add Task';
  String title='Add New Task';
 @override
  void initState() {
    if(widget.isUpdate){
      print('object::::${widget.task.id}');
     _controllerTaskName.text=widget.task['name'];
     _controllerDescription.text=widget.task['description'];
     _controllerDate.text=widget.task['date'];
     buttonText='Update Task';
     title='Update Task';
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Form(
        key: _key,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 50,
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .07,
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  controller: _controllerTaskName,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Task Name';
                    }
                    if (value.length < 4) {
                      return 'length must 4 digit';
                    }
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    prefixIconColor: Colors.grey,
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.task_alt,
                        color: Colors.grey,
                      ),
                    ),
                    prefixIconConstraints:
                        BoxConstraints(minHeight: 40, minWidth: 40),
                    hintText: 'Enter Task Name',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .07,
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  controller: _controllerDescription,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Task Description';
                    }
                    if (value.length < 5) {
                      return 'limit 5 character';
                    }
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    prefixIconColor: Colors.grey,
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.description_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    prefixIconConstraints:
                        BoxConstraints(minHeight: 40, minWidth: 40),
                    hintText: 'Enter Description',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 0),
              child: SizedBox(
                height: 45,
                child: CustomDate(
                  controller: _controllerDate,
                  initialDate: DateTime(2023),
                  firstDate: DateTime(2010),
                  lastDate: DateTime(2025),
                  validator: (value) {
                    if (_controllerDate.text.isEmpty) {
                      return 'Enter task date';
                    }
                  },
                  labelText: 'Select date',
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .07,
              width: MediaQuery.of(context).size.width * .9,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 28.0, right: 28, top: 8, bottom: 8),
                child: InkWell(
                  onTap: () {
                    addUser(context);
                  },
                  // style: ButtonStyle(side: ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: saving
                          ? const CircularProgressIndicator()
                          : Text(
                              buttonText,
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addUser(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (_key.currentState!.validate()) {
      setState(() {
        saving = true;
      });
      Task task = Task(
          userId: user!.uid,
          name: _controllerTaskName.text,
          description: _controllerDescription.text,
          date: _controllerDate.text);
      // check internet connection before insert and update task and notify user to check internet connection
        await checkConnectivity(context);
        if (isConnected) {
          if(widget.isUpdate){
            // update task if isUpdate flag is true
            FirebaseProvider().updateTask(context,user.uid,task.toJson(),widget.task.id);
          }else{
            // add task if isUpdate flag is flase
            FirebaseProvider().addTask(context,user.uid,task.toJson());
          }
          Navigator.pop(context);
        } else {
          snackBar(context: context, data: 'You are offline, please try after sometime.', color: Colors.red);
        }
        setState(() {
          saving = false;
        });
    }
  }

  snackBar(
      {required BuildContext context,
      required String data,
      required Color color}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Padding(
              padding: const EdgeInsets.only(left: 10.0), child: Text(data)),
          backgroundColor: color,
          behavior: SnackBarBehavior.fixed));
  }
}
