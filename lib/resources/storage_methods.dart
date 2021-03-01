import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:SkypeClone/models/user.dart';
import 'package:SkypeClone/provider/image_upload_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SkypeClone/resources/chat_methods.dart';

class StorageMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Reference _reference;

  // class user
  UserModel user = UserModel();

  Future<String> uploadImageToStorage(File image) async {
    try {
      _reference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');

      UploadTask _storageUploadTask = _reference.putFile(image);

      var url = await (await _storageUploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();

      return url;
    } catch (e) {
      print(e);
      return "";
    }
  }

  void uploadImage(
      {@required File image,
      @required String receiverId,
      @required String senderId,
      @required ImageUploadProvider imageUploadProvider}) async {
    final ChatMethods chatMethods = ChatMethods();

    imageUploadProvider.setToLoading();
    String url = await uploadImageToStorage(image);
    imageUploadProvider.setToIdle();
    chatMethods.setImageMessage(url, receiverId, senderId);
  }
}
