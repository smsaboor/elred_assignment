import 'package:elred_assignment/agora/agora_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'add_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elred_assignment/provider/firebase.dart';
import 'package:flutter/material.dart';
import 'package:elred_assignment/widget/app_drawer.dart';

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({super.key});

  @override
  State<LoggedInPage> createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TabController? tabController;
  var data;
  var onlineUsers;
  bool loading = true;
  bool isOffline = true;
  late var subscription;

  void _addUser() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => AddTask(isUpdate: false)))
        .then((value) =>
        Provider.of<FirebaseProvider>(context, listen: false)
            .getTaskFromFirebase());
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    Provider.of<FirebaseProvider>(context, listen: false).getTaskFromFirebase();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d, MMM').format(now);
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
            return SafeArea(
                child: DefaultTabController(
                  length: 2,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverPadding(
                          sliver: SliverToBoxAdapter(
                            child: Stack(
                              children: [
                                Container(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * .3,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  decoration: const BoxDecoration(
                                      color: Colors.indigo,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/mountain.png'),
                                          fit: BoxFit.fill)),
                                ),
                                Positioned(
                                    top: 10,
                                    left: 10,
                                    child: IconButton(
                                      icon: const FaIcon(
                                        Icons.menu,
                                        size: 36,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        _scaffoldkey.currentState!.openDrawer();
                                      },
                                    )),
                                Positioned(
                                    top: 80,
                                    left: 30,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'My',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 36),
                                            ),
                                            const Text(
                                              'Tasks',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 36),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 120,
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .end,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            Consumer<FirebaseProvider>(
                                                builder: (context, obj, child) {
                                                  return Text(
                                                    '${obj.getTotalTasks}',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 28),);
                                                }),
                                            const Text(
                                              'Personal',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        AgoraHome()));
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .end,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                '0',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 28),
                                              ),
                                              const Text(
                                                'Business',
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        )
                                      ],
                                    )),
                                Positioned(
                                    top: 200,
                                    left: 30,
                                    child: Row(
                                      children: [
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                              color: Colors.white54,
                                              fontSize: 18),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 0),
                        ),
                        SliverPersistentHeader(
                          delegate: SliverAppBarDelegate(
                            TabBar(
                              controller: tabController,
                              indicator: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.blue, width: 4.0),
                                ),
                              ),
                              tabs: [
                                Tab(child: Container()),
                                Tab(child: Container()),
                              ],
                            ),
                          ),
                          pinned: true,
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: tabController,
                      physics: const ScrollPhysics(),
                      children: [
                        snapshot.hasError
                            ? const Text('Something wrong !')
                            : snapshot.connectionState ==
                            ConnectionState.waiting
                            ? const Center(
                          child: CircularProgressIndicator(),
                        )
                            : snapshot.data!.docs.isEmpty
                            ? const Text(
                          'No Tasks Found',
                          style: TextStyle(
                              color: Colors.red, fontSize: 10),
                        )
                            : SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height,
                          child: ListView.separated(
                            itemCount:
                            snapshot.data!.docs.length,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              if (index == 0) {
                                return Container();
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.only(
                                      left: 28.0, right: 28),
                                  child: Divider(thickness: 1,),
                                );
                              }
                            },
                            itemBuilder: (BuildContext context,
                                int index) {
                              if (index == 0) {
                                return const Padding(
                                  padding: EdgeInsets.only(
                                      left: 28.0, top: 18, bottom: 18),
                                  child: Text(
                                    'INBOX', style: TextStyle(fontSize: 20),),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 14.0),
                                  child: ListTile(
                                    leading: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30)),
                                        ),
                                        child: Center(
                                            child: index % 2 == 0
                                                ? FaIcon(FontAwesomeIcons.brush,
                                              color: Colors.blue.shade300,)
                                                : FaIcon(
                                              FontAwesomeIcons.paintbrush,
                                              color: Colors.blue.shade300,))),
                                    trailing: Text(
                                        '${snapshot.data!.docs[index]['date']}',
                                        textScaleFactor: 1),
                                    title: Text(
                                      '${snapshot.data!.docs[index]['name']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5,),
                                        Text(
                                            '${snapshot.data!
                                                .docs[index]['description']}',
                                            style: const TextStyle(
                                                fontSize: 16)),
                                      ],
                                    ),
                                    splashColor:
                                    Colors.indigoAccent,
                                    onTap: () {
                                      // print('object:${docs[index]}');
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  AddTask(
                                                    task: snapshot
                                                        .data!
                                                        .docs[
                                                    index],
                                                    isUpdate: true,
                                                  )));
                                    },
                                    onLongPress: () async {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) =>
                                            AlertDialog(
                                              title: const Text(
                                                  "Delete Confirmation !"),
                                              content: const Text(
                                                  "Are you want to delete this task?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: Container(
                                                    color: Colors.indigo,
                                                    padding: const EdgeInsets
                                                        .all(14),
                                                    child: const Text("cancel",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white),),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(ctx).pop();
                                                    await Provider.of<
                                                        FirebaseProvider>(
                                                        context,
                                                        listen: false)
                                                        .deleteTask(
                                                        context,
                                                        snapshot
                                                            .data!
                                                            .docs[index]
                                                            .id);

                                                    await Provider.of<
                                                        FirebaseProvider>(
                                                        context,
                                                        listen: false)
                                                        .getTaskFromFirebase();
                                                  },
                                                  child: Container(
                                                    color: Colors.indigo,
                                                    padding: const EdgeInsets
                                                        .all(14),
                                                    child: const Text("Delete",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white),),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const Icon(Icons.add, size: 50),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height * .05;

  @override
  double get maxExtent => _tabBar.preferredSize.height * .05;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return new Container(
      color: Colors.black, // ADD THE COLOR YOU WANT AS BACKGROUND.
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
