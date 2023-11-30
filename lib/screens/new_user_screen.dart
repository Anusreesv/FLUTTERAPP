
import 'package:flutter/material.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/api_service.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({Key? key}) : super(key: key);

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}


class _NewUserScreenState extends State<NewUserScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController(); // Add gender controller
  bool status = true; // Default status is active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: genderController,
              decoration: const InputDecoration(labelText: 'Gender'), // Add gender field
            ),
            Row(
              children: [
                const Text('Status:'),
                Switch(
                  value: status,
                  onChanged: (value) {
                    setState(() {
                      status = value;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                // Validate email format before creating a new user
                if (!_isValidEmail(emailController.text)) {
                  // Display an error message or handle the invalid email format
                  print('Invalid email format');
                  return;
                }

                // Create a new user and refresh the user list
                final newUser = User(
                  id: 0, // Set to 0 or null for new users
                  name: nameController.text,
                  email: emailController.text,
                  gender: genderController.text, // Get gender from controller
                  status: true,
                );

                try {
      await ApiService.createUser(newUser);
      Navigator.pop(context, true); // Signal success to the previous screen
    } catch (e) {
      // Handle the ApiException or other exceptions
      print('Error during user creation: $e');
    }
  },
              child: const Text('Create User'),
            ),
          ],
        ),  
      ),
    );
  }

  bool _isValidEmail(String email) {
    // Simple email format validation
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegExp.hasMatch(email);
  }
}
