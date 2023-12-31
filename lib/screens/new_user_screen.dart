import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/api_service.dart';


class NewUserScreen extends StatefulWidget {
  const NewUserScreen({Key? key}) : super(key: key);

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  bool status = true;

  late ConnectivityResult _connectionStatus;
  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isShowingDialog = false;

  @override
  void initState() {
    super.initState();
    _connectionStatus = ConnectivityResult.none;
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      _handleConnectivityChange(result);
    });
    
    _loadDraftUserData();
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none && !_isShowingDialog) {
      
      setState(() {
        _connectionStatus = ConnectivityResult.none;
        _showNoInternetDialog();
      });
    } else if (result != ConnectivityResult.none && _isShowingDialog) {
      
      setState(() {
        _connectionStatus = result;
        _hideNoInternetDialog();
      });
    } else {
      
      setState(() {
        _connectionStatus = result;
      });
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        _isShowingDialog = true;
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connection.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _isShowingDialog = false;
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _hideNoInternetDialog() {
    Navigator.of(context).pop();
    _isShowingDialog = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: genderController,
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            Row(
              children: [
                const Text('Status:'),
                Switch(
                  value: status,
                  onChanged: (value) {
                    setState(() {
                      status = value;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                
                if (!_isValidEmail(emailController.text)) {
                  
                  print('Invalid email format');
                  return;
                }

                
                if (_connectionStatus != ConnectivityResult.none) {
                 
                  final newUser = User(
                    id: 0,
                    name: nameController.text,
                    email: emailController.text,
                    gender: genderController.text,
                    status: status,
                  );

                  
                  await _saveDraftUserData(newUser);

                  
                  _checkAndCreateUser(newUser);
                } else {
                  
                  _showNoInternetDialog();
                }
              },
              child: const Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  // Load draft user data from shared preferences
  Future<void> _loadDraftUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('draftUserData');

    if (storedData != null) {
      final Map<String, dynamic> draftData = json.decode(storedData);
      setState(() {
        nameController.text = draftData['name'];
        emailController.text = draftData['email'];
        genderController.text = draftData['gender'];
        status = draftData['status'];
      });
    }
  }

  // Save draft user data to shared preferences
  Future<void> _saveDraftUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final formData = {
      'name': user.name,
      'email': user.email,
      'gender': user.gender,
      'status': user.status,
    };
    prefs.setString('draftUserData', json.encode(formData));
  }

  // Function to check internet connection, show dialog, and create user
  Future<void> _checkAndCreateUser(User user) async {
    if (_connectionStatus != ConnectivityResult.none) {
      try {
        await ApiService.createUser(user);
        Navigator.pop(context, true); // Signal success to the previous screen
      } catch (e) {
        // Handle the ApiException or other exceptions
        print('Error during user creation: $e');
      }
    } else {
      // Show a dialog if there is no internet connection
      _showNoInternetDialog();
    }
  }
}
