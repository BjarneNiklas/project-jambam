import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectionStatus {
  connected,
  disconnected,
  connecting,
}

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectionStatus> _statusController = 
      StreamController<ConnectionStatus>.broadcast();

  Stream<ConnectionStatus> get statusStream => _statusController.stream;
  ConnectionStatus _currentStatus = ConnectionStatus.connecting;

  ConnectionStatus get currentStatus => _currentStatus;

  Future<void> initialize() async {
    // Check initial connectivity status
    await _checkConnectivity();
    
    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      _updateStatus(result);
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateStatus(result);
    } catch (e) {
      _updateStatus(ConnectivityResult.none);
    }
  }

  void _updateStatus(ConnectivityResult result) {
    ConnectionStatus newStatus;
    
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
        newStatus = ConnectionStatus.connected;
        break;
      case ConnectivityResult.none:
        newStatus = ConnectionStatus.disconnected;
        break;
      default:
        newStatus = ConnectionStatus.connecting;
    }

    if (_currentStatus != newStatus) {
      _currentStatus = newStatus;
      _statusController.add(newStatus);
    }
  }

  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _statusController.close();
  }
}

// Riverpod providers
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final connectionStatusProvider = StreamProvider<ConnectionStatus>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return connectivityService.statusStream;
});

final isOnlineProvider = Provider<bool>((ref) {
  final status = ref.watch(connectionStatusProvider);
  return status.when(
    data: (status) => status == ConnectionStatus.connected,
    loading: () => false,
    error: (_, __) => false,
  );
}); 