import 'package:first_app/config.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/api_service.dart';
import 'package:first_app/screens/new_user_screen.dart';
import 'package:first_app/screens/user_details_screen.dart';
import 'package:first_app/widgets/user_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<User>> users;

  @override
  void initState() {
    super.initState();
    users = ApiService.fetchUsers('${AppConfig.baseUrl}${AppConfig.userListEndpoint}');
  }

  Future<void> updateUser(User updatedUser) async {
    try {
      await ApiService.updateUser(updatedUser);
      setState(() {
        users = ApiService.fetchUsers('${AppConfig.baseUrl}${AppConfig.userListEndpoint}');
      });
    } catch (e) {
      print('Failed to update user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userList = snapshot.data;
            final isDesktop = MediaQuery.of(context).size.width > 600;

            return isDesktop
                ? GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                    ),
                    padding: const EdgeInsets.all(2.0),
                    itemCount: userList?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: UserListItem(userList![index], onUpdate: updateUser),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: userList?.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDetailsScreen(userList[index]),
                            ),
                          );
                        },
                        child: UserListItem(userList![index], onUpdate: updateUser),
                      );
                    },
                  );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewUserScreen()),
          ).then((value) {
            if (value == true) {
              setState(() {
                users = ApiService.fetchUsers('${AppConfig.baseUrl}${AppConfig.userListEndpoint}');
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
