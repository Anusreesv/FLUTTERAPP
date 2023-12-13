import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveFormData(Map<String, dynamic> formData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('draftUserData', json.encode(formData));
  }

  static Future<Map<String, dynamic>> loadFormData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('draftUserData');
    return storedData != null ? json.decode(storedData) : {};
  }

  static Future<void> clearFormData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('draftUserData');
  }
}
