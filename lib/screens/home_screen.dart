import 'package:flutter/material.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/api_service.dart';
import 'package:first_app/widgets/user_list_item.dart';
import 'package:first_app/config.dart';

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
                    ),
                    itemCount: userList?.length,
                    itemBuilder: (context, index) {
                      return UserListItem(userList![index]);
                    },
                  )
                : ListView.builder(
                    itemCount: userList?.length,
                    itemBuilder: (context, index) {
                      return UserListItem(userList![index]);
                    },
                  );
          }
        },
      ),
    );
  }
}
