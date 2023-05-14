import 'package:elred_assignment/page/sign_up.dart';

import 'logged_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../provider/google_sign_in.dart';
import '../widget/background_painter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    // ChangeNotifierProvider handle login states if login states is changed then
    // ChangeNotifierProvider handle screens with the help of predefined states and  StreamBuilder
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<GoogleSignInProvider>(context);
              if (provider.isSigningIn) {
                return buildLoading();
              } else if (snapshot.hasData) {
                return const LoggedInPage();
              } else {
                return SignUp();
              }
            },
          ),
        ),
      );

  Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: BackgroundPainter()),
          const Center(child: CircularProgressIndicator()),
        ],
      );
}
