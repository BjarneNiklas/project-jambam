# Backend Integration & Offline Support

## Overview

JambaM implements a comprehensive backend integration system with robust offline support, ensuring users can continue using the app even without internet connectivity. The system includes real API endpoints, intelligent caching, offline database storage, and automatic synchronization.

## Architecture

### Core Components

1. **Enhanced API Service** (`enhanced_api_service.dart`)
   - Dio-based HTTP client with interceptors
   - Automatic caching with Hive storage
   - Offline queue management
   - Connectivity-aware requests

2. **Offline Database** (`offline_database.dart`)
   - SQLite-based local storage
   - Asset, user, and sync queue tables
   - Automatic data persistence

3. **Connectivity Service** (`connectivity_service.dart`)
   - Real-time network status monitoring
   - Connection state management
   - Automatic reconnection handling

4. **Sync Service** (`sync_service.dart`)
   - Background synchronization
   - Priority-based sync queue
   - Retry mechanism with exponential backoff

## API Endpoints

### Asset Generation
- `POST /api/v1/assets/generate` - Generate 3D assets from prompts
- `POST /api/v1/assets/upload` - Upload and process 3D files
- `GET /api/v1/assets/jobs/{job_id}` - Check generation status

### Community Features
- `GET /api/v1/assets` - Browse public assets
- `GET /api/v1/assets/{id}` - Get asset details
- `POST /api/v1/assets/{id}/rate` - Rate assets
- `POST /api/v1/assets/{id}/tags` - Add tags
- `POST /api/v1/assets/{id}/remix` - Create remixes

### Marketplace
- `GET /api/v1/marketplace` - Browse marketplace
- `POST /api/v1/assets/{id}/buy` - Purchase assets
- `GET /api/v1/users/{id}/purchases` - User purchase history
- `GET /api/v1/users/{id}/sales` - User sales history

### User Management
- `POST /api/v1/users` - Create user account
- `GET /api/v1/users/{id}` - Get user profile
- `PUT /api/v1/users/{id}` - Update profile
- `GET /api/v1/users/{id}/assets` - User's assets
- `GET /api/v1/users/{id}/favorites` - User's favorites

### Organizations
- `POST /api/v1/organizations` - Create organization
- `GET /api/v1/organizations` - List organizations
- `POST /api/v1/organizations/{id}/join` - Join organization

### Licensing
- `GET /api/v1/license-types` - Available license types
- `POST /api/v1/assets/{id}/licenses` - Add license to asset
- `GET /api/v1/assets/{id}/licenses` - Asset licenses
- `POST /api/v1/licenses/{id}/purchase` - Purchase license

### Offline Sync
- `POST /api/v1/sync/batch` - Batch sync operations
- `GET /api/v1/sync/status` - Sync status

### Enhanced Features
- `GET /api/v1/search/assets` - Search with filters
- `GET /api/v1/recommendations/{user_id}` - Personalized recommendations
- `GET /api/v1/assets/{id}/analytics` - Asset analytics
- `POST /api/v1/assets/{id}/download` - Download tracking

## Offline Support Features

### Automatic Caching
- **HTTP Cache**: Automatic caching of GET requests using Dio cache interceptor
- **Asset Cache**: Local storage of asset metadata and thumbnails
- **User Data**: Cached user profiles and preferences
- **Community Content**: Offline access to previously loaded community assets

### Offline Database Schema

```sql
-- Assets table
CREATE TABLE assets (
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
);

-- Users table
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  username TEXT NOT NULL,
  email TEXT,
  avatar_url TEXT,
  bio TEXT,
  created_at TEXT,
  updated_at TEXT,
  sync_status TEXT DEFAULT 'synced'
);

-- Sync queue table
CREATE TABLE sync_queue (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  operation TEXT NOT NULL,
  endpoint TEXT NOT NULL,
  data TEXT NOT NULL,
  created_at TEXT NOT NULL,
  retry_count INTEGER DEFAULT 0,
  max_retries INTEGER DEFAULT 3,
  priority INTEGER DEFAULT 0
);
```

### Sync Priority System

1. **High Priority (1)**: Purchases, license purchases
2. **Medium Priority (2)**: Asset generation, uploads, organization joins
3. **Low Priority (3)**: Ratings, comments, tags
4. **Background (4)**: General updates

### Offline Capabilities

