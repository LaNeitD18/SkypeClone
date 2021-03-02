import 'package:SkypeClone/constants/strings.dart';
import 'package:SkypeClone/models/call.dart';
import 'package:SkypeClone/models/log.dart';
import 'package:SkypeClone/resources/call_methods.dart';
import 'package:SkypeClone/resources/local_db/repository/log_repository.dart';
import 'package:SkypeClone/screens/callscreens/call_screen.dart';
import 'package:SkypeClone/screens/chatscreens/widgets/cached_image.dart';
import 'package:SkypeClone/utils/permissions.dart';
import 'package:flutter/material.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({@required this.call});

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  bool isCallMissed = true;

  // initializes and adds log to local db
  addToLocalStorage({@required String callStatus}) {
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus,
    );

    LogRepository.addLogs(log);
  }

  @override
  void dispose() {
    super.dispose();

    if (isCallMissed) {
      addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming. . .",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 50,
            ),
            CachedImage(
              widget.call.callerPic,
              height: 150,
              width: 150,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              widget.call.callerName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 75,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.call_end),
                    color: Colors.redAccent,
                    onPressed: () async {
                      isCallMissed = false;
                      addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                      callMethods.endCall(call: widget.call);
                    }),
                SizedBox(
                  width: 25,
                ),
                IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async {
                      isCallMissed = false;
                      addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                      await Permissions.cameraAndMicrophonePermissionsGranted()
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CallScreen(call: widget.call)))
                          : () {};
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
