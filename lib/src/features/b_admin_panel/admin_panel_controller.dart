import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_management_service.dart';
import 'invite_code_management_service.dart';
import 'package:flutter/foundation.dart';

final adminPanelControllerProvider = StateNotifierProvider<AdminPanelController, AdminPanelState>((ref) {
  final client = Supabase.instance.client;
  return AdminPanelController(
    UserManagementService(client),
    InviteCodeManagementService(client),
  );
});

class AdminPanelState {
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> inviteCodes;
  final List<Map<String, dynamic>> auditLog;
  final int auditLogPage;
  final int auditLogTotal;
  final bool isLoading;
  final String? error;
  final Map<String, String> adminIdToName;

  AdminPanelState({
    this.users = const [],
    this.inviteCodes = const [],
    this.auditLog = const [],
    this.auditLogPage = 1,
    this.auditLogTotal = 0,
    this.isLoading = false,
    this.error,
    this.adminIdToName = const {},
  });

  AdminPanelState copyWith({
    List<Map<String, dynamic>>? users,
    List<Map<String, dynamic>>? inviteCodes,
    List<Map<String, dynamic>>? auditLog,
    int? auditLogPage,
    int? auditLogTotal,
    bool? isLoading,
    String? error,
    Map<String, String>? adminIdToName,
  }) {
    return AdminPanelState(
      users: users ?? this.users,
      inviteCodes: inviteCodes ?? this.inviteCodes,
      auditLog: auditLog ?? this.auditLog,
      auditLogPage: auditLogPage ?? this.auditLogPage,
      auditLogTotal: auditLogTotal ?? this.auditLogTotal,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      adminIdToName: adminIdToName ?? this.adminIdToName,
    );
  }
}

class AdminPanelController extends StateNotifier<AdminPanelState> {
  final UserManagementService _userService;
  final InviteCodeManagementService _inviteService;
  RealtimeChannel? _auditLogChannel;
  SupabaseClient get _client => Supabase.instance.client;
  VoidCallback? _onNewAuditLog;

  void setOnNewAuditLog(VoidCallback cb) {
    _onNewAuditLog = cb;
  }

  AdminPanelController(this._userService, this._inviteService) : super(AdminPanelState()) {
    _subscribeToAuditLog();
  }

  void _subscribeToAuditLog() {
    _auditLogChannel = _client.channel('public:admin_audit_log')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'admin_audit_log',
        callback: (payload) async {
          _onNewAuditLog?.call();
        },
      )
      ..subscribe();
  }

  @override
  void dispose() {
    if (_auditLogChannel != null) {
      _client.removeChannel(_auditLogChannel!);
    }
    super.dispose();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final users = await _userService.fetchUsers();
      final codes = await _inviteService.fetchInviteCodes();
      state = state.copyWith(users: users, inviteCodes: codes, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _userService.updateUserRole(userId, newRole);
      await loadData();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> verifyUser(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _userService.verifyUser(userId);
      await loadData();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createInviteCode(String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _inviteService.createInviteCode(code);
      await loadData();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteInviteCode(String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _inviteService.deleteInviteCode(code);
      await loadData();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchAuditLog({
    int page = 1,
    int pageSize = 20,
    String? action,
    String? adminId,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      var query = _client.from('admin_audit_log').select('*');
      if (action != null && action.isNotEmpty) query = query.eq('action', action);
      if (adminId != null && adminId.isNotEmpty) query = query.ilike('admin_id', '%$adminId%');
      if (dateFrom != null) query = query.gte('created_at', dateFrom.toIso8601String());
      if (dateTo != null) query = query.lte('created_at', dateTo.toIso8601String());
      final from = (page - 1) * pageSize;
      final to = from + pageSize - 1;
      final dataRes = await query.order('created_at', ascending: false).range(from, to);
      var countQuery = _client.from('admin_audit_log').select('*');
      if (action != null && action.isNotEmpty) countQuery = countQuery.eq('action', action);
      if (adminId != null && adminId.isNotEmpty) countQuery = countQuery.ilike('admin_id', '%$adminId%');
      if (dateFrom != null) countQuery = countQuery.gte('created_at', dateFrom.toIso8601String());
      if (dateTo != null) countQuery = countQuery.lte('created_at', dateTo.toIso8601String());
      final countRes = await countQuery;
      final count = countRes.length;
      final List<String> adminIds = [
        ...{for (final row in dataRes) if (row['admin_id'] != null) row['admin_id'].toString()}
      ];
      Map<String, String> idToName = {};
      if (adminIds.isNotEmpty) {
        final idList = adminIds.map((e) => "'${e.replaceAll("'", "''")}'").join(',');
        final userRows = await _client.from('users').select('id,username,email').filter('id', 'in', '($idList)');
        for (final u in userRows) {
          idToName[u['id']] = u['username'] ?? u['email'] ?? u['id'];
        }
      }
      state = state.copyWith(
        auditLog: List<Map<String, dynamic>>.from(dataRes),
        auditLogPage: page,
        auditLogTotal: count,
        adminIdToName: idToName,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  String getAdminName(String? id) {
    if (id == null) return '-';
    return state.adminIdToName[id] ?? id;
  }
} 