// this file will contain all the functions which carry out call related
// backend operations

import 'package:SkypeClone/constants/strings.dart';
import 'package:SkypeClone/models/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallMethods {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection(CALL_COLLECTION);

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.doc(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      // caller document
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      // receiver document
      call.hasDialled = false;
      Map<String, dynamic> hasNoDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNoDialledMap);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
