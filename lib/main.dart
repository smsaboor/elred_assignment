import 'dart:io';
import 'package:elred_assignment/bloc_design_pattern/cubit/cubit_firebase_addtask.dart';
import 'package:elred_assignment/bloc_design_pattern/cubit/cubit_firebase_authentication.dart';
import 'package:elred_assignment/bloc_design_pattern/cubit/cubit_firebase_deletetask.dart';
import 'package:elred_assignment/bloc_design_pattern/cubit/cubit_firebase_gettasks.dart';
import 'package:elred_assignment/bloc_design_pattern/cubit/cubit_firebase_updateask.dart';
import 'package:elred_assignment/multithreading_or_isolate/main_issolate.dart';
import 'package:elred_assignment/page/splash_screen.dart';
import 'package:elred_assignment/provider/firebase.dart';
import 'package:elred_assignment/provider/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:window_size/window_size.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
const double windowWidth = 1200;
const double windowHeight = 800;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Example Sample');
    setWindowMinSize(const Size(windowWidth, windowHeight));
  }
}

void main() async {
  setupWindow();
  HttpOverrides.global = MyHttpOverrides();
  // initializing firebase
  await Firebase.initializeApp();
  // Isolate.spawn<IsolateModel>(heavyTask, IsolateModel(155000, 500));
  final compute=await fetchUserWithSpawn();
  print('fetchUserWithMultiThreadingCompute main ::: ${compute.name}');
  // FirebaseAuth.instance.signOut();
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
        BlocProvider<CubitFirebaseAuthentication>(create: (context)=> CubitFirebaseAuthentication()),
        BlocProvider<CubitFirebaseAddTask>(create: (context)=> CubitFirebaseAddTask()),
        BlocProvider<CubitFirebaseUpdateTask>(create: (context)=> CubitFirebaseUpdateTask()),
        BlocProvider<CubitFirebaseDeleteTask>(create: (context)=> CubitFirebaseDeleteTask()),
        BlocProvider<CubitFirebaseGetTasks>(create: (context)=> CubitFirebaseGetTasks())
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

class MClass extends StatelessWidget {
  const MClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('MediaQuery: ${MediaQuery.of(context).size}');
    return Container();
  }
}


class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
