import 'package:SkypeClone/resources/firebase_repository.dart';
import 'package:SkypeClone/screens/home_screen.dart';
import 'package:SkypeClone/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseRepository _repository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.collection('users').doc().set({
    //   'name': 'pht',
    // });

    return MaterialApp(
      title: 'Skype Clone',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _repository.getCurrentUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            print("home");
            return HomeScreen();
          } else {
            print("login");
            return LoginScreen();
          }
        },
      ),
    );
  }
}
