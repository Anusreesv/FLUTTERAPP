import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:first_app/models/user.dart';
import 'package:first_app/config.dart';

class ApiService {
  static const String baseUrl = AppConfig.baseUrl;
  static const String accessToken = 'd6fdcd7f7f6dd7c967d99cad24745cf7a9e6b2113e59968a230cc1574471168e';

  static Future<List<User>> fetchUsers(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final usersData = List<Map<String, dynamic>>.from(data);
      final users = usersData.map((userData) => User.fromJson(userData)).toList();
      return users;
    } else {
      throw Exception('Failed to load user data. Status code: ${response.statusCode}');
    }
  }

  static Future<void> createUser(User user) async {
    const String createUserUrl = '$baseUrl/users';

    final Map<String, dynamic> userData = {
      'name': user.name,
      'email': user.email,
      'status': user.status,
    };

    try {
      final response = await http.post(
        Uri.parse(createUserUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        print('User created successfully');
      } else {
        throw Exception('Failed to create user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception during user creation: $e');
    }
  }

  static Future<void> updateUser(User user) async {
    final String updateUserUrl = '$baseUrl/users/${user.id}';

    final Map<String, dynamic> userData = {
      'name': user.name,
      'email': user.email,
      'status': user.status,
    };

    try {
      final response = await http.put(
        Uri.parse(updateUserUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(userData),
      );

    if (response.statusCode == 200) {
        print('User updated successfully');
      } else {
        _handleUpdateError(response.statusCode, user.id);
      }
    } catch (e) {
      throw Exception('Exception during user update: $e');
    }
  }

  // Private method to handle update error based on status code
  static void _handleUpdateError(int statusCode, int userId) {
    if (statusCode == 404) {
      throw Exception('User with ID $userId not found. Cannot update non-existent user.');
    } else {
      throw Exception('Failed to update user. Status code: $statusCode');
    }
  }
}

