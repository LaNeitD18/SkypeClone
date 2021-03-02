class Log {
  int logId;
  String callerName;
  String callerPic;
  String receiverName;
  String receiverPic;
  String callStatus;
  String timestamp;

  Log({
    this.logId,
    this.callerName,
    this.callerPic,
    this.receiverName,
    this.receiverPic,
    this.callStatus,
    this.timestamp,
  });

  // to map
  Map<String, dynamic> toMap(Log log) {
    Map<String, dynamic> logMap = Map();
    logMap["logId"] = log.logId;
    logMap["callerName"] = log.callerName;
    logMap["callerPic"] = log.callerPic;
    logMap["receiverName"] = log.receiverName;
    logMap["receiverPic"] = log.receiverPic;
    logMap["callStatus"] = log.callStatus;
    logMap["timestamp"] = log.timestamp;
    return logMap;
  }

  Log.fromMap(Map<String, dynamic> logMap) {
    this.logId = logMap["logId"];
    this.callerName = logMap["callerName"];
    this.callerPic = logMap["callerPic"];
    this.receiverName = logMap["receiverName"];
    this.receiverPic = logMap["receiverPic"];
    this.callStatus = logMap["callStatus"];
    this.timestamp = logMap["timestamp"];
  }
}
