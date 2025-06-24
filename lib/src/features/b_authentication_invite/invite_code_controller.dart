import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'invite_code_service.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final inviteCodeControllerProvider = StateNotifierProvider<InviteCodeController, InviteCodeState>((ref) {
  final client = ref.read(supabaseClientProvider);
  return InviteCodeController(InviteCodeService(client));
});

class InviteCodeState {
  final bool isLoading;
  final bool? isValid;
  final bool? isActivated;
  final String? error;
  final bool? hasValidInvite;

  InviteCodeState({
    this.isLoading = false,
    this.isValid,
    this.isActivated,
    this.error,
    this.hasValidInvite,
  });

  InviteCodeState copyWith({
    bool? isLoading,
    bool? isValid,
    bool? isActivated,
    String? error,
    bool? hasValidInvite,
  }) {
    return InviteCodeState(
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
      isActivated: isActivated ?? this.isActivated,
      error: error,
      hasValidInvite: hasValidInvite ?? this.hasValidInvite,
    );
  }
}

class InviteCodeController extends StateNotifier<InviteCodeState> {
  final InviteCodeService _service;
  InviteCodeController(this._service) : super(InviteCodeState());

  Future<void> validate(String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final valid = await _service.validateInviteCode(code);
      state = state.copyWith(isLoading: false, isValid: valid);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> activate(String code, String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final activated = await _service.activateInviteCode(code, userId);
      state = state.copyWith(isLoading: false, isActivated: activated);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> checkInviteStatus(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final hasInvite = await _service.getInviteStatus(userId);
      state = state.copyWith(isLoading: false, hasValidInvite: hasInvite);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
} 