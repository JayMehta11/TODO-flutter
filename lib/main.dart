import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase/auth/authscreen.dart';
import 'package:firebase_core/firebase_core.dart';

// ignore: unused_import
import 'package:todo_firebase/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyA_DJoJC-ZlaofzOkgXS_CJcaHRT1SIBnU",
          appId: "1:180219410244:android:57da8f5fecc853478dc911",
          messagingSenderId: "180219410244",
          projectId: "todofirebase-2db30"));
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, usersnapshot) {
          if (usersnapshot.hasData) {
            return Home();
          } else {
            return AuthScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.purple,
          appBarTheme: AppBarTheme(color: Colors.purple)),
    );
  }
}
