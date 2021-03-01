import 'package:cloud_firestore/cloud_firestore.dart';

import 'user.dart';

class Contact {
  String uid;
  Timestamp addedOn;

  Contact({this.uid, this.addedOn});

  Map toMap(Contact contact) {
    Map contactMap = Map<String, dynamic>();

    contactMap['contact_id'] = contact.uid;
    contactMap['added_on'] = contact.addedOn;

    return contactMap;
  }

  Contact.fromMap(Map<String, dynamic> contactMap) {
    this.uid = contactMap['contact_id'];
    this.addedOn = contactMap['added_on'];
  }
}
