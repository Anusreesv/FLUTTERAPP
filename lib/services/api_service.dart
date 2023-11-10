import 'dart:convert';
import 'package:first_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:first_app/config.dart';
// import 'models/user.dart';

class ApiService {
  static const String baseUrl = AppConfig.baseUrl;

  static Future<List<User>> fetchUsers(String s) async {
    final response = await http.get(Uri.parse('$baseUrl${AppConfig.userListEndpoint}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final usersData = List<Map<String, dynamic>>.from(data['data']);
      final users = usersData.map((userData) => User.fromJson(userData)).toList();
      return users;
    } else {
      throw Exception('Failed to load user data');
    }
  }


  static Future<User> createUser(User user) async {
  const String createUserUrl = '$baseUrl/users';

  final Map<String, dynamic> userData = {
    'name': user.name,
    'email': user.email,
    'status': user.status,
  };

  final response = await http.post(
    Uri.parse(createUserUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer YOUR_API_KEY',
    },
    body: jsonEncode(userData),
  );

  if (response.statusCode == 201) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    final createdUser = User.fromJson(responseData['data']);
    return createdUser;
  } else {
    throw Exception('Failed to create user');
  }
}

}


