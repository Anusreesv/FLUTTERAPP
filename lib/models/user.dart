import 'package:first_app/screens/home_screen.dart';

class User extends HomeScreen {
  const User({super.key, 
    required this.id,
    required this.name,
    required this.email,
    required this.status,
  });

  final int id;
  final String name;
  final String email;
  final bool status;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] as String,
      email: json['email'] as String,
      status: json['status'] != null && json['status'].toLowerCase() == 'active',
    );
  }
}


