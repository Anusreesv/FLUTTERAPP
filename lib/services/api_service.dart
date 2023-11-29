import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:first_app/models/user.dart';
import 'package:first_app/config.dart';

class ApiService {
  static const String baseUrl = AppConfig.baseUrl;
  static const String accessToken = 'd6fdcd7f7f6dd7c967d99cad24745cf7a9e6b2113e59968a230cc1574471168e';

  static Future<List<User>> fetchUsers(String url) async {
    final response = await http.get(Uri.parse('$baseUrl/public/v2/users'));
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
  const String createUserUrl = '$baseUrl/public/v2/users';

  final Map<String, dynamic> userData = {
    'name': user.name,
    'email': user.email,
    'gender': user.gender,
    'status': user.status,
  };

  print('Create User Request Payload: ${jsonEncode(userData)}');

  try {
    final response = await http.post(
      Uri.parse(createUserUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(userData),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      print('User created successfully');
    } else {
      throw ApiException('Failed to create user. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error during user creation: $e');
    throw ApiException('Exception during user creation: $e');
  }
}


  static Future<void> updateUser(User user) async {
    final String updateUserUrl = '$baseUrl/public/v2/users/${user.id}';

    final Map<String, dynamic> userData = {
      'name': user.name,
      'email': user.email,
      'gender':user.gender,
      'status': user.status.toString(), // Convert boolean to string
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

      print('Request URL: $updateUserUrl');
      print('Request Headers: ${{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      }}');
      print('Request Body: ${jsonEncode(userData)}');

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

       if (response.statusCode == 200 || response.statusCode == 422) {
  print('User updated successfully');
  // Update user details in your app here
  user.name = userData['name'];
  user.email = userData['email'];
  user.gender= userData['gender'];
  user.status = userData['status'] == 'true'; // Convert string to boolean

  
} else {
  _handleUpdateError(response.statusCode, response.body, user);
}

  } catch (e) {
    throw ApiException('Exception during user update: $e');
  }
}

  static void _handleUpdateError(int statusCode, String responseBody, User user) {
    // Implement your error handling logic here
  }

  static void _handleUpdateValidationErrors(String responseBody, User user) {
    final List<dynamic> errors = jsonDecode(responseBody);

    if (errors.isNotEmpty) {
      for (var error in errors) {
        final String field = error['field'];
        final String message = error['message'];
        final String friendlyErrorMessage = 'Validation error: $field $message';
        print(friendlyErrorMessage);
      }

      // Proceeding with user update despite validation errors
      print('Proceeding with user update despite validation errors');

      // Update user details in your app here
      user.name = user.name; // Replace with actual logic based on your requirements
      user.email = user.email;
      user.gender =user.gender;
      user.status = user.status; // Update as needed
    } else {
      print('Unknown validation error format: $errors');
      throw ApiException('Failed to update user. Status code: 422');
    }
  }
}

// Custom exceptions
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class UserNotFoundException implements Exception {
  final String message;
  UserNotFoundException(this.message);
}
