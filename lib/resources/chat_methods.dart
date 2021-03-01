import 'package:SkypeClone/models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SkypeClone/constants/strings.dart';
import 'package:SkypeClone/models/message.dart';
import 'package:SkypeClone/models/user.dart';
import 'package:flutter/cupertino.dart';

class ChatMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference _messageCollection =
      firestore.collection(MESSAGES_COLLECTION);

  final CollectionReference _userCollection =
      firestore.collection(USERS_COLLECTION);

  Future<void> addMessageToDb(
      Message message, UserModel sender, UserModel receiver) async {
    var map = message.toMap();

    await _messageCollection
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    return await _messageCollection
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference getContactsDocument({String of, String forContact}) =>
      _userCollection.doc(of).collection(CONTACTS_COLLECTION).doc(forContact);

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSendersContact(senderId, receiverId, currentTime);
    await addToReceiversContact(senderId, receiverId, currentTime);
  }

  Future<void> addToSendersContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    // check whether this document already exists
    // if it does, it would mean that the person with whom the sender is
    // communicating with is already a contact => do nothing
    // if it doesn't, it mean that this is a new person
    if (!senderSnapshot.exists) {
      // does not exist
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiversContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    // check whether this document already exists
    // if it does, it would mean that the person with whom the sender is
    // communicating with is already a contact => do nothing
    // if it doesn't, it mean that this is a new person
    if (!receiverSnapshot.exists) {
      // does not exist
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  void setImageMessage(String url, String receiverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    var map = message.toMapForImage();

    // set data to db
    await _messageCollection
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);

    await _messageCollection
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) =>
      _userCollection.doc(userId).collection(CONTACTS_COLLECTION).snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween(
          {@required String senderId, @required String receiverId}) =>
      _messageCollection
          .doc(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
}
