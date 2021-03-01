import 'package:SkypeClone/screens/search_screen.dart';
import 'package:SkypeClone/utils/universal_variables.dart';
import 'package:flutter/material.dart';

class QuiteBox extends StatelessWidget {
  const QuiteBox({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "This is where all the contacts are listed",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Search for your friends and family to start calling or chatting with them",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.2,
                    fontSize: 18),
              ),
              SizedBox(
                height: 25,
              ),
              FlatButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen())),
                child: Text("Start searching"),
                color: UniversalVariables.lightBlueColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
