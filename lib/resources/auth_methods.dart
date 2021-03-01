import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:SkypeClone/constants/strings.dart';
import 'package:SkypeClone/models/user.dart';
import 'package:SkypeClone/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final CollectionReference _userCollection =
      firestore.collection(USERS_COLLECTION);

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<UserModel> getUserDetails() async {
    User currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(currentUser.uid).get();

    return UserModel.fromMap(documentSnapshot.data());
  }

  Future<UserModel> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();

      return UserModel.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
    }
  }

  Future<User> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        idToken: _signInAuthentication.idToken,
        accessToken: _signInAuthentication.accessToken);

    final UserCredential _authResult =
        await _auth.signInWithCredential(credential);

    User user = _authResult.user;
    return user;
  }

  // check if user is new or not
  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where("email", isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(User currentUser) async {
    String username = Utils.getUsername(currentUser.email);

    UserModel user = UserModel(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoURL,
      username: username,
    );
    firestore
        .collection(USERS_COLLECTION)
        .doc(currentUser.uid)
        .set(user.toMap(user));
  }

  Future<List<UserModel>> fetchAllUsers(User currentUser) async {
    List<UserModel> userList = List<UserModel>();

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).get();

    for (var user in querySnapshot.docs) {
      if (user.id != currentUser.uid) {
        userList.add(UserModel.fromMap(user.data()));
      }
    }
    return userList;
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }
}
