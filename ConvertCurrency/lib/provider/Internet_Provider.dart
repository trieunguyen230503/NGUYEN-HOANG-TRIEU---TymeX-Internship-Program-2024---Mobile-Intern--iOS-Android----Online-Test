import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetProvider extends ChangeNotifier {
  bool _hasInternet = false;

  bool get hasInternet => _hasInternet;

  InternetProvider() {
    _initializeConnectionListener();
  }

  void _initializeConnectionListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      bool currentConnection = result != ConnectivityResult.none;
      if (currentConnection != _hasInternet) {
        _hasInternet = currentConnection;
        notifyListeners();
      }
    });
  }
}
