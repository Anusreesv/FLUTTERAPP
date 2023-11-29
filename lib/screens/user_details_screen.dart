import 'package:flutter/material.dart';
import 'package:first_app/models/user.dart';

class UserDetailsScreen extends StatelessWidget {
  final User user;

  const UserDetailsScreen(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${user.id}'),
            Text('Name: ${user.name}'),
            Text('Email: ${user.email}'),
            Text('Status: ${user.status ? 'Active' : 'Inactive'}'),
          ],
        ),
      ),
    );
  }
}
