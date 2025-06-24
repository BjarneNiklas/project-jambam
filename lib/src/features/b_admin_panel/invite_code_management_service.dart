import 'package:supabase_flutter/supabase_flutter.dart';

class InviteCodeManagementService {
  final SupabaseClient _client;
  InviteCodeManagementService(this._client);

  Future<List<Map<String, dynamic>>> fetchInviteCodes() async {
    final response = await _client.from('invite_codes').select('*').order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<bool> createInviteCode(String code) async {
    final response = await _client.from('invite_codes').insert({'code': code}).select().maybeSingle();
    return response != null;
  }

  Future<bool> deleteInviteCode(String code) async {
    final response = await _client.from('invite_codes').delete().eq('code', code).select().maybeSingle();
    return response != null;
  }
} 