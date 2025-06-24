import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admin_panel_controller.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';

class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen> with TickerProviderStateMixin {
  int _tabIndex = 0;
  final _inviteCodeController = TextEditingController();
  final _auditLogSearchController = TextEditingController();
  late TabController _tabController;
  String _auditLogSearch = '';
  String _auditLogAction = '';
  String _auditLogAdmin = '';
  DateTime? _auditLogDateFrom;
  DateTime? _auditLogDateTo;
  Map<String, dynamic>? _auditLogDetail;
  int _auditLogPage = 1;
  int _auditLogTotal = 0;
  bool _auditLogLoading = false;
  static const int _auditLogPageSize = 20;
  bool _auditLogExporting = false;
  bool _hasNewAuditLog = false;

  void _updateUrlWithAuditId(String? auditId) {
    // URL update functionality simplified for cross-platform compatibility
    if (kIsWeb) {
      final uri = Uri.parse(web.window.location.href);
      final queryParams = Map<String, String>.from(uri.queryParameters);
      if (auditId != null) {
        queryParams['audit_id'] = auditId;
      } else {
        queryParams.remove('audit_id');
      }
      final newUri = uri.replace(queryParameters: queryParams);
      // Korrektur: Verwendung von null für den state-Parameter, um den Fehler zu umgehen
      web.window.history.pushState(null, '', newUri.toString());
    }
  }

  void _checkUrlForAuditId() {
    if (kIsWeb) {
      final uri = Uri.parse(web.window.location.href);
      final auditId = uri.queryParameters['audit_id'];
      if (auditId != null && _auditLogDetail == null) {
        // Finde den Eintrag in der aktuellen Liste
        final state = ref.read(adminPanelControllerProvider);
        final entry = state.auditLog.firstWhere(
          (e) => e['id']?.toString() == auditId,
          orElse: () => {},
        );
        if (entry.isNotEmpty) {
          setState(() => _auditLogDetail = entry);
        }
      }
    }
  }

