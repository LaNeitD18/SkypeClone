import 'package:SkypeClone/resources/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<User> getCurrentUser() => _firebaseMethods.getCurrentUser();
  Future<User> signIn() => _firebaseMethods.signIn();
  Future<bool> authenticateUser(user) =>
      _firebaseMethods.authenticateUser(user);
  Future<void> addDataToDb(currentUser) =>
      _firebaseMethods.addDataToDb(currentUser);
  Future<void> signOut() => _firebaseMethods.signOut();
}