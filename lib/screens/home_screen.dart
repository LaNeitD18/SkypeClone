import 'package:flutter/material.dart';
import 'package:SkypeClone/resources/firebase_repository.dart';

class HomeScreen extends StatelessWidget {
  //const HomeScreen({Key key}) : super(key: key);
  FirebaseRepository _repository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlatButton(
        onPressed: () => _repository.signOut(),
        child: Text(
          "homing",
          style: TextStyle(fontSize: 50),
        ),
      ),
    );
  }
}
