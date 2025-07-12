import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ai_settings_service.dart';

class AISettingsController extends StateNotifier<AsyncValue<AISettingsService>> {
  AISettingsController() : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final service = await AISettingsService.create();
      state = AsyncValue.data(service);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Called from the UI to save settings in a stateless way
  Future<void> saveSettingsFromUI(WidgetRef ref) async {
    final service = state.value;
    if (service == null) return;
    // You may want to pass the new settings from the UI as parameters
    // For now, just reload settings as a placeholder
    final newService = await AISettingsService.create();
    state = AsyncValue.data(newService);
  }
}

final aiSettingsControllerProvider =
    StateNotifierProvider<AISettingsController, AsyncValue<AISettingsService>>(
        (ref) => AISettingsController()); 