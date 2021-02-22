class Utils {
  static String getUsername(String email) {
    // split email string into 2 part and return only username
    return "live:${email.split('@')[0]}";
  }
}
