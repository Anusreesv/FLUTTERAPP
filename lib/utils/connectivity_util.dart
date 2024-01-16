import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

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
      _handleConnectivityChange(result);
    });
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
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        _isShowingDialog = true;
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: _connectionStatus == ConnectivityResult.none
              ? const Text('Please check your internet connection.')
              : const Text('Internet connection lost.'),
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
