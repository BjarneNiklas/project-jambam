import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // HTTP client with timeout
  final http.Client _client = http.Client();

  // Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ===== ASSET GENERATION =====
  
  /// Generate a new 3D asset using Stable Diffusion 3D
  Future<Map<String, dynamic>> generateAsset({
    required String prompt,
    required String style,
    String quality = 'standard',
    String outputFormat = 'glb',
    List<String> animations = const [],
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/assets/generate'),
      headers: _headers,
      body: jsonEncode({
        'prompt': prompt,
        'style': style,
        'quality': quality,
        'output_format': outputFormat,
        'animation': animations,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to generate asset: ${response.body}');
    }
  }

  /// Get job status for asset generation
  Future<Map<String, dynamic>> getJobStatus(String jobId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/assets/jobs/$jobId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get job status: ${response.body}');
    }
  }

  /// Get available generation styles
  Future<Map<String, dynamic>> getAvailableStyles() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/generation/styles'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get styles: ${response.body}');
    }
  }

  /// Get style information
  Future<Map<String, dynamic>> getStyleInfo(String style) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/generation/styles/$style'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get style info: ${response.body}');
    }
  }

  // ===== COMMUNITY FEATURES =====

  /// Get public assets for community hub
  Future<List<Map<String, dynamic>>> getPublicAssets({
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/assets?skip=$skip&limit=$limit'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get public assets: ${response.body}');
    }
  }

  /// Get detailed asset information
  Future<Map<String, dynamic>> getAssetDetails(int assetId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/assets/$assetId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get asset details: ${response.body}');
    }
  }

  /// Rate an asset
  Future<Map<String, dynamic>> rateAsset({
    required int assetId,
    required int score,
    required int userId,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/assets/$assetId/rate'),
      headers: _headers,
      body: jsonEncode({
        'score': score,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to rate asset: ${response.body}');
    }
  }

  /// Add tags to an asset
  Future<Map<String, dynamic>> addTagsToAsset({
    required int assetId,
    required List<String> tags,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/assets/$assetId/tags'),
      headers: _headers,
      body: jsonEncode({
        'tags': tags,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add tags: ${response.body}');
    }
  }

  /// Remix an asset
  Future<Map<String, dynamic>> remixAsset({
    required int assetId,
    required String prompt,
    required String style,
    String quality = 'standard',
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/assets/$assetId/remix'),
      headers: _headers,
      body: jsonEncode({
        'prompt': prompt,
        'style': style,
        'quality': quality,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to remix asset: ${response.body}');
    }
  }

  // ===== MARKETPLACE FEATURES =====

  /// Get marketplace listings
  Future<List<Map<String, dynamic>>> getMarketplaceListings({
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/marketplace?skip=$skip&limit=$limit'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get marketplace listings: ${response.body}');
    }
  }

  /// Buy an asset
  Future<Map<String, dynamic>> buyAsset({
    required int assetId,
    required int buyerId,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/assets/$assetId/buy'),
      headers: _headers,
      body: jsonEncode({
        'buyer_id': buyerId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to buy asset: ${response.body}');
    }
  }

  /// Update asset details (including marketplace settings)
  Future<Map<String, dynamic>> updateAssetDetails({
    required int assetId,
    required String name,
    required String description,
    required bool isPublic,
    double price = 0.0,
    bool isForSale = false,
  }) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/assets/$assetId'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'description': description,
        'is_public': isPublic,
        'price': price,
        'is_for_sale': isForSale,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update asset: ${response.body}');
    }
  }

  // ===== ORGANIZATION FEATURES =====

  /// Get public organizations
  Future<List<Map<String, dynamic>>> getOrganizations() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/organizations'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get organizations: ${response.body}');
    }
  }

  /// Join an organization
  Future<Map<String, dynamic>> joinOrganization({
    required int orgId,
    required int userId,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/organizations/$orgId/join'),
      headers: _headers,
      body: jsonEncode({
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to join organization: ${response.body}');
    }
  }

  // ===== LICENSE FEATURES =====

  /// Get available license types
  Future<List<Map<String, dynamic>>> getLicenseTypes() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/license-types'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get license types: ${response.body}');
    }
  }

  /// Get asset licenses
  Future<List<Map<String, dynamic>>> getAssetLicenses(int assetId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/assets/$assetId/licenses'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get asset licenses: ${response.body}');
    }
  }

  /// Purchase a license
  Future<Map<String, dynamic>> purchaseLicense({
    required int licenseId,
    required int buyerId,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/licenses/$licenseId/purchase'),
      headers: _headers,
      body: jsonEncode({
        'buyer_id': buyerId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to purchase license: ${response.body}');
    }
  }

  // ===== GAUSSIAN SPLAT PREVIEWS =====

  /// Get Gaussian Splat preview for a platform
  Future<String> getSplatPreview({
    required int assetId,
    required String platform, // 'web', 'desktop', 'android'
  }) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/assets/$assetId/preview/$platform'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get splat preview: ${response.body}');
    }
  }

  // ===== UTILITY METHODS =====

  /// Upload a file
  Future<Map<String, dynamic>> uploadFile({
    required String filePath,
    required String fileName,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/assets/upload'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', filePath, filename: fileName),
    );

    final response = await _client.send(request);
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return jsonDecode(responseBody);
    } else {
      throw Exception('Failed to upload file: $responseBody');
    }
  }

  /// Health check
  Future<bool> healthCheck() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/../health'),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _client.close();
  }
}

// Riverpod provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
}); 