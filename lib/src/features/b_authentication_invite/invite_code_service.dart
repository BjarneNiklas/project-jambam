import 'package:supabase_flutter/supabase_flutter.dart';

class InviteCodeService {
  final SupabaseClient _client;
  InviteCodeService(this._client);

  Future<bool> validateInviteCode(String code) async {
    final response = await _client
        .from('invite_codes')
        .select('*')
        .eq('code', code)
        .eq('is_used', false)
        .maybeSingle();
    return response != null;
  }

  Future<bool> activateInviteCode(String code, String userId) async {
    final response = await _client
        .from('invite_codes')
        .update({
          'is_used': true,
          'used_by': userId,
          'used_at': DateTime.now().toIso8601String(),
        })
        .eq('code', code)
        .select()
        .maybeSingle();
    return response != null;
  }

  Future<bool> getInviteStatus(String userId) async {
    final response = await _client
        .from('invite_codes')
        .select('*')
        .eq('used_by', userId)
        .eq('is_used', true)
        .maybeSingle();
    return response != null;
  }
} 