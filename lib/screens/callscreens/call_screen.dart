import 'dart:async';

import 'package:SkypeClone/models/call.dart';
import 'package:SkypeClone/provider/user_provider.dart';
import 'package:SkypeClone/resources/call_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class CallScreen extends StatefulWidget {
  final Call call;

  CallScreen({@required this.call});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallMethods callMethods = CallMethods();

  UserProvider userProvider;
  StreamSubscription callStreamSubscription;

  @override
  void initState() {
    super.initState();
    addPostFrameCallback();
  }

  addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      callStreamSubscription =
          callMethods.callStream(uid: userProvider.getUser.uid).listen((event) {
        // defining the logic
        switch (event.data()) {
          case null:
            // this means that call is hanged and documents are deleted
            Navigator.pop(context);
            break;
          default:
            break;
        }

        // why we use switch instead of if block, because
        // if block does not prevent execution of code
        // that means when we delete the document in the db sometimes
        // the stream is triggered more than once
        // which means that the snapshot returns with a null value more than once
        // if block would have triggered navigated or pop more than once
        // this would cause the user to land on a black screen
        // switch prevent extra code execution with the help of break keyword
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    callStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Call has been made"),
            MaterialButton(
              color: Colors.red,
              child: Icon(
                Icons.call_end,
                color: Colors.white,
              ),
              onPressed: () {
                callMethods.endCall(call: widget.call);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
