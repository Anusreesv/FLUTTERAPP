import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/api_service.dart';
import 'package:first_app/utils/connectivity_util.dart'; // Import connectivity_util.dart

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({Key? key}) : super(key: key);

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  bool status = true;

  @override
  void initState() {
    super.initState();
    // Load draft user data if available
    _loadDraftUserData();
  }

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
              decoration: const InputDecoration(labelText: 'Gender'),
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
                  id: 0,
                  name: nameController.text,
                  email: emailController.text,
                  gender: genderController.text,
                  status: status,
                );

                // Save draft user data
                await _saveDraftUserData(newUser);

                // Continue with user creation
                _checkAndCreateUser(newUser);
              },
              child: const Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  // Load draft user data from shared preferences
  Future<void> _loadDraftUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('draftUserData');

    if (storedData != null) {
      final Map<String, dynamic> draftData = json.decode(storedData);
      setState(() {
        nameController.text = draftData['name'];
        emailController.text = draftData['email'];
        genderController.text = draftData['gender'];
        status = draftData['status'];
      });
    }
  }

  // Save draft user data to shared preferences
  Future<void> _saveDraftUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final formData = {
      'name': user.name,
      'email': user.email,
      'gender': user.gender,
      'status': user.status,
    };
    prefs.setString('draftUserData', json.encode(formData));
  }

  // Function to check internet connection, show dialog, and create user
  Future<void> _checkAndCreateUser(User user) async {
    if (await ConnectivityUtil.hasConnection()) {
      try {
        await ApiService.createUser(user);
        Navigator.pop(context, true); // Signal success to the previous screen
      } catch (e) {
        // Handle the ApiException or other exceptions
        print('Error during user creation: $e');
      }
    } else {
      // Show a dialog if there is no internet connection
      ConnectivityUtil.showNoInternetDialog(context);
    }
  }
}
