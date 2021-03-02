import 'package:SkypeClone/models/log.dart';
import 'package:SkypeClone/resources/local_db/interface/log_interface.dart';

class HiveMethods implements LogInterface {
  @override
  addLogs(Log log) {
    print("Adding values to hive db");
    return null;
  }

  @override
  close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  deleteLogs(int logId) {
    // TODO: implement deleteLogs
    throw UnimplementedError();
  }

  @override
  Future<List<Log>> getLogs() {
    // TODO: implement getLogs
    throw UnimplementedError();
  }

  @override
  init() {
    print("initialize hive db");
    return null;
  }
}
