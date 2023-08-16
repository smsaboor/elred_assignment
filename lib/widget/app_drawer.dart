import 'package:elred_assignment/bloc_design_pattern/bloc_demo/bloc/bloc_firebase_auth.dart';
import 'package:elred_assignment/bloc_design_pattern/bloc_demo/events/auth_events.dart';
import 'package:elred_assignment/bloc_design_pattern/cubit/cubit_firebase_authentication.dart';
import 'package:elred_assignment/page/add_task.dart';
import 'package:elred_assignment/provider/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'drawer_links.dart';
import 'custom_scafold.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final int currentPage = 0;

  Color onPrimaryColor = Colors.white;

  appHeight(context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return height;
  }

  appWidth(context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return width;
  }

  bool isLogoutPressed=false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Material(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.indigo),
          height: appHeight(context),
          width: appWidth(context) * .7,
          child: Column(
            children: [
              SizedBox(height: appHeight(context) * .07),
              SizedBox(
                height: appHeight(context) * .15,
                width: appWidth(context) * .7,
                child: Stack(
                  children: [
                    Positioned(
                        top: 3,
                        left: 40,
                        child: Column(children: [
                          CircleAvatar(
                            maxRadius: 25,
                            backgroundImage: NetworkImage(user!.photoURL!),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            'Name: ' + user.displayName!,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Email: ' + user.email!,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  height: appHeight(context) * .75,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    CustomScaffold(title: 'My Account')));
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15.0),
                                    child: FaIcon(
                                      FontAwesomeIcons.userShield,
                                      color: Colors.white,
                                      size: 17,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        'My Account',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Divider(
                                color: Colors.yellowAccent,
                              )
                            ],
                          ),
                        ),
                        DrawerLinks(
                          icon: FaIcon(
                            FontAwesomeIcons.plus,
                            color: onPrimaryColor,
                            size: 17,
                          ),
                          isLogout: false,
                          onTapWidget: AddTask(isUpdate: false,),
                          title: "Add New Tasks",
                        ),
                        DrawerLinks(
                          icon: FaIcon(
                            FontAwesomeIcons.circleInfo,
                            color: onPrimaryColor,
                            size: 17,
                          ),
                          isLogout: false,
                          onTapWidget: CustomScaffold(title: 'Help & support'),
                          title: "Help & support",
                        ),
                        DrawerLinks(
                          icon: FaIcon(
                            FontAwesomeIcons.arrowUpFromBracket,
                            color: onPrimaryColor,
                            size: 17,
                          ),
                          isLogout: false,
                          onTapWidget: CustomScaffold(title: 'Upgrade app'),
                          title: "Upgrade app",
                        ),
                        DrawerLinks(
                          icon: FaIcon(
                            FontAwesomeIcons.fileCircleQuestion,
                            color: onPrimaryColor,
                            size: 15,
                          ),
                          isLogout: false,
                          onTapWidget: CustomScaffold(
                              title: 'Term & conditions'),
                          title: "Term & conditions",
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isLogoutPressed=true;
                            });
                            // final provider = Provider.of<GoogleSignInProvider>(
                            //     context, listen: false);
                            // provider.logout();
                            // final provider = Provider.of<CubitFirebaseAuthentication>(
                            //     context, listen: false);
                            // provider.logout();
                            context.read<BlocFirebaseAuth>().add(EventAuthSignOut());
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15.0),
                                    child: FaIcon(
                                      FontAwesomeIcons.arrowRightFromBracket,
                                      color: Colors.white,
                                      size: 17,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        'Logout',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  SizedBox(width: 20,),
                                  isLogoutPressed?SizedBox(height:20,width:20,child: CircularProgressIndicator(color: Colors.white,)):Container()
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Divider(
                                color: Colors.yellowAccent,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
