import 'package:first_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/screens/edit_user_screen.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/editUser': (context) => const EditUserScreen(user: User(id: 1, name: "John", email: "john@example.com", status: false)),
        // Add other routes as needed
      },
    );
  }
}