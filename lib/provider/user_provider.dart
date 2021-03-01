import 'package:SkypeClone/models/user.dart';
import 'package:SkypeClone/resources/auth_methods.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();
  UserModel _user;

  UserModel get getUser => _user;

  void refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
