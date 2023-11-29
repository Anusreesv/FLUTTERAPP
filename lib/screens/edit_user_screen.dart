import 'package:flutter/material.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/api_service.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  const EditUserScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController genderController; // Add gender controller
  late bool status;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    genderController = TextEditingController(text: widget.user.gender); // Initialize gender controller
    status = widget.user.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
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
                // Update the user and refresh the user list
                final updatedUser = User(
                  id: widget.user.id,
                  name: nameController.text,
                  email: emailController.text,
                  gender: genderController.text, // Get gender from controller
                  status: status,
                );

                await ApiService.updateUser(updatedUser);

                // Update the local user object in the widget
                setState(() {
                  widget.user.name = updatedUser.name;
                  widget.user.email = updatedUser.email;
                  widget.user.gender = updatedUser.gender;
                  widget.user.status = updatedUser.status;
                });

                Navigator.pop(context); // Return to the previous screen
              },
              child: const Text('Update User'),
            ),
          ],
        ),
      ),
    );
  }
}
