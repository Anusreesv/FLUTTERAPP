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
          
          final updatedUser = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditUserScreen(user: user)),
          );

          
          if (updatedUser != null) {
            
            onUpdate(updatedUser);
          }
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
