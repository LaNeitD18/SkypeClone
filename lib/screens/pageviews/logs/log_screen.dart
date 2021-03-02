import 'package:SkypeClone/models/log.dart';
import 'package:SkypeClone/resources/local_db/repository/log_repository.dart';
import 'package:SkypeClone/utils/universal_variables.dart';
import 'package:flutter/material.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Center(
        child: FlatButton(
          child: Text("Click me"),
          onPressed: () {
            LogRepository.init(isHive: true);
            LogRepository.addLogs(Log());
          },
        ),
      ),
    );
  }
}
