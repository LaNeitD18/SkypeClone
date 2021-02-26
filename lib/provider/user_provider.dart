import 'package:SkypeClone/models/user.dart';
import 'package:SkypeClone/resources/firebase_repository.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  UserModel _user;
  FirebaseRepository _repository = FirebaseRepository();

  UserModel get getUser => _user;

  void refreshUser() async {
    UserModel user = await _repository.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
