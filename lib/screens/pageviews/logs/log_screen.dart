import 'package:SkypeClone/models/log.dart';
import 'package:SkypeClone/resources/local_db/repository/log_repository.dart';
import 'package:SkypeClone/screens/callscreens/pickup/pickup_layout.dart';
import 'package:SkypeClone/screens/pageviews/logs/widgets/floating_column.dart';
import 'package:SkypeClone/screens/pageviews/logs/widgets/log_list_container.dart';
import 'package:SkypeClone/utils/universal_variables.dart';
import 'package:SkypeClone/widgets/skype_appbar.dart';
import 'package:flutter/material.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: SkypeAppBar(
          title: "Calls",
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/search_screen");
                }),
          ],
        ),
        floatingActionButton: FloatingColumn(),
        body: Padding(
          padding: EdgeInsets.only(left: 15),
          child: LogListContainer(),
        ),
      ),
    );
  }
}
