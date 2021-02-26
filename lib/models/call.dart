class Call {
  String callerId;
  String callerName;
  String callerPic;

  String receiverId;
  String receiverName;
  String receiverPic;

  String channelId;

  // true for the dialer or the caller, false for receiver
  // need this since we wish to show a different UI or perform different actions
  // for caller and receiver
  bool hasDialled;

  Call({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.receiverId,
    this.receiverName,
    this.receiverPic,
    this.channelId,
    this.hasDialled,
  });

  // to map
  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> callMap = Map();

    callMap['callerId'] = call.callerId;
    callMap['callerName'] = call.callerName;
    callMap['callerPic'] = call.callerPic;
    callMap['receiverId'] = call.receiverId;
    callMap['receiverName'] = call.receiverName;
    callMap['receiverPic'] = call.receiverPic;
    callMap['channelId'] = call.channelId;
    callMap['hasDialled'] = call.hasDialled;

    return callMap;
  }

  Call.fromMap(Map<String, dynamic> callMap) {
    this.callerId = callMap['callerId'];
    this.callerName = callMap['callerName'];
    this.callerPic = callMap['callerPic'];
    this.receiverId = callMap['receiverId'];
    this.receiverName = callMap['receiverName'];
    this.receiverPic = callMap['receiverPic'];
    this.channelId = callMap['channelId'];
    this.hasDialled = callMap['hasDialled'];
  }
}
