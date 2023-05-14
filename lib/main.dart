import 'dart:io';
import 'package:elred_assignment/page/splash_screen.dart';
import 'package:elred_assignment/provider/firebase.dart';
import 'package:elred_assignment/provider/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global= MyHttpOverrides();
  // initializing firebase
  await Firebase.initializeApp();
  // use setSystemUIOverlayStyle to change default color of system statusBar color
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.black, // Note RED here
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FirebaseProvider to handle firebase states and GoogleSignInProvider to handle login with google
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseProvider>(create: (context) => FirebaseProvider()),
        ChangeNotifierProvider<GoogleSignInProvider>(
            create: (context) => GoogleSignInProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Add Task',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const SplashScreen(),
      )
    );
  }
}

