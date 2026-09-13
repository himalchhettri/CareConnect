import 'package:shared_preferences/shared_preferences.dart';
class AuthService {
  static const String _nameKey = 'user_name';
  static const String _emailKey = 'user_email';
  static const String _phoneKey = 'user_phone';
  static const String _passwordKey = 'user_password';
  static const String _registeredKey = 'is_registered';
  static const String _loggedInKey = 'is_logged_in';

  static Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_nameKey, name.trim());
    await preferences.setString(_emailKey, email.trim().toLowerCase());
    await preferences.setString(_phoneKey, phone.trim());
    await preferences.setString(_passwordKey, password);
    await preferences.setBool(_registeredKey, true);
    await preferences.setBool(_loggedInKey, false);
  }

  static Future<bool> hasRegisteredAccount() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_registeredKey) ?? false;
  }

  static Future<bool> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final preferences = await SharedPreferences.getInstance();

    final savedEmail = preferences.getString(_emailKey);
    final savedPassword = preferences.getString(_passwordKey);

    final credentialsMatch =
        savedEmail == email.trim().toLowerCase() &&
        savedPassword == password;

    if (credentialsMatch) {
      await preferences.setBool(_loggedInKey, rememberMe);
      return true;
    }

    return false;
  }

  static Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_loggedInKey) ?? false;
  }

  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final savedPassword = preferences.getString(_passwordKey);

    if (savedPassword != currentPassword) {
      return false;
    }

    await preferences.setString(_passwordKey, newPassword);
    return true;
  }

  static Future<void> logout() async {
    final preferences = await SharedPreferences.getInstance();

    // This removes only the session, not the registered account.
    await preferences.setBool(_loggedInKey, false);
  }

  static Future<String> getUserName() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_nameKey) ?? '';
  }

  static Future<String> getUserEmail() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_emailKey) ?? '';
  }

  static Future<String> getUserPhone() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_phoneKey) ?? '';
  }
  static Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_nameKey, name.trim());
    await preferences.setString(
      _emailKey,
      email.trim().toLowerCase(),
    );
    await preferences.setString(_phoneKey, phone.trim());
  }
}