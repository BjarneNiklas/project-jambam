import 'package:supabase_flutter/supabase_flutter.dart';

class UserManagementService {
  final SupabaseClient _client;
  UserManagementService(this._client);

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final response = await _client.from('users').select('*').order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    await _client.from('users').update({'role': newRole}).eq('id', userId);
  }

  Future<void> verifyUser(String userId) async {
    await _client.from('users').update({'is_verified': true}).eq('id', userId);
  }
} 