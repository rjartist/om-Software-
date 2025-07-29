import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gkmarts/Services/Connectivity/connectivity_service.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider extends ChangeNotifier {
  final ConnectivityService _service = ConnectivityService();
  late StreamSubscription _subscription;
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    _init();
  }

  void _init() {
    _subscription = _service.connectivityStream.listen((result) {
      _isOnline = result != ConnectivityResult.none;
      notifyListeners();
    });
    _checkInitialStatus();
  }

  Future<void> _checkInitialStatus() async {
    _isOnline = await _service.isConnected;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
