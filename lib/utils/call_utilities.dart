import 'dart:math';

import 'package:SkypeClone/constants/strings.dart';
import 'package:SkypeClone/models/call.dart';
import 'package:SkypeClone/models/log.dart';
import 'package:SkypeClone/models/user.dart';
import 'package:SkypeClone/resources/call_methods.dart';
import 'package:SkypeClone/resources/local_db/repository/log_repository.dart';
import 'package:SkypeClone/screens/callscreens/call_screen.dart';
import 'package:flutter/material.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({UserModel from, UserModel to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(10000).toString(),
    );

    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      // adds call log to local db
      LogRepository.addLogs(log);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CallScreen(call: call)));
    }
  }
}