  void _fetchAuditLog({int page = 1}) async {
    setState(() => _auditLogLoading = true);
    await ref.read(adminPanelControllerProvider.notifier).fetchAuditLog(
      page: page,
      pageSize: _auditLogPageSize,
      action: _auditLogAction.isNotEmpty ? _auditLogAction : null,
      adminId: _auditLogAdmin.isNotEmpty ? _auditLogAdmin : null,
      dateFrom: _auditLogDateFrom,
      dateTo: _auditLogDateTo,
    );
    final state = ref.read(adminPanelControllerProvider);
    setState(() {
      _auditLogPage = state.auditLogPage;
      _auditLogTotal = state.auditLogTotal;
      _auditLogLoading = false;
    });
    // Nach dem Laden: Prüfe URL für Deep-Link
    _checkUrlForAuditId();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 3) {
        _fetchAuditLog(page: 1);
      }
      setState(() => _tabIndex = _tabController.index);
    });
    Future.microtask(() => ref.read(adminPanelControllerProvider.notifier).loadData());
    // Live-Update-Callback abonnieren
    ref.read(adminPanelControllerProvider.notifier).setOnNewAuditLog(() {
      if (mounted && _tabIndex == 3) {
        setState(() => _hasNewAuditLog = true);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inviteCodeController.dispose();
    _auditLogSearchController.dispose();
    super.dispose();
  }

  void _showSnackbar(String message, {bool error = false}) {
    final context = this.context;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _confirmDeleteInviteCode(String code) async {
    final context = this.context;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Einladungscode löschen?'),
        content: Text('Möchtest du den Einladungscode "$code" wirklich löschen?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Abbrechen')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Löschen')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(adminPanelControllerProvider.notifier).deleteInviteCode(code);
      _showSnackbar('Einladungscode gelöscht');
    }
  }

  Future<void> _exportAuditLog({required String format}) async {
    setState(() => _auditLogExporting = true);
    try {
      // Hole alle Audit-Log-Einträge mit aktuellen Filtern (ohne Pagination)
      await ref.read(adminPanelControllerProvider.notifier).fetchAuditLog(
        page: 1,
        pageSize: 10000, // Annahme: max. 10.000 Einträge für Export
        action: _auditLogAction.isNotEmpty ? _auditLogAction : null,
        adminId: _auditLogAdmin.isNotEmpty ? _auditLogAdmin : null,
        dateFrom: _auditLogDateFrom,
        dateTo: _auditLogDateTo,
      );
      final state = ref.read(adminPanelControllerProvider);
      final entries = state.auditLog;
      final now = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filename = 'auditlog_export_$now.$format';
      String content = '';
      if (format == 'json') {
        content = const JsonEncoder.withIndent('  ').convert(entries);
      } else if (format == 'csv') {
        if (entries.isEmpty) {
          content = '';
        } else {
          final headers = entries.first.keys.toList();
          final csvRows = <String>[];
          csvRows.add(headers.join(','));
          for (final row in entries) {
            csvRows.add(headers.map((h) => '"${row[h]?.toString().replaceAll('"', '""') ?? ''}"').join(','));
          }
          content = csvRows.join('\n');
        }
      }
      // Download/Teilen
      if (kIsWeb) {
        // Web: Download als Datei
          final bytes = utf8.encode(content);
          // Korrektur: Konvertierung der Dart-Liste zu JSArray
          final blob = web.Blob([bytes.toJS].toJS);
          final url = web.URL.createObjectURL(blob);
          web.HTMLAnchorElement()
            ..href = url
            ..setAttribute('download', filename)
            ..click();
          web.URL.revokeObjectURL(url);
      }
      // Mobile/Desktop: In Zwischenablage oder als Datei speichern
      await Clipboard.setData(ClipboardData(text: content));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Audit-Log als $format exportiert! (Dateiname: $filename)')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Export: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _auditLogExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminPanelControllerProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(title: const Text('Admin-Panel')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                TabBar(
                  controller: _tabController,
                  onTap: (i) => setState(() => _tabIndex = i),
                  tabs: const [
                    Tab(text: 'Benutzer'),
                    Tab(text: 'Einladungscodes'),
                    Tab(text: 'Statistiken'),
                    Tab(text: 'Audit-Log'),
                  ],
                ),
                Expanded(
                  child: IndexedStack(
                    index: _tabIndex,
                    children: [
                      isMobile ? _buildUserListMobile(state) : _buildUserTab(state),
                      isMobile ? _buildInviteCodeListMobile(state) : _buildInviteCodeTab(state),
                      _buildStatsTab(state),
                      _buildAuditLogTab(state),
                    ],
                  ),
                ),
                if (state.error != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(state.error!, style: const TextStyle(color: Colors.red)),
                  ),
              ],
            ),
    );
  }

  Widget _buildUserTab(AdminPanelState state) {
    return ListView(
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('E-Mail')),
            DataColumn(label: Text('Rolle')),
            DataColumn(label: Text('Verifiziert')),
            DataColumn(label: Text('Aktionen')),
          ],
          rows: state.users.map((user) {
            return DataRow(cells: [
              DataCell(Text(user['username'] ?? '')),
              DataCell(Text(user['email'] ?? '')),
              DataCell(_buildRoleDropdown(user)),
              DataCell(user['is_verified'] == true
                  ? const Icon(Icons.verified, color: Colors.green)
                  : IconButton(
                      icon: const Icon(Icons.verified_outlined),
                      onPressed: () async {
                        await ref.read(adminPanelControllerProvider.notifier).verifyUser(user['id']);
                        _showSnackbar('Benutzer verifiziert');
                      },
                    )),
              DataCell(const SizedBox()),
            ]);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildUserListMobile(AdminPanelState state) {
    return ListView(
      children: state.users.map((user) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(user['username'] ?? ''),
            subtitle: Text(user['email'] ?? ''),
            trailing: PopupMenuButton<String>(
              onSelected: (role) async {
                await ref.read(adminPanelControllerProvider.notifier).updateUserRole(user['id'], role);
                _showSnackbar('Rolle geändert');
              },
              itemBuilder: (ctx) => ['user', 'moderator', 'admin', 'superadmin']
                  .map((role) => PopupMenuItem(value: role, child: Text(role)))
                  .toList(),
              child: Chip(label: Text(user['role'] ?? 'user')),
            ),
            leading: user['is_verified'] == true
                ? const Icon(Icons.verified, color: Colors.green)
                : IconButton(
                    icon: const Icon(Icons.verified_outlined),
                    onPressed: () async {
                      await ref.read(adminPanelControllerProvider.notifier).verifyUser(user['id']);
                      _showSnackbar('Benutzer verifiziert');
                    },
                  ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRoleDropdown(Map<String, dynamic> user) {
    final roles = ['user', 'moderator', 'admin', 'superadmin'];
    return DropdownButton<String>(
      value: user['role'],
      items: roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
      onChanged: (newRole) async {
        if (newRole != null) {
          await ref.read(adminPanelControllerProvider.notifier).updateUserRole(user['id'], newRole);
          _showSnackbar('Rolle geändert');
        }
      },
    );
  }

  Widget _buildInviteCodeTab(AdminPanelState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inviteCodeController,
                  decoration: const InputDecoration(labelText: 'Neuer Einladungscode'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  final code = _inviteCodeController.text.trim();
                  if (code.isNotEmpty) {
                    await ref.read(adminPanelControllerProvider.notifier).createInviteCode(code);
                    _inviteCodeController.clear();
                    _showSnackbar('Einladungscode erstellt');
                  }
                },
                child: const Text('Erstellen'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: state.inviteCodes.map((invite) {
              return ListTile(
                title: Text(invite['code'] ?? ''),
                subtitle: Text(invite['is_used'] == true ? 'Verwendet' : 'Verfügbar'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: invite['is_used'] == true
                      ? null
                      : () => _confirmDeleteInviteCode(invite['code']),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInviteCodeListMobile(AdminPanelState state) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inviteCodeController,
                  decoration: const InputDecoration(labelText: 'Neuer Einladungscode'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  final code = _inviteCodeController.text.trim();
                  if (code.isNotEmpty) {
                    await ref.read(adminPanelControllerProvider.notifier).createInviteCode(code);
                    _inviteCodeController.clear();
                    _showSnackbar('Einladungscode erstellt');
                  }
                },
                child: const Text('Erstellen'),
              ),
            ],
          ),
        ),
        ...state.inviteCodes.map((invite) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(invite['code'] ?? ''),
              subtitle: Text(invite['is_used'] == true ? 'Verwendet' : 'Verfügbar'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: invite['is_used'] == true
                    ? null
                    : () => _confirmDeleteInviteCode(invite['code']),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatsTab(AdminPanelState state) {
    final userCount = state.users.length;
    final inviteCount = state.inviteCodes.length;
    final usedCount = state.inviteCodes.where((c) => c['is_used'] == true).length;
    final roleCounts = <String, int>{};
    for (final user in state.users) {
      final role = user['role'] ?? 'user';
      roleCounts[role] = (roleCounts[role] ?? 0) + 1;
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Benutzer insgesamt'),
              trailing: Text('$userCount'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.vpn_key),
              title: const Text('Einladungscodes insgesamt'),
              trailing: Text('$inviteCount'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Verwendete Einladungscodes'),
              trailing: Text('$usedCount'),
            ),
          ),
          const SizedBox(height: 16),
          Text('Rollenverteilung', style: Theme.of(context).textTheme.titleMedium),
          ...roleCounts.entries.map((e) => ListTile(
                leading: const Icon(Icons.person),
                title: Text(e.key),
                trailing: Text('${e.value}'),
              )),
        ],
      ),
    );
  }

  Widget _buildAuditLogTab(AdminPanelState state) {
    final actions = state.auditLog.map((e) => e['action'] as String? ?? '').toSet().toList()..sort();
    final filtered = state.auditLog.where((entry) {
      final q = _auditLogSearch.toLowerCase();
      final actionMatch = _auditLogAction.isEmpty || entry['action'] == _auditLogAction;
      final adminMatch = _auditLogAdmin.isEmpty || (entry['admin_id']?.toString().toLowerCase().contains(_auditLogAdmin.toLowerCase()) ?? false);
      final dateFromMatch = _auditLogDateFrom == null || (entry['created_at'] != null && DateTime.tryParse(entry['created_at'])?.isAfter(_auditLogDateFrom!.subtract(const Duration(days: 1))) == true);
      final dateToMatch = _auditLogDateTo == null || (entry['created_at'] != null && DateTime.tryParse(entry['created_at'])?.isBefore(_auditLogDateTo!.add(const Duration(days: 1))) == true);
      final searchMatch =
        q.isEmpty ||
        (entry['action']?.toString().toLowerCase().contains(q) ?? false) ||
        (entry['admin_id']?.toString().toLowerCase().contains(q) ?? false) ||
        (entry['target_type']?.toString().toLowerCase().contains(q) ?? false) ||
        (entry['target_id']?.toString().toLowerCase().contains(q) ?? false) ||
        (entry['details']?.toString().toLowerCase().contains(q) ?? false);
      return actionMatch && adminMatch && dateFromMatch && dateToMatch && searchMatch;
    }).toList();
    final totalPages = (_auditLogTotal / _auditLogPageSize).ceil().clamp(1, 9999);
    return Column(
      children: [
        if (_hasNewAuditLog)
          MaterialBanner(
            content: const Text('Neue Audit-Log-Einträge verfügbar'),
            actions: [
              TextButton(
                onPressed: () {
                  _fetchAuditLog(page: _auditLogPage);
                  setState(() => _hasNewAuditLog = false);
                },
                child: const Text('Aktualisieren'),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Export CSV'),
                onPressed: _auditLogExporting ? null : () => _exportAuditLog(format: 'csv'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Export JSON'),
                onPressed: _auditLogExporting ? null : () => _exportAuditLog(format: 'json'),
              ),
              if (_auditLogExporting)
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 180,
                child: TextField(
                  controller: _auditLogSearchController,
                  decoration: const InputDecoration(
                    labelText: 'Suche',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) {
                    setState(() => _auditLogSearch = v);
                    _fetchAuditLog(page: 1);
                  },
                ),
              ),
              SizedBox(
                width: 160,
                child: DropdownButtonFormField<String>(
                  value: _auditLogAction.isEmpty ? null : _auditLogAction,
                  items: [const DropdownMenuItem(value: '', child: Text('Alle Aktionen'))] +
                      actions.map((a) => DropdownMenuItem(
                        value: a, 
                        child: Text('${_translateAction(a)} ($a)')
                      )).toList(),
                  onChanged: (v) {
                    setState(() => _auditLogAction = v ?? '');
                    _fetchAuditLog(page: 1);
                  },
                  decoration: const InputDecoration(labelText: 'Aktion'),
                ),
              ),
              SizedBox(
                width: 140,
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Admin-ID'),
                  onChanged: (v) {
                    setState(() => _auditLogAdmin = v);
                    _fetchAuditLog(page: 1);
                  },
                ),
              ),
              SizedBox(
                width: 140,
                child: InputDatePickerFormField(
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  initialDate: _auditLogDateFrom,
                  fieldLabelText: 'Von',
                  onDateSubmitted: (d) {
                    setState(() => _auditLogDateFrom = d);
                    _fetchAuditLog(page: 1);
                  },
                  onDateSaved: (d) {
                    setState(() => _auditLogDateFrom = d);
                    _fetchAuditLog(page: 1);
                  },
                ),
              ),
              SizedBox(
                width: 140,
                child: InputDatePickerFormField(
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  initialDate: _auditLogDateTo,
                  fieldLabelText: 'Bis',
                  onDateSubmitted: (d) {
                    setState(() => _auditLogDateTo = d);
                    _fetchAuditLog(page: 1);
                  },
                  onDateSaved: (d) {
                    setState(() => _auditLogDateTo = d);
                    _fetchAuditLog(page: 1);
                  },
                ),
              ),
            ],
          ),
        ),
        if (_auditLogLoading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Keine Audit-Log-Einträge gefunden.'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final entry = filtered[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.history),
                          title: Text('${_translateAction(entry['action'])} (${entry['target_type']})'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Tooltip(
                                message: '${ref.read(adminPanelControllerProvider.notifier).getAdminName(entry['admin_id'])} (ID: ${entry['admin_id']})',
                                child: Row(
                                  children: [
                                    Text('Admin: ${ref.read(adminPanelControllerProvider.notifier).getAdminName(entry['admin_id'])}'),
                                    const SizedBox(width: 8),
                                    Text(
                                      '(${entry['admin_id']})',
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Text('Ziel: ${entry['target_id'] ?? '-'}'),
                              if (entry['details'] != null)
                                Text('Details: ${entry['details']}'),
                            ],
                          ),
                          trailing: Text(
                            entry['created_at'] != null
                                ? DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(entry['created_at']))
                                : '',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          onTap: () {
                            setState(() => _auditLogDetail = entry);
                            _updateUrlWithAuditId(entry['id']?.toString());
                          },
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _auditLogPage > 1 && !_auditLogLoading
                      ? () => _fetchAuditLog(page: _auditLogPage - 1)
                      : null,
                ),
                Text('Seite $_auditLogPage / $totalPages ($_auditLogTotal Einträge)'),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _auditLogPage < totalPages && !_auditLogLoading
                      ? () => _fetchAuditLog(page: _auditLogPage + 1)
                      : null,
                ),
              ],
            ),
          ),
        ],
        if (_auditLogDetail != null)
          _buildAuditLogDetailsModal(_auditLogDetail!),
      ],
    );
  }

  Widget _buildAuditLogDetailsModal(Map<String, dynamic> entry) {
    String prettyJson(Map<String, dynamic> json) {
      try {
        return const JsonEncoder.withIndent('  ').convert(json);
      } catch (_) {
        return json.toString();
      }
    }
    final details = entry['details'];
    Map<String, dynamic>? oldVals;
    Map<String, dynamic>? newVals;
    if (details is Map && details.containsKey('old') && details.containsKey('new')) {
      oldVals = details['old'] is String ? jsonDecode(details['old']) : details['old'];
      newVals = details['new'] is String ? jsonDecode(details['new']) : details['new'];
    }
    final isUpdate = entry['action']?.toString().toLowerCase().contains('update') == true && oldVals != null && newVals != null;
    return StatefulBuilder(
      builder: (ctx, setState) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700, minWidth: 320),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Audit-Log-Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() => _auditLogDetail = null);
                      _updateUrlWithAuditId(null);
                    },
                  ),
                ],
              ),
              if (isUpdate)
                TabBar(
                  onTap: (i) => setState(() => _tabIndex = i),
                  tabs: const [Tab(text: 'Rohdaten'), Tab(text: 'Änderungen')],
                  controller: TabController(length: 2, vsync: NavigatorState()),
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Colors.grey,
                ),
              const SizedBox(height: 16),
              if (!isUpdate || _tabIndex == 0)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...entry.entries.map((e) {
                          final isJson = e.value is Map || e.value is List || (e.value is String && (e.value.toString().startsWith('{') || e.value.toString().startsWith('[')));
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(_translateField(e.key), style: const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: e.key == 'admin_id' 
                                    ? Tooltip(
                                        message: '${ref.read(adminPanelControllerProvider.notifier).getAdminName(e.value)} (ID: ${e.value})',
                                        child: Row(
                                          children: [
                                            Text(ref.read(adminPanelControllerProvider.notifier).getAdminName(e.value)),
                                            const SizedBox(width: 8),
                                            Text(
                                              '(${e.value})',
                                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      )
                                    : isJson
                                        ? Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            child: SelectableText(
                                              prettyJson(e.value is String ? jsonDecode(e.value) : e.value),
                                              style: const TextStyle(fontFamily: 'monospace', color: Colors.blueGrey),
                                            ),
                                          )
                                        : SelectableText(e.value?.toString() ?? ''),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              if (isUpdate && _tabIndex == 1)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildDiffColumn('Vorher', oldVals, newVals, isOld: true),
                        ),
                        const VerticalDivider(width: 32),
                        Expanded(
                          child: _buildDiffColumn('Nachher', newVals, oldVals, isOld: false),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          tooltip: 'Diff als JSON kopieren',
                          onPressed: () => Clipboard.setData(ClipboardData(text: prettyJson({'old': oldVals, 'new': newVals}))),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiffColumn(String title, Map<String, dynamic>? mainVals, Map<String, dynamic>? compareVals, {required bool isOld}) {
    if (mainVals == null || compareVals == null) {
      return const Text('Keine Daten verfügbar');
    }
    final allKeys = <String>{...mainVals.keys, ...compareVals.keys};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...allKeys.map((k) {
          final mainVal = mainVals[k];
          final compareVal = compareVals[k];
          final changed = mainVal != compareVal;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: changed
                  ? (isOld ? Colors.red[50] : Colors.green[50])
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(k, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Expanded(
                  child: SelectableText(
                    mainVal?.toString() ?? '-',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: changed
                          ? (isOld ? Colors.red : Colors.green)
                          : Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _translateField(String key) {
    const translations = {
      'id': 'ID',
      'admin_id': 'Administrator',
      'action': 'Aktion',
      'target_type': 'Ziel-Typ',
      'target_id': 'Ziel-ID',
      'details': 'Details',
      'created_at': 'Erstellt am',
      'old': 'Vorher',
      'new': 'Nachher',
    };
    return translations[key] ?? key;
  }

  String _translateAction(String action) {
    const translations = {
      'create': 'Erstellen',
      'update': 'Aktualisieren',
      'delete': 'Löschen',
      'login': 'Anmeldung',
      'logout': 'Abmeldung',
      'role_change': 'Rollenänderung',
      'invite_create': 'Einladung erstellen',
      'invite_delete': 'Einladung löschen',
      'user_verify': 'Benutzer verifizieren',
    };
    return translations[action] ?? action;
  }
}
