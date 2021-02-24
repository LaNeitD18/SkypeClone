import 'dart:io';

import 'package:SkypeClone/models/message.dart';
import 'package:SkypeClone/models/user.dart';
import 'package:SkypeClone/resources/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<User> getCurrentUser() => _firebaseMethods.getCurrentUser();

  Future<User> signIn() => _firebaseMethods.signIn();

  Future<bool> authenticateUser(user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDb(currentUser) =>
      _firebaseMethods.addDataToDb(currentUser);

  Future<void> signOut() => _firebaseMethods.signOut();

  Future<List<UserModel>> fetchAllUsers(User currentUser) =>
      _firebaseMethods.fetchAllUsers(currentUser);

  // Future<UserModel> fetchUserDetailsById(String uid) =>
  //     _firebaseMethods.fetchUserDetailsById(uid);

  Future<void> addMessageToDb(
          Message message, UserModel sender, UserModel receiver) =>
      _firebaseMethods.addMessageToDb(message, sender, receiver);

  void uploadImage({
    @required File image,
    @required String receiverId,
    @required String senderId,
  }) =>
      _firebaseMethods.uploadImage(image, receiverId, senderId);
}
