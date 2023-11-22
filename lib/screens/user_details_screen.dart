import 'package:flutter/material.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/screens/edit_user_screen.dart'; 

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: GestureDetector(
        
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditUserScreen(user),
            ),
            
          );
        },
      ),
      
    );
  }
}
