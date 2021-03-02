import 'dart:io';
import 'package:SkypeClone/enum/user_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Utils {
  static String getUsername(String email) {
    // split email string into 2 part and return only username
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");

    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];

    return firstNameInitial + lastNameInitial;
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    ImagePicker picker = ImagePicker();
    PickedFile file = await picker.getImage(
        source: source, maxWidth: 500, maxHeight: 500, imageQuality: 85);
    File selectedImage = File(file.path);
    return selectedImage;
  }

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;
      case UserState.Online:
        return 1;
      default:
        return 2;
    }
  }

  static UserState numToState(int number) {
    switch (number) {
      case 0:
        return UserState.Offline;
      case 1:
        return UserState.Online;
      default:
        return UserState.Waiting;
    }
  }

  static String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    var formatter = DateFormat('dd/MM/yy');
    return formatter.format(dateTime);
  }
}
