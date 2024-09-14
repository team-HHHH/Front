import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveToken(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String?> getToken(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<void> deleteToken(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}