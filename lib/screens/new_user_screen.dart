import 'package:first_app/services/api_service.dart';
import 'package:flutter/material.dart';
// import 'api_service.dart'; // Import your API service
import 'package:first_app/models/user.dart'; // Import your User model

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isUserActive = true; // Default to active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Active User'),
                value: isUserActive,
                onChanged: (value) {
                  setState(() {
                    isUserActive = value;
                  });
                },
              ),
              ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      // Create a new user object
      final newUser = User(
        id: 0, // You can assign 0 or null for a new user
        name: nameController.text,
        email: emailController.text,
        status: isUserActive,
      );

      // Call your API service to create the new user
      ApiService.createUser(newUser).then((createdUser) {
        // Handle the response
        if (createdUser!= null) {
          // User was successfully created, you can show a success message or navigate back
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User created successfully'),
            ),
          );

          // Navigate back to the previous screen
          Navigator.pop(context);
        } else {
          // Handle any errors or display an error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create user'),
            ),
          );
        }
      }).catchError((error) {
        // Handle API error if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('API request error: $error'),
          ),
        );
      });
    }
  },
  child: const Text('Create User'),
),

            ],
          ),
        ),
      ),
    );
  }
}
