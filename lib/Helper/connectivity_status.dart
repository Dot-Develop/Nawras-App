import 'dart:async';

import 'package:connectivity/connectivity.dart';

enum ConnectivityStatus { WiFi, Cellular, Offline }

class ConnectivityService {
  // Create our public controller
  StreamController<ConnectivityStatus> _connectionStatusController =
      StreamController<ConnectivityStatus>();

  Stream<ConnectivityStatus> get connectionStatusControllerStream => _connectionStatusController.stream;

  ConnectivityService() {
    // Subscribe to the connectivity Chanaged Steam
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Use Connectivity() here to gather more info if you need t

      _connectionStatusController.add(_getStatusFromResult(result));
    });
  }

  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}

