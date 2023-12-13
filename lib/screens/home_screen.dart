import 'package:flutter/material.dart';
import 'package:first_app/config.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/api_service.dart';
import 'package:first_app/screens/new_user_screen.dart';
import 'package:first_app/screens/user_details_screen.dart';
import 'package:first_app/widgets/user_list_item.dart';
import 'package:first_app/utils/local_storage.dart';
import 'package:first_app/utils/connectivity_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<User>> users;

  @override
  void initState() {
    // Initialize state if needed
    super.initState();
    // Load form data from local storage when the screen is opened
    LocalStorage.loadFormData().then((formData) {
      // Use formData as needed
    });

    // Check internet connection when the screen is opened
    checkInternetConnection();
  }

  Future<void> updateUser(User updatedUser) async {
    try {
      print('updating user from home screen');
      print('calling update user');
      setState(() {
        // Update the state if needed
      });
    } catch (e) {
      print('Failed to update user: $e');
    }
  }

  Future<void> checkInternetConnection() async {
    if (!(await ConnectivityUtil.hasConnection())) {
      ConnectivityUtil.showNoInternetDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: FutureBuilder<List<User>>(
        future: ApiService.fetchUsers(
          '${AppConfig.baseUrl}${AppConfig.userListEndpoint}',
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userList = snapshot.data;
            final isDesktop = MediaQuery.of(context).size.width > 600;

            return isDesktop
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      int width = constraints.maxWidth ~/ 400;
                      final crossAxisCounts = width == 0 ? 1 : width;

                      return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCounts,
                          mainAxisExtent: 100,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        padding: const EdgeInsets.all(2.0),
                        itemCount: userList?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: const Color.fromARGB(255, 255, 64, 169),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: UserListItem(
                                userList![index],
                                onUpdate: updateUser,
                              ),
                            ),
                          );
                        },
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
                              builder: (context) =>
                                  UserDetailsScreen(userList[index]),
                            ),
                          );
                        },
                        child: UserListItem(
                          userList![index],
                          onUpdate: updateUser,
                        ),
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
                users = ApiService.fetchUsers(
                    '${AppConfig.baseUrl}${AppConfig.userListEndpoint}');
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
