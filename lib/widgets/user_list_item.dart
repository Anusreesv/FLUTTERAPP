import 'package:flutter/material.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/screens/edit_user_screen.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final Function(User) onUpdate;

  const UserListItem(this.user, {Key? key, required this.onUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: GestureDetector(
        onTap: () async {
          // Navigate to the edit screen, passing the user details
          final updatedUser = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditUserScreen(user: user)),
          );

          // Check if the user was updated
          if (updatedUser != null) {
            // Call the provided onUpdate function to update the user
            onUpdate(updatedUser);
          }
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
