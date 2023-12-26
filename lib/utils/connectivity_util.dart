import 'dart:async';
import 'package:first_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConnectivityWidget(
        child: const HomeScreen(),
      ),
    );
  }
}

class ConnectivityWidget extends StatefulWidget {
  final Widget child;

  const ConnectivityWidget({Key? key, required this.child}) : super(key: key);

  @override
  _ConnectivityWidgetState createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  late ConnectivityResult _connectionStatus;
  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isShowingDialog = false;

  @override
  void initState() {
    super.initState();
    _connectionStatus = ConnectivityResult.none;
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectionStatus = result;
      });
      _handleConnectivityChange(result);
    });
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none && !_isShowingDialog) {
      // No connection, show dialog
      _showNoInternetDialog();
    } else if (result != ConnectivityResult.none && _isShowingDialog) {
      // Connection restored, close dialog
      _hideNoInternetDialog();
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
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}


// class ConnectivityUtil {
//   static Future<bool> hasConnection() async {
//     var connectivityResult = (Connectivity().onConnectivityChanged.listen);
//     print(ConnectivityResult);
//     return connectivityResult != ConnectivityResult.none;
//   }

//   static void showNoInternetDialog(BuildContext context) {
//     showDialog(
//       context: context,
//      builder: (context) => AlertDialog(
//         title: const Text('No Internet Connection'),
//         content: const Text('Please check your internet connection.'),

//         actions: <Widget>[
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }

