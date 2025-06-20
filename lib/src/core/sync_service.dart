import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'offline_database.dart';
import 'connectivity_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final OfflineDatabase _database = OfflineDatabase();
  final ConnectivityService _connectivity = ConnectivityService();
  final Dio _dio = Dio();
  
  Timer? _syncTimer;
  bool _isSyncing = false;
  final StreamController<SyncStatus> _syncStatusController = 
      StreamController<SyncStatus>.broadcast();

  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  Future<void> initialize() async {
    await _connectivity.initialize();
    
    // Listen to connectivity changes
    _connectivity.statusStream.listen((status) {
      if (status == ConnectionStatus.connected) {
        _scheduleSync();
      } else {
        _cancelSync();
      }
    });

    // Initial sync if connected
    if (await _connectivity.isConnected()) {
      _scheduleSync();
    }
  }

  void _scheduleSync() {
    _cancelSync();
    _syncTimer = Timer(const Duration(seconds: 2), () {
      _performSync();
    });
  }

  void _cancelSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<void> _performSync() async {
    if (_isSyncing) return;
    
    _isSyncing = true;
    _syncStatusController.add(SyncStatus.syncing);

    try {
      final queueItems = await _database.getSyncQueue(limit: 20);
      
      if (queueItems.isEmpty) {
        _syncStatusController.add(SyncStatus.idle);
        return;
      }

      int successCount = 0;
      int errorCount = 0;

      for (final item in queueItems) {
        try {
          final success = await _processSyncItem(item);
          if (success) {
            await _database.removeFromSyncQueue(item['id']);
            successCount++;
          } else {
            errorCount++;
            await _updateRetryCount(item['id'], item['retry_count']);
          }
        } catch (e) {
          errorCount++;
          await _updateRetryCount(item['id'], item['retry_count']);
        }
      }

      if (errorCount == 0) {
        _syncStatusController.add(SyncStatus.completed);
      } else if (successCount > 0) {
        _syncStatusController.add(SyncStatus.partial);
      } else {
        _syncStatusController.add(SyncStatus.failed);
      }

    } catch (e) {
      _syncStatusController.add(SyncStatus.failed);
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> _processSyncItem(Map<String, dynamic> item) async {
    final operation = item['operation'] as String;
    final endpoint = item['endpoint'] as String;
    final data = item['data'] as Map<String, dynamic>;
    final retryCount = item['retry_count'] as int;

    if (retryCount >= 3) {
      return false; // Max retries reached
    }

    try {
      Response response;
      
      switch (operation.toLowerCase()) {
        case 'post':
          response = await _dio.post(endpoint, data: data);
          break;
        case 'put':
          response = await _dio.put(endpoint, data: data);
          break;
        case 'delete':
          response = await _dio.delete(endpoint, data: data);
          break;
        default:
          return false;
      }

      return response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (e) {
      return false;
    }
  }

  Future<void> _updateRetryCount(int id, int currentRetryCount) async {
    await _database.updateSyncQueueItem(id, {'retry_count': currentRetryCount + 1});
  }

  // ===== PUBLIC SYNC METHODS =====

  Future<void> syncAssetCreation(Map<String, dynamic> assetData) async {
    if (await _connectivity.isConnected()) {
      // Try to sync immediately if online
      try {
        final response = await _dio.post('/api/v1/assets/generate', data: assetData);
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return; // Success, no need to queue
        }
      } catch (e) {
        // Fall through to offline queue
      }
    }

    // Queue for offline sync
    await _database.addToSyncQueue(
      operation: 'POST',
      endpoint: '/api/v1/assets/generate',
      data: assetData,
      priority: 1,
    );
  }

  Future<void> syncAssetUpdate(int assetId, Map<String, dynamic> updateData) async {
    if (await _connectivity.isConnected()) {
      try {
        final response = await _dio.put('/api/v1/assets/$assetId', data: updateData);
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return;
        }
      } catch (e) {
        // Fall through to offline queue
      }
    }

    await _database.addToSyncQueue(
      operation: 'PUT',
      endpoint: '/api/v1/assets/$assetId',
      data: updateData,
      priority: 2,
    );
  }

  Future<void> syncAssetRating(int assetId, Map<String, dynamic> ratingData) async {
    if (await _connectivity.isConnected()) {
      try {
        final response = await _dio.post('/api/v1/assets/$assetId/rate', data: ratingData);
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return;
        }
      } catch (e) {
        // Fall through to offline queue
      }
    }

    await _database.addToSyncQueue(
      operation: 'POST',
      endpoint: '/api/v1/assets/$assetId/rate',
      data: ratingData,
      priority: 3,
    );
  }

  Future<void> syncCommunityTheme(Map<String, dynamic> themeData) async {
    if (await _connectivity.isConnected()) {
      try {
        final response = await _dio.post('/api/v1/community/themes', data: themeData);
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return;
        }
      } catch (e) {
        // Fall through to offline queue
      }
    }

    await _database.addToSyncQueue(
      operation: 'POST',
      endpoint: '/api/v1/community/themes',
      data: themeData,
      priority: 2,
    );
  }

  Future<void> syncLicensePurchase(int licenseId, Map<String, dynamic> purchaseData) async {
    if (await _connectivity.isConnected()) {
      try {
        final response = await _dio.post('/api/v1/licenses/$licenseId/purchase', data: purchaseData);
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          return;
        }
      } catch (e) {
        // Fall through to offline queue
      }
    }

    await _database.addToSyncQueue(
      operation: 'POST',
      endpoint: '/api/v1/licenses/$licenseId/purchase',
      data: purchaseData,
      priority: 1, // High priority for purchases
    );
  }

  // ===== UTILITY METHODS =====

  Future<int> getPendingSyncCount() async {
    return await _database.getSyncQueueCount();
  }

  Future<void> forceSync() async {
    if (await _connectivity.isConnected()) {
      await _performSync();
    }
  }

  Future<void> clearSyncQueue() async {
    // This should be used carefully - only for testing or user request
    final queueItems = await _database.getSyncQueue(limit: 1000);
    for (final item in queueItems) {
      await _database.removeFromSyncQueue(item['id']);
    }
  }

  void dispose() {
    _cancelSync();
    _syncStatusController.close();
  }
}

enum SyncStatus {
  idle,
  syncing,
  completed,
  partial,
  failed,
}

// Riverpod providers
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});

final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  return syncService.syncStatusStream;
});

final pendingSyncCountProvider = FutureProvider<int>((ref) async {
  final syncService = ref.watch(syncServiceProvider);
  return await syncService.getPendingSyncCount();
}); 