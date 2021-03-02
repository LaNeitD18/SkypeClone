import 'package:SkypeClone/models/log.dart';

abstract class LogInterface {
  init();

  addLogs(Log log);

  // return a list of logs
  Future<List<Log>> getLogs();

  deleteLogs(int logId);

  close();
}
