import 'package:elred_assignment/widget/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elred_assignment/model/task.dart';
import 'package:elred_assignment/widget/date.dart';
import 'package:elred_assignment/provider/firebase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/handle_response.dart';

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
  Widget? mySuffixIcon;

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

  String buttonText = 'Add Task';
  String title = 'Add New Task';

  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false).initializingState();
    if (widget.isUpdate) {
      print('object::::${widget.task.id}');
      _controllerTaskName.text = widget.task['name'];
      _controllerDescription.text = widget.task['description'];
      _controllerDate.text = widget.task['date'];
      buttonText = 'Update Task';
      title = 'Update Task';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.blueAccent,
            size: 30,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w300),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const FaIcon(
                FontAwesomeIcons.sliders,
                color: Colors.blueAccent,
                size: 24,
              ))
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _key,
        child: Consumer<FirebaseProvider>(builder: (context, obj, child) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Center(child: FaIcon(FontAwesomeIcons.paintbrush,color: Colors.white70,)),),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .07,
                child: Padding(
                  padding: const EdgeInsets.only(left: 28.0, right: 28),
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        (hasFocus)
                            ? mySuffixIcon= GestureDetector(onTap: (){
                          _controllerTaskName.clear();
                        }, child: const Icon(Icons.cancel,size: 22,color: Colors.black45,)): null;
                      });
                    },
                    child: TextFormField(
                      cursorColor: Colors.white,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                      controller: _controllerTaskName,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Task Name';
                        }
                        if (value.length < 4) {
                          return 'length must 4 digit';
                        }
                      },
                      decoration: InputDecoration(
                        suffix: mySuffixIcon,
                        filled: true,
                        errorStyle: TextStyle(
                          color: Colors.white70,
                        ),
                        labelStyle: const TextStyle(color: Colors.white),
                        fillColor: Colors.indigo,
                        enabledBorder: const UnderlineInputBorder(
                          //<-- SEE HERE
                            borderSide:
                            BorderSide(width: .3, color: Colors.white)),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(width: .5, color: Colors.cyan),
                        ),
                        hintText: 'Enter Task Name',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .07,
                child: Padding(
                  padding: const EdgeInsets.only(left: 28.0, right: 28),
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        (hasFocus)
                            ? mySuffixIcon= GestureDetector(onTap: (){
                              _controllerDescription.clear();
                        }, child: const Icon(Icons.cancel,size: 22,color: Colors.black45,)): null;
                      });
                    },
                    child: TextFormField(
                      textAlign: TextAlign.left,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                      controller: _controllerDescription,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Task Description';
                        }
                        if (value.length < 5) {
                          return 'limit 5 character';
                        }
                      },
                      decoration: InputDecoration(
                        // contentPadding: EdgeInsets.all(8),
                        suffix: mySuffixIcon,
                        filled: true,
                        fillColor: Colors.indigo,
                        errorStyle: TextStyle(
                          color: Colors.white70,
                        ),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: .3, color: Colors.white)),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.cyan),
                        ),
                        hintText: 'Enter Task Description',
                        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 30.0, right: 30, bottom: 0),
                child: SizedBox(
                  height: 45,
                  child: CustomDate(
                    controller: _controllerDate,
                    initialDate: DateTime(2023),
                    firstDate: DateTime(2010),
                    lastDate: DateTime(2025),
                    validator: (value) {
                      if (_controllerDate.text.isEmpty) {
                        return '   Please Enter task date';
                      }
                    },
                    labelText: '  Select date',
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .07,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * .9,
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
                          color: Colors.blue,
                          // borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: obj.getResponseAddingTask.status ==
                              Status.LOADING ||
                              obj.getResponseUpdatingTask.status ==
                                  Status.LOADING
                              ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                              : Text(
                            buttonText,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              widget.isUpdate
                  ? Center(
                child: Text(
                  '${obj.getResponseUpdatingTask.status == Status.INITIAL
                      ? ''
                      : obj.getResponseUpdatingTask.status == Status.LOADING
                      ? obj.getResponseUpdatingTask.message
                      : obj.getResponseUpdatingTask.status == Status.COMPLETED
                      ? obj.getResponseUpdatingTask.message
                      : obj.getResponseUpdatingTask.status == Status.ERROR ? obj
                      .getResponseUpdatingTask.message : ''}',
                  style: const TextStyle(color: Colors.white),
                ),
              )
                  : Center(
                child: Text(
                  '${obj.getResponseAddingTask.status == Status.INITIAL
                      ? ''
                      : obj.getResponseAddingTask.status == Status.LOADING ? obj
                      .getResponseAddingTask.message : obj.getResponseAddingTask
                      .status == Status.COMPLETED ? obj.getResponseAddingTask
                      .message : obj.getResponseAddingTask.status ==
                      Status.ERROR ? obj.getResponseAddingTask.message : ''}',
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  addUser(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (_key.currentState!.validate()) {
      Task task = Task(
          userId: user!.uid,
          name: _controllerTaskName.text,
          description: _controllerDescription.text,
          date: _controllerDate.text);
      // check internet connection before insert and update task and notify user to check internet connection
      await checkConnectivity(context);
      if (isConnected) {
        if (widget.isUpdate) {
          // update task if isUpdate flag is true
          await Provider.of<FirebaseProvider>(context, listen: false)
              .updateTask(context, user.uid, task.toJson(), widget.task.id);
        } else {
          // add task if isUpdate flag is flase
          await Provider.of<FirebaseProvider>(context, listen: false)
              .addTask(context, user.uid, task.toJson());
        }
        Navigator.pop(context);
      } else {
        Util.snackBar(
            context: context,
            data: 'You are offline, please try after sometime.',
            color: Colors.red);
      }
    }
  }
}
