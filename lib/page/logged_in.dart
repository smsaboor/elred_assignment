import 'package:elred_assignment/widget/sliver_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'add_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elred_assignment/provider/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:elred_assignment/widget/app_drawer.dart';

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({super.key});

  @override
  State<LoggedInPage> createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  var data;
  var onlineUsers;
  bool loading = true;
  bool isOffline = true;
  late var subscription;

  void _addUser() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AddTask(isUpdate: false)));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // to get info of current user from firebase
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      key: _scaffoldkey,
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: _addUser,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
      // StreamBuilder to build task collection data
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('task')
              .doc(user!.uid)
              .collection(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            return Container(
              color: Colors.black12,
              child: SafeArea(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      MySliverAppBar(scafolKey: _scaffoldkey),
                      const SliverPadding(
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            'My Tasks',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 20, top: 20),
                      ),
                      snapshot.hasError
                          ? const SliverPadding(
                              sliver: SliverToBoxAdapter(
                                child: Text('Something wrong !'),
                              ),
                              padding: EdgeInsets.only(left: 20),
                            )
                          : snapshot.connectionState == ConnectionState.waiting
                              ? const SliverPadding(
                                  sliver: SliverToBoxAdapter(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  padding: EdgeInsets.only(left: 20),
                                )
                              : snapshot.data!.docs.isEmpty
                                  ? const SliverPadding(
                                      sliver: SliverToBoxAdapter(
                                        child: Text(
                                          'No Tasks Found',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 10),
                                        ),
                                      ),
                                      padding: EdgeInsets.only(left: 20, top: 10),
                                    )
                                  : SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                      childCount: snapshot.data!.docs.length,
                                      (context, index) {
                                        Provider.of<FirebaseProvider>(context)
                                            .setTotalTasks(
                                                snapshot.data!.docs.length);
                                        return ListTile(
                                          leading: Container(
                                              padding: const EdgeInsets.all(8),
                                              width: 40,
                                              child: Text('${index + 1}')),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              FirebaseProvider().deleteTask(
                                                  snapshot.data!.docs[index].id);
                                            },
                                          ),
                                          title: Text(
                                              '${snapshot.data!.docs[index]['name']}',
                                              textScaleFactor: 1),
                                          subtitle: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${snapshot.data!.docs[index]['description']}',
                                                  textScaleFactor: 1),
                                              Text(
                                                  '${snapshot.data!.docs[index]['date']}',
                                                  textScaleFactor: 1),
                                            ],
                                          ),
                                          splashColor: Colors.indigoAccent,
                                          onTap: () {
                                            // print('object:${docs[index]}');
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (_) => AddTask(
                                                          task: snapshot
                                                              .data!.docs[index],
                                                          isUpdate: true,
                                                        )));
                                          },
                                        );
                                      },
                                    ))
                    ],
                  ),
              ),
            );
          }),
    );
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
