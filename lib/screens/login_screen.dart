import 'package:SkypeClone/resources/firebase_repository.dart';
import 'package:SkypeClone/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginButton(),
    );
  }

  Widget loginButton() {
    return FlatButton(
        padding: EdgeInsets.all(35),
        onPressed: () => performLogin(),
        child: Text(
          "LOGIN",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ));
  }

  void performLogin() {
    print("ZZZ");
    _repository.signIn().then((User user) {
      if (user != null) {
      } else {
        print("Error");
      }
    });
  }
  // error: sau khi sign in bi luu tai khoan chua the sign them tk khac
  // sign in ko tao db

  void authenticateUser(User user) {
    _repository.authenticateUser(user).then((isNewUser) {
      if (isNewUser) {
        _repository.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
