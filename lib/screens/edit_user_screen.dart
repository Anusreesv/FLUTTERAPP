import 'package:flutter/material.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/api_service.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  const EditUserScreen(this.user, {Key? key}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late String _editedName;
  late String _editedEmail;
  bool _editedStatus = false;

  @override
  void initState() {
    super.initState();
    _editedName = widget.user.name;
    _editedEmail = widget.user.email;
    _editedStatus = widget.user.status;
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
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              initialValue: _editedName,
              onChanged: (value) {
                setState(() {
                  _editedName = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              initialValue: _editedEmail,
              onChanged: (value) {
                setState(() {
                  _editedEmail = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Status'),
              value: _editedStatus,
              onChanged: (value) {
                setState(() {
                  _editedStatus = value;
                });
              },
            ),
            IconButton(
  icon: const Icon(Icons.edit),
  onPressed: () {
    Navigator.pushNamed(context, '/editUser');
  },
),

            ElevatedButton(
              onPressed: () async {
                User editedUser = User(
                  id: widget.user.id,
                  name: _editedName,
                  email: _editedEmail,
                  status: _editedStatus,
                );

                try {
                  await ApiService.updateUser(editedUser);
                  Navigator.pop(context);
                } catch (e) {
                  // Handle error, show a message or log it
                  print('Failed to update user: $e');
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
