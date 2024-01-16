import 'package:connectivity/connectivity.dart';
import 'package:first_app/utils/connectivity_util.dart';
import 'package:flutter/material.dart';
import 'package:first_app/utils/local_storage.dart';
import 'package:first_app/config.dart';
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
    
    LocalStorage.loadFormData().then((formData) {
      
    });
  }


  Future<void> updateUser(User updatedUser) async {
    try {
      print('updating user from home screen');
      print('calling update user');
      setState(() {
        
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
      body: ConnectivityWidget( 
        child: FutureBuilder<List<User>>(
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
                            
                            checkInternetConnection(() async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserDetailsScreen(userList[index]),
                                ),
                              );
                            });
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          checkInternetConnection(() async {
            await Navigator.push(
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
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<void> checkInternetConnection(Function callback) async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult != ConnectivityResult.none) {
    // If connected, execute the callback
    callback();
  } else {
    // If not connected, show a dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connection.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
}
