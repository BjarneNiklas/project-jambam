import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class OfflineDatabase {
  static Database? _database;
  static const String _databaseName = 'jambam_offline.db';
  static const int _databaseVersion = 1;

  // Web-compatible in-memory storage
  static final Map<String, List<Map<String, dynamic>>> _webStorage = {
    'assets': [],
    'users': [],
    'sync_queue': [],
    'user_assets': [],
    'community_themes': [],
    'licenses': [],
  };

  // Table names
  static const String tableAssets = 'assets';
  static const String tableUsers = 'users';
  static const String tableSyncQueue = 'sync_queue';
  static const String tableUserAssets = 'user_assets';
  static const String tableCommunityThemes = 'community_themes';
  static const String tableLicenses = 'licenses';

  // Singleton pattern
  static final OfflineDatabase _instance = OfflineDatabase._internal();
  factory OfflineDatabase() => _instance;
  OfflineDatabase._internal();

  Future<Database?> get database async {
    if (kIsWeb) return null; // Web doesn't use SQLite
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      throw UnsupportedError('SQLite is not supported on web');
    }
    
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Assets table
    await db.execute('''
      CREATE TABLE $tableAssets (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        prompt TEXT,
        style TEXT,
        quality TEXT,
        output_format TEXT,
        file_path TEXT,
        thumbnail_path TEXT,
        is_public INTEGER DEFAULT 0,
        is_for_sale INTEGER DEFAULT 0,
        price REAL DEFAULT 0.0,
        rating REAL DEFAULT 0.0,
        rating_count INTEGER DEFAULT 0,
        tags TEXT,
        created_at TEXT,
        updated_at TEXT,
        job_id TEXT,
        status TEXT DEFAULT 'pending',
        user_id INTEGER,
        organization_id INTEGER,
        license_type_id INTEGER,
        sync_status TEXT DEFAULT 'synced'
      )
    ''');

    // Users table
    await db.execute('''
      CREATE TABLE $tableUsers (
        id INTEGER PRIMARY KEY,
        username TEXT NOT NULL,
        email TEXT,
        avatar_url TEXT,
        bio TEXT,
        created_at TEXT,
        updated_at TEXT,
        sync_status TEXT DEFAULT 'synced'
      )
    ''');

    // Sync queue table for offline operations
    await db.execute('''
      CREATE TABLE $tableSyncQueue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        operation TEXT NOT NULL,
        endpoint TEXT NOT NULL,
        data TEXT NOT NULL,
        created_at TEXT NOT NULL,
        retry_count INTEGER DEFAULT 0,
        max_retries INTEGER DEFAULT 3,
        priority INTEGER DEFAULT 0
      )
    ''');

    // User assets relationship table
    await db.execute('''
      CREATE TABLE $tableUserAssets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        asset_id INTEGER NOT NULL,
        relationship_type TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES $tableUsers (id),
        FOREIGN KEY (asset_id) REFERENCES $tableAssets (id)
      )
    ''');

    // Community themes table
    await db.execute('''
      CREATE TABLE $tableCommunityThemes (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        prompt TEXT NOT NULL,
        style TEXT,
        quality TEXT,
        votes INTEGER DEFAULT 0,
        created_by INTEGER,
        created_at TEXT,
        updated_at TEXT,
        sync_status TEXT DEFAULT 'synced',
        FOREIGN KEY (created_by) REFERENCES $tableUsers (id)
      )
    ''');

    // Licenses table
    await db.execute('''
      CREATE TABLE $tableLicenses (
        id INTEGER PRIMARY KEY,
        asset_id INTEGER NOT NULL,
        license_type_id INTEGER NOT NULL,
        price REAL DEFAULT 0.0,
        is_active INTEGER DEFAULT 1,
        created_at TEXT,
        updated_at TEXT,
        sync_status TEXT DEFAULT 'synced',
        FOREIGN KEY (asset_id) REFERENCES $tableAssets (id)
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_assets_user_id ON $tableAssets (user_id)');
    await db.execute('CREATE INDEX idx_assets_public ON $tableAssets (is_public)');
    await db.execute('CREATE INDEX idx_assets_status ON $tableAssets (status)');
    await db.execute('CREATE INDEX idx_sync_queue_priority ON $tableSyncQueue (priority)');
    await db.execute('CREATE INDEX idx_sync_queue_created_at ON $tableSyncQueue (created_at)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Future upgrade logic
    }
  }

  // ===== ASSET OPERATIONS =====

  Future<int> insertAsset(Map<String, dynamic> asset) async {
    if (kIsWeb) {
      // Web: Use in-memory storage
      final id = _webStorage['assets']!.length + 1;
      asset['id'] = id;
      _webStorage['assets']!.add(asset);
      return id;
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      return await db.insert(tableAssets, asset);
    }
  }

  Future<List<Map<String, dynamic>>> getAssets({
    int? userId,
    bool? isPublic,
    String? status,
    int limit = 20,
    int offset = 0,
  }) async {
    if (kIsWeb) {
      // Web: Filter in-memory data
      List<Map<String, dynamic>> assets = List.from(_webStorage['assets']!);
      
      if (userId != null) {
        assets = assets.where((asset) => asset['user_id'] == userId).toList();
      }
      
      if (isPublic != null) {
        assets = assets.where((asset) => asset['is_public'] == (isPublic ? 1 : 0)).toList();
      }
      
      if (status != null) {
        assets = assets.where((asset) => asset['status'] == status).toList();
      }
      
      return assets.skip(offset).take(limit).toList();
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      
      String whereClause = '1=1';
      List<dynamic> whereArgs = [];
      
      if (userId != null) {
        whereClause += ' AND user_id = ?';
        whereArgs.add(userId);
      }
      
      if (isPublic != null) {
        whereClause += ' AND is_public = ?';
        whereArgs.add(isPublic ? 1 : 0);
      }
      
      if (status != null) {
        whereClause += ' AND status = ?';
        whereArgs.add(status);
      }

      return await db.query(
        tableAssets,
        where: whereClause,
        whereArgs: whereArgs,
        limit: limit,
        offset: offset,
        orderBy: 'created_at DESC',
      );
    }
  }

  Future<Map<String, dynamic>?> getAssetById(int id) async {
    if (kIsWeb) {
      // Web: Find in memory
      final assets = _webStorage['assets']!;
      try {
        return assets.firstWhere((asset) => asset['id'] == id);
      } catch (e) {
        return null;
      }
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      final result = await db.query(
        tableAssets,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return result.isNotEmpty ? result.first : null;
    }
  }

  Future<int> updateAsset(int id, Map<String, dynamic> asset) async {
    if (kIsWeb) {
      // Web: Update in memory
      final assets = _webStorage['assets']!;
      final index = assets.indexWhere((a) => a['id'] == id);
      if (index != -1) {
        assets[index].addAll(asset);
        return 1;
      }
      return 0;
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      return await db.update(
        tableAssets,
        asset,
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<int> deleteAsset(int id) async {
    if (kIsWeb) {
      // Web: Remove from memory
      final assets = _webStorage['assets']!;
      final initialLength = assets.length;
      assets.removeWhere((asset) => asset['id'] == id);
      return initialLength - assets.length;
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      return await db.delete(
        tableAssets,
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // ===== USER OPERATIONS =====

  Future<int> insertUser(Map<String, dynamic> user) async {
    if (kIsWeb) {
      // Web: Use in-memory storage
      final id = _webStorage['users']!.length + 1;
      user['id'] = id;
      _webStorage['users']!.add(user);
      return id;
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      return await db.insert(tableUsers, user);
    }
  }

  Future<List<Map<String, dynamic>>> getUsers({int limit = 20, int offset = 0}) async {
    if (kIsWeb) {
      // Web: Return from memory
      return _webStorage['users']!.skip(offset).take(limit).toList();
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      final result = await db.query(
        tableUsers,
        limit: limit,
        offset: offset,
        orderBy: 'created_at DESC',
      );
      return result;
    }
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    if (kIsWeb) {
      // Web: Update in memory
      final users = _webStorage['users']!;
      final index = users.indexWhere((u) => u['id'] == id);
      if (index != -1) {
        users[index].addAll(user);
        return 1;
      }
      return 0;
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      return await db.update(
        tableUsers,
        user,
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // ===== SYNC QUEUE OPERATIONS =====

  Future<int> addToSyncQueue({
    required String operation,
    required String endpoint,
    required Map<String, dynamic> data,
    int priority = 0,
  }) async {
    if (kIsWeb) {
      // Web: Add to memory
      final id = _webStorage['sync_queue']!.length + 1;
      final queueItem = {
        'id': id,
        'operation': operation,
        'endpoint': endpoint,
        'data': jsonEncode(data),
        'created_at': DateTime.now().toIso8601String(),
        'retry_count': 0,
        'max_retries': 3,
        'priority': priority,
      };
      _webStorage['sync_queue']!.add(queueItem);
      return id;
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      return await db.insert(tableSyncQueue, {
        'operation': operation,
        'endpoint': endpoint,
        'data': jsonEncode(data),
        'created_at': DateTime.now().toIso8601String(),
        'retry_count': 0,
        'max_retries': 3,
        'priority': priority,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getSyncQueue({int limit = 50}) async {
    if (kIsWeb) {
      // Web: Return from memory
      return _webStorage['sync_queue']!.take(limit).toList();
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      final result = await db.query(
        tableSyncQueue,
        limit: limit,
        orderBy: 'priority ASC, created_at ASC',
      );
      return result.map((row) {
        final item = Map<String, dynamic>.from(row);
        item['data'] = jsonDecode(item['data']);
        return item;
      }).toList();
    }
  }

  Future<int> removeFromSyncQueue(int id) async {
    if (kIsWeb) {
      // Web: Remove from memory
      final queue = _webStorage['sync_queue']!;
      final initialLength = queue.length;
      queue.removeWhere((item) => item['id'] == id);
      return initialLength - queue.length;
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      return await db.delete(
        tableSyncQueue,
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<int> updateSyncQueueItem(int id, Map<String, dynamic> updates) async {
    if (kIsWeb) {
      // Web: Update in memory
      final queue = _webStorage['sync_queue']!;
      final index = queue.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        queue[index].addAll(updates);
        return 1;
      }
      return 0;
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      return await db.update(
        tableSyncQueue,
        updates,
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // ===== COMMUNITY THEMES OPERATIONS =====

  Future<int> insertCommunityTheme(Map<String, dynamic> theme) async {
    if (kIsWeb) {
      // Web: Use in-memory storage
      final id = _webStorage['community_themes']!.length + 1;
      theme['id'] = id;
      _webStorage['community_themes']!.add(theme);
      return id;
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      return await db.insert(tableCommunityThemes, theme);
    }
  }

  Future<List<Map<String, dynamic>>> getCommunityThemes({int limit = 20, int offset = 0}) async {
    if (kIsWeb) {
      // Web: Return from memory
      return _webStorage['community_themes']!.skip(offset).take(limit).toList();
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      final result = await db.query(
        tableCommunityThemes,
        limit: limit,
        offset: offset,
        orderBy: 'votes DESC, created_at DESC',
      );
      return result;
    }
  }

  Future<int> updateCommunityTheme(int id, Map<String, dynamic> theme) async {
    if (kIsWeb) {
      // Web: Update in memory
      final themes = _webStorage['community_themes']!;
      final index = themes.indexWhere((t) => t['id'] == id);
      if (index != -1) {
        themes[index].addAll(theme);
        return 1;
      }
      return 0;
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      return await db.update(
        tableCommunityThemes,
        theme,
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // ===== LICENSE OPERATIONS =====

  Future<int> insertLicense(Map<String, dynamic> license) async {
    if (kIsWeb) {
      // Web: Use in-memory storage
      final id = _webStorage['licenses']!.length + 1;
      license['id'] = id;
      _webStorage['licenses']!.add(license);
      return id;
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      return await db.insert(tableLicenses, license);
    }
  }

  Future<List<Map<String, dynamic>>> getLicenses({int? assetId}) async {
    if (kIsWeb) {
      // Web: Return from memory
      List<Map<String, dynamic>> licenses = List.from(_webStorage['licenses']!);
      if (assetId != null) {
        licenses = licenses.where((license) => license['asset_id'] == assetId).toList();
      }
      return licenses;
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');

      String whereClause = '1=1';
      List<dynamic> whereArgs = [];
      if (assetId != null) {
        whereClause += ' AND asset_id = ?';
        whereArgs.add(assetId);
      }

      return await db.query(
        tableLicenses,
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'created_at DESC',
      );
    }
  }

  // ===== ORGANIZATION OPERATIONS =====

  Future<List<Map<String, dynamic>>> getOrganizations() async {
    if (kIsWeb) {
      // Web: Return from memory (placeholder data)
      return [
        {
          'id': 1,
          'name': 'Jambam Studios',
          'description': 'Leading game development studio',
          'logo_url': 'https://example.com/logo.png',
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 2,
          'name': 'Indie Game Collective',
          'description': 'Community of independent developers',
          'logo_url': 'https://example.com/logo2.png',
          'created_at': DateTime.now().toIso8601String(),
        },
      ];
    } else {
      // Mobile: Use SQLite (placeholder - would need organizations table)
      return [
        {
          'id': 1,
          'name': 'Jambam Studios',
          'description': 'Leading game development studio',
          'logo_url': 'https://example.com/logo.png',
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 2,
          'name': 'Indie Game Collective',
          'description': 'Community of independent developers',
          'logo_url': 'https://example.com/logo2.png',
          'created_at': DateTime.now().toIso8601String(),
        },
      ];
    }
  }

  // ===== LICENSE TYPE OPERATIONS =====

  Future<List<Map<String, dynamic>>> getLicenseTypes() async {
    if (kIsWeb) {
      // Web: Return from memory (placeholder data)
      return [
        {
          'id': 1,
          'name': 'MIT License',
          'description': 'Permissive license for open source projects',
          'price': 0.0,
          'is_active': 1,
        },
        {
          'id': 2,
          'name': 'Commercial License',
          'description': 'License for commercial use',
          'price': 99.99,
          'is_active': 1,
        },
        {
          'id': 3,
          'name': 'Educational License',
          'description': 'Free license for educational institutions',
          'price': 0.0,
          'is_active': 1,
        },
      ];
    } else {
      // Mobile: Use SQLite (placeholder - would need license_types table)
      return [
        {
          'id': 1,
          'name': 'MIT License',
          'description': 'Permissive license for open source projects',
          'price': 0.0,
          'is_active': 1,
        },
        {
          'id': 2,
          'name': 'Commercial License',
          'description': 'License for commercial use',
          'price': 99.99,
          'is_active': 1,
        },
        {
          'id': 3,
          'name': 'Educational License',
          'description': 'Free license for educational institutions',
          'price': 0.0,
          'is_active': 1,
        },
      ];
    }
  }

  // ===== GENERATION STYLES OPERATIONS =====

  Future<List<Map<String, dynamic>>> getGenerationStyles() async {
    if (kIsWeb) {
      // Web: Return from memory (placeholder data)
      return [
        {
          'id': 1,
          'name': 'realistic',
          'description': 'Photorealistic 3D models',
          'category': 'realistic',
          'is_active': 1,
        },
        {
          'id': 2,
          'name': 'stylized',
          'description': 'Artistic and stylized models',
          'category': 'artistic',
          'is_active': 1,
        },
        {
          'id': 3,
          'name': 'low-poly',
          'description': 'Low polygon count models',
          'category': 'performance',
          'is_active': 1,
        },
      ];
    } else {
      // Mobile: Use SQLite (placeholder - would need generation_styles table)
      return [
        {
          'id': 1,
          'name': 'realistic',
          'description': 'Photorealistic 3D models',
          'category': 'realistic',
          'is_active': 1,
        },
        {
          'id': 2,
          'name': 'stylized',
          'description': 'Artistic and stylized models',
          'category': 'artistic',
          'is_active': 1,
        },
        {
          'id': 3,
          'name': 'low-poly',
          'description': 'Low polygon count models',
          'category': 'performance',
          'is_active': 1,
        },
      ];
    }
  }

  Future<Map<String, dynamic>?> getGenerationStyleByName(String styleName) async {
    if (kIsWeb) {
      // Web: Find in memory
      final styles = await getGenerationStyles();
      try {
        return styles.firstWhere((style) => style['name'] == styleName);
      } catch (e) {
        return null;
      }
    } else {
      // Mobile: Use SQLite (placeholder)
      final styles = await getGenerationStyles();
      try {
        return styles.firstWhere((style) => style['name'] == styleName);
      } catch (e) {
        return null;
      }
    }
  }

  // ===== UTILITY METHODS =====

  Future<void> clearAllData() async {
    if (kIsWeb) {
      // Web: Clear all in-memory data
      _webStorage.forEach((key, value) => value.clear());
    } else {
      // Mobile: Use SQLite transaction
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      await db.transaction((txn) async {
        await txn.delete(tableAssets);
        await txn.delete(tableUsers);
        await txn.delete(tableSyncQueue);
        await txn.delete(tableUserAssets);
        await txn.delete(tableCommunityThemes);
        await txn.delete(tableLicenses);
      });
    }
  }

  Future<int> getSyncQueueCount() async {
    if (kIsWeb) {
      // Web: Return count from memory
      return _webStorage['sync_queue']!.length;
    } else {
      // Mobile: Use SQLite
      final db = await database;
      if (db == null) throw Exception('Database not initialized');
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM $tableSyncQueue');
      return Sqflite.firstIntValue(result) ?? 0;
    }
  }

  Future<void> close() async {
    if (!kIsWeb) {
      // Only close on mobile platforms
      final db = await database;
      if (db != null) {
        await db.close();
      }
    }
  }
} 