class AuthSession {
  static String? token;
  static String? userId;
  static String? email;
  static String? nickname;

  static bool get isLoggedIn => token != null;
}
