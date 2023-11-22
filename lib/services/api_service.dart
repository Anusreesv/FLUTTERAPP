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
      throw Exception('Failed to load user data');
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
          'Authorization': 'Bearer $accessToken ', // Uncomment and replace with your API key if required
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        print('User created successfully');
      } else {
        print('Failed to create user. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during user creation: $e');
      throw Exception('Failed to create user');
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
        print('Failed to update user. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update user');
      }
    } catch (e) {
      print('Exception during user update: $e');
      throw Exception('Failed to update user');
    }
  }
}


