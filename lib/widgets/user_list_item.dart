import 'package:first_app/models/user.dart';
import 'package:flutter/material.dart';
// import 'models/user.dart';

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: const Icon(Icons.edit), // Add an edit icon
      // Implement onTap handler to view user details
    );
  }
}
