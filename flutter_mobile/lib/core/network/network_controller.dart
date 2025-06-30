import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController { // Add this line

  NetworkController() {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  final Connectivity _connectivity = Connectivity();
  void Function(bool isConnected)? onConnectionChanged;

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final isConnected = !results.contains(ConnectivityResult.none);
    onConnectionChanged?.call(isConnected);
  }
}

