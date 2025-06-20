import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:project_jambam/src/core/connectivity_service.dart';
import 'package:project_jambam/src/core/offline_database.dart';
import 'package:project_jambam/src/core/sync_service.dart';

class EnhancedApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';
  
  // Singleton pattern
  static final EnhancedApiService _instance = EnhancedApiService._internal();
  factory EnhancedApiService() => _instance;
  EnhancedApiService._internal();

  late final Dio _dio;
  late final OfflineDatabase _database;
  late final ConnectivityService _connectivity;
  late final SyncService _syncService;

  // Cache options
  static const Duration _cacheDuration = Duration(hours: 24);
  static const Duration _shortCacheDuration = Duration(minutes: 30);

  Future<void> initialize() async {
    _database = OfflineDatabase();
    _connectivity = ConnectivityService();
    _syncService = SyncService();

    await _connectivity.initialize();
    await _syncService.initialize();

    // Initialize Dio with interceptors
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add cache interceptor only on mobile platforms
    if (!kIsWeb) {
      final cacheStore = HiveCacheStore(
        await _getCacheDirectory(),
        hiveBoxName: 'jambam_cache',
      );

      final cacheOptions = CacheOptions(
        store: cacheStore,
        policy: CachePolicy.request,
        hitCacheOnErrorExcept: [401, 403],
        maxStale: const Duration(days: 7),
        priority: CachePriority.normal,
        keyBuilder: CacheOptions.defaultCacheKeyBuilder,
        allowPostMethod: false,
      );

      _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    }

    // Add connectivity interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Check connectivity before making request
        if (!await _connectivity.isConnected()) {
          // Try to get from cache or offline database
          final cachedResponse = await _getCachedResponse(options.path);
          if (cachedResponse != null) {
            return handler.resolve(cachedResponse);
          }
          
          // If no cache, queue for later sync
          await _queueForSync(options);
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'No internet connection',
              type: DioExceptionType.connectionError,
            ),
          );
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Handle offline scenarios
        if (error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.connectionTimeout) {
          
          // Try to get from offline database
          final offlineData = await _getOfflineData(error.requestOptions.path);
          if (offlineData != null) {
            return handler.resolve(Response(
              requestOptions: error.requestOptions,
              data: offlineData,
              statusCode: 200,
            ));
          }
        }
        handler.next(error);
      },
    ));
  }

  Future<String> _getCacheDirectory() async {
    if (kIsWeb) {
      // On web, use a virtual path since we can't access the file system directly
      return '/cache';
    } else {
      // On mobile, use the actual documents directory
      final dir = await getApplicationDocumentsDirectory();
      return '${dir.path}/cache';
    }
  }

  Future<Response?> _getCachedResponse(String path) async {
    // Implementation for getting cached response
    return null;
  }

  Future<void> _queueForSync(RequestOptions options) async {
    // Queue the request for later sync
    await _database.addToSyncQueue(
      operation: options.method,
      endpoint: options.path,
      data: options.data ?? {},
      priority: _getPriorityForEndpoint(options.path),
    );
  }

  int _getPriorityForEndpoint(String path) {
    if (path.contains('/purchase') || path.contains('/buy')) return 1;
    if (path.contains('/generate') || path.contains('/upload')) return 2;
    if (path.contains('/rate') || path.contains('/comment')) return 3;
    return 4;
  }

  Future<Map<String, dynamic>?> _getOfflineData(String path) async {
    // Get data from offline database based on path
    if (path.contains('/assets')) {
      return await _getOfflineAssets();
    }
    return null;
  }

  Future<Map<String, dynamic>?> _getOfflineAssets() async {
    final assets = await _database.getAssets(isPublic: true, limit: 20);
    return {'data': assets};
  }

  // ===== ASSET GENERATION =====

  Future<Map<String, dynamic>> generateAsset({
    required String prompt,
    required String style,
    String quality = 'standard',
    String outputFormat = 'glb',
    List<String> animations = const [],
  }) async {
    final data = {
      'prompt': prompt,
      'style': style,
      'quality': quality,
      'output_format': outputFormat,
      'animation': animations,
    };

    try {
      final response = await _dio.post('/assets/generate', data: data);
      return response.data;
    } catch (e) {
      // Queue for offline sync
      await _syncService.syncAssetCreation(data);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getJobStatus(String jobId) async {
    final response = await _dio.get('/assets/jobs/$jobId');
    return response.data;
  }

  Future<Map<String, dynamic>> uploadFile({
    required String filePath,
    required String fileName,
    List<String> animations = const [],
    String convertTo = 'glb',
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      'animation': jsonEncode(animations),
      'convert_to': convertTo,
    });

    try {
      final response = await _dio.post('/assets/upload', data: formData);
      return response.data;
    } catch (e) {
      // Queue for offline sync
      await _database.addToSyncQueue(
        operation: 'POST',
        endpoint: '/assets/upload',
        data: {
          'file_path': filePath,
          'file_name': fileName,
          'animation': animations,
          'convert_to': convertTo,
        },
        priority: 1,
      );
      rethrow;
    }
  }

  // ===== COMMUNITY FEATURES =====

  Future<List<Map<String, dynamic>>> getPublicAssets({
    int skip = 0,
    int limit = 20,
  }) async {
    final cacheOptions = CacheOptions(
      store: HiveCacheStore(
        await _getCacheDirectory(),
        hiveBoxName: 'jambam_cache',
      ),
      policy: CachePolicy.forceCache,
      maxStale: _shortCacheDuration,
    );

    try {
      final response = await _dio.get(
        '/assets',
        queryParameters: {'skip': skip, 'limit': limit},
        options: cacheOptions.toOptions(),
      );
      
      final List<dynamic> data = response.data;
      final assets = data.cast<Map<String, dynamic>>();
      
      // Store in offline database
      for (final asset in assets) {
        await _database.insertAsset(asset);
      }
      
      return assets;
    } catch (e) {
      // Return from offline database
      return await _database.getAssets(isPublic: true, limit: limit, offset: skip);
    }
  }

  Future<Map<String, dynamic>> getAssetDetails(int assetId) async {
    final cacheOptions = CacheOptions(
      store: HiveCacheStore(
        await _getCacheDirectory(),
        hiveBoxName: 'jambam_cache',
      ),
      policy: CachePolicy.forceCache,
      maxStale: _cacheDuration,
    );

    try {
      final response = await _dio.get(
        '/assets/$assetId',
        options: cacheOptions.toOptions(),
      );
      
      final asset = response.data;
      await _database.insertAsset(asset);
      
      return asset;
    } catch (e) {
      return await _database.getAssetById(assetId) ?? {};
    }
  }

  Future<Map<String, dynamic>> rateAsset({
    required int assetId,
    required int score,
    required int userId,
  }) async {
    final data = {
      'score': score,
      'user_id': userId,
    };

    try {
      final response = await _dio.post('/assets/$assetId/rate', data: data);
      return response.data;
    } catch (e) {
      await _syncService.syncAssetRating(assetId, data);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addTagsToAsset({
    required int assetId,
    required List<String> tags,
  }) async {
    final data = {'tags': tags};

    try {
      final response = await _dio.post('/assets/$assetId/tags', data: data);
      return response.data;
    } catch (e) {
      await _database.addToSyncQueue(
        operation: 'POST',
        endpoint: '/assets/$assetId/tags',
        data: data,
        priority: 3,
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> remixAsset({
    required int assetId,
    required String prompt,
    required String style,
    String quality = 'standard',
  }) async {
    final data = {
      'prompt': prompt,
      'style': style,
      'quality': quality,
    };

    try {
      final response = await _dio.post('/assets/$assetId/remix', data: data);
      return response.data;
    } catch (e) {
      await _syncService.syncAssetCreation(data);
      rethrow;
    }
  }

  // ===== MARKETPLACE FEATURES =====

  Future<List<Map<String, dynamic>>> getMarketplaceListings({
    int skip = 0,
    int limit = 20,
  }) async {
    final cacheOptions = CacheOptions(
      store: HiveCacheStore(
        await _getCacheDirectory(),
        hiveBoxName: 'jambam_cache',
      ),
      policy: CachePolicy.forceCache,
      maxStale: _shortCacheDuration,
    );

    try {
      final response = await _dio.get(
        '/marketplace',
        queryParameters: {'skip': skip, 'limit': limit},
        options: cacheOptions.toOptions(),
      );
      
      final List<dynamic> data = response.data;
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      // Return from offline database
      return await _database.getAssets(isPublic: true, limit: limit, offset: skip);
    }
  }

  Future<Map<String, dynamic>> buyAsset({
    required int assetId,
    required int buyerId,
  }) async {
    final data = {'buyer_id': buyerId};

    try {
      final response = await _dio.post('/assets/$assetId/buy', data: data);
      return response.data;
    } catch (e) {
      await _database.addToSyncQueue(
        operation: 'POST',
        endpoint: '/assets/$assetId/buy',
        data: data,
        priority: 1,
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateAssetDetails({
    required int assetId,
    required String name,
    required String description,
    required bool isPublic,
    double price = 0.0,
    bool isForSale = false,
  }) async {
    final data = {
      'name': name,
      'description': description,
      'is_public': isPublic,
      'price': price,
      'is_for_sale': isForSale,
    };

    try {
      final response = await _dio.put('/assets/$assetId', data: data);
      return response.data;
    } catch (e) {
      await _syncService.syncAssetUpdate(assetId, data);
      rethrow;
    }
  }

  // ===== ORGANIZATION FEATURES =====

  Future<List<Map<String, dynamic>>> getOrganizations() async {
    final cacheOptions = CacheOptions(
      store: HiveCacheStore(
        await _getCacheDirectory(),
        hiveBoxName: 'jambam_cache',
      ),
      policy: CachePolicy.forceCache,
      maxStale: _cacheDuration,
    );

    try {
      final response = await _dio.get('/organizations', options: cacheOptions.toOptions());
      final List<dynamic> data = response.data;
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> joinOrganization({
    required int orgId,
    required int userId,
  }) async {
    final data = {'user_id': userId};

    try {
      final response = await _dio.post('/organizations/$orgId/join', data: data);
      return response.data;
    } catch (e) {
      await _database.addToSyncQueue(
        operation: 'POST',
        endpoint: '/organizations/$orgId/join',
        data: data,
        priority: 2,
      );
      rethrow;
    }
  }

  // ===== LICENSE FEATURES =====

  Future<List<Map<String, dynamic>>> getLicenseTypes() async {
    final cacheOptions = CacheOptions(
      store: HiveCacheStore(
        await _getCacheDirectory(),
        hiveBoxName: 'jambam_cache',
      ),
      policy: CachePolicy.forceCache,
      maxStale: _cacheDuration,
    );

    try {
      final response = await _dio.get('/license-types', options: cacheOptions.toOptions());
      final List<dynamic> data = response.data;
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAssetLicenses(int assetId) async {
    try {
      final response = await _dio.get('/assets/$assetId/licenses');
      final List<dynamic> data = response.data;
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      return await _database.getLicenses(assetId: assetId);
    }
  }

  Future<Map<String, dynamic>> purchaseLicense({
    required int licenseId,
    required int buyerId,
  }) async {
    final data = {'buyer_id': buyerId};

    try {
      final response = await _dio.post('/licenses/$licenseId/purchase', data: data);
      return response.data;
    } catch (e) {
      await _syncService.syncLicensePurchase(licenseId, data);
      rethrow;
    }
  }

  // ===== GENERATION STYLES =====

  Future<Map<String, dynamic>> getAvailableStyles() async {
    final cacheOptions = CacheOptions(
      store: HiveCacheStore(
        await _getCacheDirectory(),
        hiveBoxName: 'jambam_cache',
      ),
      policy: CachePolicy.forceCache,
      maxStale: _cacheDuration,
    );

    try {
      final response = await _dio.get('/generation/styles', options: cacheOptions.toOptions());
      return response.data;
    } catch (e) {
      // Return default styles
      return {
        'styles': [
          {'name': 'realistic', 'description': 'Photorealistic style'},
          {'name': 'cartoon', 'description': 'Cartoon/anime style'},
          {'name': 'abstract', 'description': 'Abstract artistic style'},
        ]
      };
    }
  }

  Future<Map<String, dynamic>> getStyleInfo(String style) async {
    final cacheOptions = CacheOptions(
      store: HiveCacheStore(
        await _getCacheDirectory(),
        hiveBoxName: 'jambam_cache',
      ),
      policy: CachePolicy.forceCache,
      maxStale: _cacheDuration,
    );

    try {
      final response = await _dio.get(
        '/generation/styles/$style',
        options: cacheOptions.toOptions(),
      );
      return response.data;
    } catch (e) {
      return {'name': style, 'description': 'Style information unavailable'};
    }
  }

  // ===== UTILITY METHODS =====

  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get('/../health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearCache() async {
    await _dio.delete('/cache');
  }

  Future<void> forceSync() async {
    await _syncService.forceSync();
  }

  Future<int> getPendingSyncCount() async {
    return await _syncService.getPendingSyncCount();
  }

  void dispose() {
    _dio.close();
    _syncService.dispose();
    _connectivity.dispose();
  }
}

// Riverpod providers
final enhancedApiServiceProvider = Provider<EnhancedApiService>((ref) {
  return EnhancedApiService();
}); 