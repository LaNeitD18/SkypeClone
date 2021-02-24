import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';

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
}
