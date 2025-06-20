import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/connectivity_service.dart';
import '../core/sync_service.dart';

class OfflineStatusWidget extends ConsumerWidget {
  const OfflineStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStatus = ref.watch(connectionStatusProvider);
    final syncStatus = ref.watch(syncStatusProvider);
    final pendingSyncCount = ref.watch(pendingSyncCountProvider);

    return connectionStatus.when(
      data: (status) {
        if (status == ConnectionStatus.connected) {
          return _buildOnlineStatus(context, syncStatus, pendingSyncCount);
        } else {
          return _buildOfflineStatus(context, pendingSyncCount);
        }
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildOnlineStatus(
    BuildContext context,
    AsyncValue<SyncStatus> syncStatus,
    AsyncValue<int> pendingSyncCount,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi,
            size: 16,
            color: Colors.green[700],
          ),
          const SizedBox(width: 6),
          Text(
            'Online',
            style: TextStyle(
              color: Colors.green[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (pendingSyncCount.hasValue && pendingSyncCount.value! > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${pendingSyncCount.value}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          if (syncStatus.hasValue) ...[
            const SizedBox(width: 8),
            _buildSyncIndicator(syncStatus.value!),
          ],
        ],
      ),
    );
  }

  Widget _buildOfflineStatus(BuildContext context, AsyncValue<int> pendingSyncCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off,
            size: 16,
            color: Colors.orange[700],
          ),
          const SizedBox(width: 6),
          Text(
            'Offline',
            style: TextStyle(
              color: Colors.orange[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (pendingSyncCount.hasValue && pendingSyncCount.value! > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${pendingSyncCount.value}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSyncIndicator(SyncStatus status) {
    switch (status) {
      case SyncStatus.syncing:
        return SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
          ),
        );
      case SyncStatus.completed:
        return Icon(
          Icons.check_circle,
          size: 12,
          color: Colors.green[700],
        );
      case SyncStatus.partial:
        return Icon(
          Icons.warning,
          size: 12,
          color: Colors.orange[700],
        );
      case SyncStatus.failed:
        return Icon(
          Icons.error,
          size: 12,
          color: Colors.red[700],
        );
      case SyncStatus.idle:
        return const SizedBox.shrink();
    }
  }
}

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    final pendingSyncCount = ref.watch(pendingSyncCountProvider);

    if (isOnline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.orange[50],
      child: Row(
        children: [
          Icon(
            Icons.wifi_off,
            color: Colors.orange[700],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You\'re offline',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (pendingSyncCount.hasValue && pendingSyncCount.value! > 0)
                  Text(
                    '${pendingSyncCount.value} actions will sync when you\'re back online',
                    style: TextStyle(
                      color: Colors.orange[600],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: Colors.orange[700],
              size: 20,
            ),
            onPressed: () => _showOfflineInfo(context),
          ),
        ],
      ),
    );
  }

  void _showOfflineInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Offline Mode'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You\'re currently offline. Here\'s what you can do:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text('• Browse cached content'),
            Text('• Create new assets (will sync later)'),
            Text('• Rate and comment on assets'),
            Text('• View your saved assets'),
            SizedBox(height: 12),
            Text(
              'Your actions will automatically sync when you\'re back online.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class SyncProgressIndicator extends ConsumerWidget {
  const SyncProgressIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatus = ref.watch(syncStatusProvider);
    final pendingCount = ref.watch(pendingSyncCountProvider);

    return syncStatus.when(
      data: (status) {
        if (status == SyncStatus.syncing) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                Text(
                  'Syncing data...',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (pendingCount.hasValue)
                  Text(
                    '${pendingCount.value} items remaining',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
} 