import 'package:first_app/models/user.dart';
import 'package:flutter/material.dart';

class UserViewScreen extends StatefulWidget {
  final User user;

  const UserViewScreen(this.user, {Key? key}) : super(key: key);

  @override
  _UserViewScreenState createState() => _UserViewScreenState();
}

class _UserViewScreenState extends State<UserViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit form
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserEditForm(user: widget.user),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.user.name}'),
            Text('Email: ${widget.user.email}'),
            Text('Status: ${widget.user.status ? 'Active' : 'Inactive'}'),
            Text('Gender: ${widget.user.gender}'), // Display gender
          ],
        ),
      ),
    );
  }
}

class UserEditForm extends StatefulWidget {
  final User user;

  const UserEditForm({Key? key, required this.user}) : super(key: key);

  @override
  _UserEditFormState createState() => _UserEditFormState();
}

class _UserEditFormState extends State<UserEditForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late bool isUserActive;
  late TextEditingController genderController; // Add gender controller

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    isUserActive = widget.user.status;
    genderController = TextEditingController(text: widget.user.gender); // Initialize gender controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
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
              TextFormField(
                controller: genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  // Add gender validation logic if needed
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
                    // Save the edited user information
                    final editedUser = User(
                      id: widget.user.id,
                      name: nameController.text,
                      email: emailController.text,
                      status: isUserActive,
                      gender: genderController.text, // Set gender from controller
                    );

                    // Implement API request to update user information
                    // You can call the API service to update the user here
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