#### Available Offline
- ✅ Browse cached assets
- ✅ View asset details
- ✅ Rate and comment (queued for sync)
- ✅ Create new assets (queued for sync)
- ✅ View user profile
- ✅ Access favorites
- ✅ Search cached content

#### Requires Online
- ❌ Real-time asset generation
- ❌ File uploads
- ❌ Marketplace purchases
- ❌ License purchases
- ❌ Community theme voting

## Implementation Guide

### 1. Initialize Services

```dart
// In main.dart
Future<void> _initializeServices(ProviderContainer container) async {
  final apiService = container.read(enhancedApiServiceProvider);
  await apiService.initialize();
  
  final connectivityService = container.read(connectivityServiceProvider);
  await connectivityService.initialize();
  
  final syncService = container.read(syncServiceProvider);
  await syncService.initialize();
}
```

### 2. Use Enhanced API Service

```dart
// Generate asset with offline support
final apiService = ref.read(enhancedApiServiceProvider);
try {
  final result = await apiService.generateAsset(
    prompt: "A futuristic robot",
    style: "realistic",
    quality: "high",
  );
  // Handle success
} catch (e) {
  // Request is automatically queued for offline sync
  print('Queued for offline sync: $e');
}
```

### 3. Monitor Connectivity

```dart
// Watch connection status
final isOnline = ref.watch(isOnlineProvider);
final syncStatus = ref.watch(syncStatusProvider);

// Show offline banner
if (!isOnline) {
  return OfflineBanner();
}
```

### 4. Handle Sync Status

```dart
// Monitor pending sync operations
final pendingCount = ref.watch(pendingSyncCountProvider);

// Force sync when needed
final syncService = ref.read(syncServiceProvider);
await syncService.forceSync();
```

## UI Components

### Offline Status Widget
```dart
OfflineStatusWidget() // Shows connection and sync status
```

### Offline Banner
```dart
OfflineBanner() // Full-width banner when offline
```

### Sync Progress Indicator
```dart
SyncProgressIndicator() // Shows sync progress
```

## Configuration

### Cache Settings
```dart
static const Duration _cacheDuration = Duration(hours: 24);
static const Duration _shortCacheDuration = Duration(minutes: 30);
```

### Sync Settings
```dart
static const int maxRetries = 3;
static const Duration syncDelay = Duration(seconds: 2);
```

### Database Settings
```dart
static const String _databaseName = 'jambam_offline.db';
static const int _databaseVersion = 1;
```

## Error Handling

### Network Errors
- Automatic fallback to cached data
- Queue operations for later sync
- User-friendly error messages

### Sync Errors
- Retry with exponential backoff
- Maximum retry limit enforcement
- Error logging and reporting

### Database Errors
- Automatic database recreation if corrupted
- Data integrity checks
- Graceful degradation

## Performance Optimizations

### Caching Strategy
- **Memory Cache**: Frequently accessed data
- **Disk Cache**: Large files and assets
- **Database Cache**: Structured data

### Sync Optimization
- **Batch Operations**: Multiple requests in single call
- **Priority Queuing**: Important operations first
- **Incremental Sync**: Only sync changed data

### Database Optimization
- **Indexed Queries**: Fast data retrieval
- **Connection Pooling**: Efficient database access
- **Lazy Loading**: Load data on demand

## Security Considerations

### Data Protection
- Encrypted local storage
- Secure API communication
- User authentication

### Privacy
- Local data isolation
- Secure sync protocols
- GDPR compliance

## Testing

### Offline Testing
```bash
# Test offline functionality
flutter test test/offline/
```

### API Testing
```bash
# Test API endpoints
pytest api/tests/
```

### Integration Testing
```bash
# Test full integration
flutter test integration_test/
```

## Monitoring

### Metrics to Track
- Offline usage patterns
- Sync success rates
- Cache hit ratios
- API response times

### Logging
- Connectivity changes
- Sync operations
- Error occurrences
- Performance metrics

## Future Enhancements

### Planned Features
- **Background Sync**: Automatic sync in background
- **Conflict Resolution**: Handle data conflicts
- **Selective Sync**: Choose what to sync
- **Cloud Backup**: Backup offline data
- **Real-time Updates**: WebSocket integration

### Performance Improvements
- **Compression**: Compress cached data
- **Differential Sync**: Sync only changes
- **Predictive Caching**: Pre-cache likely content
- **Smart Retry**: Adaptive retry strategies 