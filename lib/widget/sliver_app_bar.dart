import 'package:elred_assignment/provider/firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySliverAppBar extends StatefulWidget {
  const MySliverAppBar({Key? key, required this.scafolKey}) : super(key: key);
  final scafolKey;

  @override
  State<MySliverAppBar> createState() => _MySliverAppBarState();
}

class _MySliverAppBarState extends State<MySliverAppBar> {
  @override
  void initState() {
    Provider.of<FirebaseProvider>(context,listen: false).getTaskFromFirebase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      // title: Text('My Tasks'),
      backgroundColor: Colors.indigo,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0), ), ),
      expandedHeight: 220,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsetsDirectional.only(start: 60, bottom:20),
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('My Tasks', textScaleFactor: .8),
            Spacer(),
            Consumer<FirebaseProvider>(
                builder: (context, obj, child) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Text('${obj.getTotalTasks} Tasks',textScaleFactor: .7),
                  );
                })
          ],
        ),
        stretchModes: const [StretchMode.zoomBackground],
        background: ClipRRect(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),bottomRight: Radius.circular(0)),
          child: Image.asset(
            'assets/images/mountain.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}