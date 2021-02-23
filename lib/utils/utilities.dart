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
}
