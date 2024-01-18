import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/api_service.dart';
import 'package:first_app/utils/local_storage.dart';

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
  bool _isInitialLoad = true;

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
    setState(() {
      _connectionStatus = result;
    });

    if (result == ConnectivityResult.none && !_isShowingDialog) {
      // No connection, show dialog
      _showNoInternetDialog();
    } else if (result != ConnectivityResult.none && _isShowingDialog) {
      // Connection restored, close dialog
      _hideNoInternetDialog();
    } else if (result != ConnectivityResult.none && !_isShowingDialog) {
      // Connection available, hide any existing dialog
      _hideNoInternetDialog();
    } else if (result == ConnectivityResult.none && _isShowingDialog) {
      // Connection lost, show dialog (if not already showing)
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    if (!_isShowingDialog) {
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
  }

  void _hideNoInternetDialog() {
    if (_isShowingDialog) {
      Navigator.of(context).pop();
      _isShowingDialog = false;
    }
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

                if (_connectionStatus == ConnectivityResult.none) {
                  _showNoInternetDialog();
                  return;
                }

                final newUser = User(
                  id: 0,
                  name: nameController.text,
                  email: emailController.text,
                  gender: genderController.text,
                  status: status,
                );

                await _saveDraftUserData(newUser);
                _checkAndCreateUser(newUser);
                _resetForm(); // Reset the form after successful creation
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

  Future<void> _loadDraftUserData() async {
    if (_isInitialLoad) {
      final formData = await LocalStorage.loadFormData();
      setState(() {
        nameController.text = formData['name'] ?? '';
        emailController.text = formData['email'] ?? '';
        genderController.text = formData['gender'] ?? '';
        status = formData['status'] ?? true;
      });

      _isInitialLoad = false;
    }
  }

  Future<void> _saveDraftUserData(User user) async {
    final formData = {
      'name': user.name,
      'email': user.email,
      'gender': user.gender,
      'status': user.status,
    };
    await LocalStorage.saveFormData(formData);
  }

  Future<void> _checkAndCreateUser(User user) async {
    if (_connectionStatus != ConnectivityResult.none) {
      try {
        await ApiService.createUser(user);
        Navigator.pop(context, true);
        _resetForm();
      } catch (e) {
        print('Error during user creation: $e');
        // Don't reset the form, show no internet dialog instead
        _showNoInternetDialog();
      }
    } else {
      _showNoInternetDialog();
    }
  }

  void _resetForm() {
    setState(() {
      nameController.text = '';
      emailController.text = '';
      genderController.text = '';
      status = true;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    // Save draft data when the form is closed or the app is paused
    _saveDraftUserData(User(
      id: 0,
      name: nameController.text,
      email: emailController.text,
      gender: genderController.text,
      status: status,
    ));
    super.dispose();
  }
}
