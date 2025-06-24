import React, { useState, useEffect, useCallback } from 'react';
import { supabase } from '../lib/supabase';
import { useTranslation } from 'react-i18next';
import './AdminPanel.css';

interface InviteCode {
  code: string;
  is_used: boolean;
  used_by: string | null;
  created_at: string;
  used_at: string | null;
  user_email?: string;
}

interface User {
  id: string;
  username: string;
  email: string;
  role: string;
  is_verified: boolean;
  created_at: string;
  last_login: string | null;
}

interface AuditLogEntry {
  id: number;
  admin_id: string;
  action: string;
  target_type: string;
  target_id: string;
  details: any;
  created_at: string;
}

const PAGE_SIZE = 20;

const AdminPanel: React.FC = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [inviteCodes, setInviteCodes] = useState<InviteCode[]>([]);
  const [newInviteCode, setNewInviteCode] = useState('');
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<'invites' | 'users' | 'system' | 'audit'>('invites');
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [auditLog, setAuditLog] = useState<AuditLogEntry[]>([]);
  const [auditLogLoading, setAuditLogLoading] = useState(false);
  const [auditLogSearch, setAuditLogSearch] = useState('');
  const [auditLogAction, setAuditLogAction] = useState('');
  const [auditLogAdmin, setAuditLogAdmin] = useState('');
  const [auditLogDateFrom, setAuditLogDateFrom] = useState('');
  const [auditLogDateTo, setAuditLogDateTo] = useState('');
  const [auditLogDetail, setAuditLogDetail] = useState<AuditLogEntry | null>(null);
  const [auditLogPage, setAuditLogPage] = useState(1);
  const [auditLogTotal, setAuditLogTotal] = useState(0);
  const [adminIdToName, setAdminIdToName] = useState<Record<string, string>>({});

  // Deep-Link Funktionen
  const updateUrlWithAuditId = useCallback((auditId: string | null) => {
    const url = new URL(window.location.href);
    if (auditId) {
      url.searchParams.set('audit_id', auditId);
    } else {
      url.searchParams.delete('audit_id');
    }
    window.history.pushState({}, '', url.toString());
  }, []);

  const checkUrlForAuditId = useCallback(() => {
    const url = new URL(window.location.href);
    const auditId = url.searchParams.get('audit_id');
    if (auditId && !auditLogDetail) {
      const entry = auditLog.find(e => e.id.toString() === auditId);
      if (entry) {
        setAuditLogDetail(entry);
      }
    }
  }, [auditLogDetail, auditLog]);

  // Admin-Name-Resolver
  const getAdminName = useCallback((adminId: string | null) => {
    if (!adminId) return '-';
    return adminIdToName[adminId] || adminId;
  }, [adminIdToName]);

  // Deutsche Übersetzungen
  const translateAction = useCallback((action: string) => {
    const translations: Record<string, string> = {
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
    return translations[action] || action;
  }, []);

  const translateField = useCallback((key: string) => {
    const translations: Record<string, string> = {
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
    return translations[key] || key;
  }, []);

  const fetchCurrentUser = useCallback(async () => {
    const { data: { user } } = await supabase.auth.getUser();
    if (user) {
      const { data } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user.id)
        .single();
      setCurrentUser(data);
    }
  }, []);

  const fetchData = useCallback(async () => {
    setLoading(true);
    
    const { data: inviteData, error: inviteError } = await supabase
      .from('invite_codes')
      .select(`
        *,
        profiles!invite_codes_used_by_fkey(email)
      `)
      .order('created_at', { ascending: false });

    if (inviteError) {
      console.error('Error fetching invite codes:', inviteError);
    } else {
      setInviteCodes(inviteData || []);
    }

    const { data: userData, error: userError } = await supabase
      .from('profiles')
      .select('*')
      .order('created_at', { ascending: false });

    if (userError) {
      console.error('Error fetching users:', userError);
    } else {
      setUsers(userData || []);
    }

    setLoading(false);
  }, []);

  const fetchAuditLog = useCallback(async () => {
    setAuditLogLoading(true);
    // Build filter
    let query = supabase.from('admin_audit_log').select('*', { count: 'exact' });
    if (auditLogAction) query = query.eq('action', auditLogAction);
    if (auditLogAdmin) query = query.ilike('admin_id', `%${auditLogAdmin}%`);
    if (auditLogDateFrom) query = query.gte('created_at', auditLogDateFrom);
    if (auditLogDateTo) query = query.lte('created_at', auditLogDateTo + 'T23:59:59');
    if (auditLogSearch) {
      // Supabase/Postgres: Volltextsuche ist limitiert, daher clientseitig für Demo
    }
    const from = (auditLogPage - 1) * PAGE_SIZE;
    const to = from + PAGE_SIZE - 1;
    query = query.order('created_at', { ascending: false }).range(from, to);
    const { data, error, count } = await query;
    if (!error && data) {
      setAuditLog(data);
      setAuditLogTotal(count || 0);
      
      // Admin-IDs sammeln und Namen auflösen
      const adminIds = Array.from(new Set(data.map(row => row.admin_id).filter(Boolean)));
      if (adminIds.length > 0) {
        const { data: userRows } = await supabase
          .from('profiles')
          .select('id,username,email')
          .in('id', adminIds);
        
        const idToName: Record<string, string> = {};
        if (userRows) {
          userRows.forEach(u => {
            idToName[u.id] = u.username || u.email || u.id;
          });
        }
        setAdminIdToName(idToName);
      }
    }
    setAuditLogLoading(false);
  }, [auditLogAction, auditLogAdmin, auditLogDateFrom, auditLogDateTo, auditLogPage]);

  useEffect(() => {
    fetchData();
    fetchCurrentUser();
    // eslint-disable-next-line
  }, [fetchData, fetchCurrentUser]);

  useEffect(() => {
    if (activeTab === 'audit') {
      fetchAuditLog();
    }
    // eslint-disable-next-line
  }, [activeTab, fetchAuditLog]);

  useEffect(() => {
    // Nach dem Laden: Prüfe URL für Deep-Link
    checkUrlForAuditId();
  }, [checkUrlForAuditId, auditLog]);

  const generateInviteCode = useCallback(async () => {
    if (!newInviteCode.trim()) return;

    const { error } = await supabase
      .from('invite_codes')
      .insert({ code: newInviteCode.trim() });

    if (error) {
      console.error('Error creating invite code:', error);
      alert('Fehler beim Erstellen des Invite-Codes');
    } else {
      setNewInviteCode('');
      fetchData(); // Re-fetch data
    }
  }, [newInviteCode, fetchData]);

  const deleteInviteCode = useCallback(async (code: string) => {
    if (!window.confirm('Invite-Code wirklich löschen?')) return;

    const { error } = await supabase
      .from('invite_codes')
      .delete()
      .eq('code', code);

    if (error) {
      console.error('Error deleting invite code:', error);
      alert('Fehler beim Löschen des Invite-Codes');
    } else {
      fetchData(); // Re-fetch data
    }
  }, [fetchData]);

  const updateUserRole = useCallback(async (userId: string, newRole: string) => {
    if (!currentUser) return;
    
    const roleHierarchy = {
      'user': 0,
      'moderator': 1,
      'admin': 2,
      'superadmin': 3
    };

    const targetUser = users.find(u => u.id === userId);
    const targetUserLevel = roleHierarchy[targetUser?.role as keyof typeof roleHierarchy] || 0;
    const newRoleLevel = roleHierarchy[newRole as keyof typeof roleHierarchy] || 0;

    if (currentUser.role === 'superadmin' || 
        (currentUser.role === 'admin' && newRoleLevel <= 1 && targetUserLevel <= 1)) {
      
      const { error } = await supabase
        .from('profiles')
        .update({ role: newRole })
        .eq('id', userId);

      if (error) {
        console.error('Error updating user role:', error);
        alert('Fehler beim Aktualisieren der Benutzerrolle');
      } else {
        fetchData(); // Re-fetch data
      }
    } else {
      alert('Keine Berechtigung für diese Aktion');
    }
  }, [currentUser, users, fetchData]);

  const canManageRole = useCallback((targetRole: string) => {
    if (!currentUser) return false;
    
    const roleHierarchy = {
      'user': 0,
      'moderator': 1,
      'admin': 2,
      'superadmin': 3
    };

    const currentUserLevel = roleHierarchy[currentUser.role as keyof typeof roleHierarchy] || 0;
    const targetRoleLevel = roleHierarchy[targetRole as keyof typeof roleHierarchy] || 0;

    if (currentUser.role === 'superadmin') return true;
    if (currentUser.role === 'admin' && currentUserLevel > targetRoleLevel) return true;
    return false;
  }, [currentUser]);

  const getRoleColor = (role: string) => {
    switch (role) {
      case 'superadmin': return '#ff6b6b';
      case 'admin': return '#4ecdc4';
      case 'moderator': return '#45b7d1';
      case 'user': return '#96ceb4';
      default: return '#a1a1aa';
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleString('de-DE');
  };

  const isAdmin = currentUser && ['admin', 'superadmin'].includes(currentUser.role);

  // Aktionen für Dropdown extrahieren
  const auditActions = Array.from(new Set(auditLog.map(e => e.action))).sort();

  if (loading) {
    return (
      <div className="admin-panel">
        <div className="loading">Lade Admin-Panel...</div>
      </div>
    );
  }

  return (
    <div className="admin-panel">
      <div className="admin-header">
        <h1>🔧 Admin-Panel</h1>
        <p>Verwaltung von Einladungscodes und Benutzern</p>
        {currentUser && (
          <div className="user-info">
            <span>Angemeldet als: <b>{currentUser.email}</b></span>
            {currentUser.role && <span> (Rolle: {currentUser.role})</span>}
          </div>
        )}
      </div>

      <div className="admin-tabs">
        <button
          className={`tab ${activeTab === 'invites' ? 'active' : ''}`}
          onClick={() => setActiveTab('invites')}
        >
          📋 Einladungscodes ({inviteCodes.length})
        </button>
        <button
          className={`tab ${activeTab === 'users' ? 'active' : ''}`}
          onClick={() => setActiveTab('users')}
        >
          👥 Benutzer ({users.length})
        </button>
        {currentUser?.role === 'superadmin' && (
          <button
            className={`tab ${activeTab === 'system' ? 'active' : ''}`}
            onClick={() => setActiveTab('system')}
          >
            ⚙️ System
          </button>
        )}
        {isAdmin && (
          <button
            className={`tab ${activeTab === 'audit' ? 'active' : ''}`}
            onClick={() => setActiveTab('audit')}
          >
            📝 Audit-Log
          </button>
        )}
      </div>

      {activeTab === 'invites' && (
        <div className="admin-section">
          <div className="section-header">
            <h2>Neuen Einladungscode erstellen</h2>
          </div>
          
          <div className="create-invite">
            <input
              type="text"
              value={newInviteCode}
              onChange={(e) => setNewInviteCode(e.target.value)}
              placeholder="Neuer Einladungscode..."
              className="invite-input"
            />
            <button 
              onClick={generateInviteCode}
              disabled={!newInviteCode.trim()}
              className="create-btn"
            >
              Erstellen
            </button>
          </div>

          <div className="invite-codes-list">
            <h3>Alle Einladungscodes</h3>
            <div className="table-container">
              <table>
                <thead>
                  <tr>
                    <th>Code</th>
                    <th>Status</th>
                    <th>Verwendet von</th>
                    <th>Erstellt</th>
                    <th>Verwendet</th>
                    <th>Aktionen</th>
                  </tr>
                </thead>
                <tbody>
                  {inviteCodes.map((invite) => (
                    <tr key={invite.code}>
                      <td>
                        <code className="invite-code">{invite.code}</code>
                      </td>
                      <td>
                        <span className={`status ${invite.is_used ? 'used' : 'unused'}`}>
                          {invite.is_used ? '✅ Verwendet' : '⏳ Verfügbar'}
                        </span>
                      </td>
                      <td>
                        {invite.is_used ? (
                          invite.user_email || 'Unbekannt'
                        ) : (
                          '-'
                        )}
                      </td>
                      <td>{formatDate(invite.created_at)}</td>
                      <td>
                        {invite.used_at ? formatDate(invite.used_at) : '-'}
                      </td>
                      <td>
                        <button
                          onClick={() => deleteInviteCode(invite.code)}
                          className="delete-btn"
                          disabled={invite.is_used}
                        >
                          🗑️ Löschen
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {activeTab === 'users' && (
        <div className="admin-section">
          <div className="users-list">
            <h3>Alle Benutzer</h3>
            <div className="table-container">
              <table>
                <thead>
                  <tr>
                    <th>Benutzername</th>
                    <th>E-Mail</th>
                    <th>Rolle</th>
                    <th>Verifiziert</th>
                    <th>Registriert</th>
                    <th>Letzter Login</th>
                    <th>Aktionen</th>
                  </tr>
                </thead>
                <tbody>
                  {users.map((user) => (
                    <tr key={user.id}>
                      <td>{user.username}</td>
                      <td>{user.email}</td>
                      <td>
                        <span 
                          className="role-badge"
                          style={{ backgroundColor: getRoleColor(user.role) }}
                        >
                          {user.role.toUpperCase()}
                        </span>
                      </td>
                      <td>
                        <span className={`status ${user.is_verified ? 'verified' : 'unverified'}`}>
                          {user.is_verified ? '✅ Ja' : '❌ Nein'}
                        </span>
                      </td>
                      <td>{formatDate(user.created_at)}</td>
                      <td>
                        {user.last_login ? formatDate(user.last_login) : 'Nie'}
                      </td>
                      <td>
                        {canManageRole(user.role) ? (
                          <select
                            value={user.role}
                            onChange={(e) => updateUserRole(user.id, e.target.value)}
                            className="role-select"
                          >
                            <option value="user">User</option>
                            <option value="moderator">Moderator</option>
                            {currentUser?.role === 'superadmin' && (
                              <>
                                <option value="admin">Admin</option>
                                <option value="superadmin">Superadmin</option>
                              </>
                            )}
                          </select>
                        ) : (
                          <span className="no-permission">Keine Berechtigung</span>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {activeTab === 'system' && currentUser?.role === 'superadmin' && (
        <div className="admin-section">
          <h3>System-Verwaltung</h3>
          <div className="system-stats">
            <div className="stat-card">
              <h4>Datenbank-Statistiken</h4>
              <p>Benutzer: {users.length}</p>
              <p>Invite-Codes: {inviteCodes.length}</p>
              <p>Verwendete Codes: {inviteCodes.filter(c => c.is_used).length}</p>
            </div>
            <div className="stat-card">
              <h4>Rollen-Verteilung</h4>
              <p>Superadmin: {users.filter(u => u.role === 'superadmin').length}</p>
              <p>Admin: {users.filter(u => u.role === 'admin').length}</p>
              <p>Moderator: {users.filter(u => u.role === 'moderator').length}</p>
              <p>User: {users.filter(u => u.role === 'user').length}</p>
            </div>
          </div>
        </div>
      )}

      {activeTab === 'audit' && isAdmin && (
        <div className="admin-section">
          <h3>Audit-Log</h3>
          <div style={{ display: 'flex', gap: 12, flexWrap: 'wrap', marginBottom: 16 }}>
            <input
              type="text"
              placeholder="Suche..."
              value={auditLogSearch}
              onChange={e => setAuditLogSearch(e.target.value)}
              style={{ flex: 2, minWidth: 120, padding: 8, borderRadius: 8, border: '1px solid #ccc' }}
            />
            <select
              value={auditLogAction}
              onChange={e => setAuditLogAction(e.target.value)}
              style={{ flex: 1, minWidth: 120, padding: 8, borderRadius: 8, border: '1px solid #ccc' }}
            >
              <option value="">Alle Aktionen</option>
              {auditActions.map(a => (
                <option key={a} value={a}>
                  {translateAction(a)} ({a})
                </option>
              ))}
            </select>
            <input
              type="text"
              placeholder="Admin-ID..."
              value={auditLogAdmin}
              onChange={e => setAuditLogAdmin(e.target.value)}
              style={{ flex: 1, minWidth: 120, padding: 8, borderRadius: 8, border: '1px solid #ccc' }}
            />
            <input
              type="date"
              value={auditLogDateFrom}
              onChange={e => setAuditLogDateFrom(e.target.value)}
              style={{ flex: 1, minWidth: 120, padding: 8, borderRadius: 8, border: '1px solid #ccc' }}
            />
            <input
              type="date"
              value={auditLogDateTo}
              onChange={e => setAuditLogDateTo(e.target.value)}
              style={{ flex: 1, minWidth: 120, padding: 8, borderRadius: 8, border: '1px solid #ccc' }}
            />
          </div>
          {auditLogLoading ? (
            <div className="loading">Lade Audit-Log...</div>
          ) : (
            <>
              <div className="table-container">
                <table>
                  <thead>
                    <tr>
                      <th>Aktion</th>
                      <th>Administrator</th>
                      <th>Ziel</th>
                      <th>Details</th>
                      <th>Zeit</th>
                    </tr>
                  </thead>
                  <tbody>
                    {auditLog
                      .filter(entry => {
                        const q = auditLogSearch.toLowerCase();
                        return (
                          !q ||
                          entry.action.toLowerCase().includes(q) ||
                          (entry.admin_id && entry.admin_id.toLowerCase().includes(q)) ||
                          (entry.target_type && entry.target_type.toLowerCase().includes(q)) ||
                          (entry.target_id && entry.target_id.toLowerCase().includes(q)) ||
                          (entry.details && JSON.stringify(entry.details).toLowerCase().includes(q))
                        );
                      })
                      .map(entry => (
                        <tr 
                          key={entry.id} 
                          style={{ cursor: 'pointer' }} 
                          onClick={() => {
                            setAuditLogDetail(entry);
                            updateUrlWithAuditId(entry.id.toString());
                          }}
                        >
                          <td>{translateAction(entry.action)}</td>
                          <td>
                            <div title={`${getAdminName(entry.admin_id)} (ID: ${entry.admin_id})`}>
                              {getAdminName(entry.admin_id)}
                              <br />
                              <code style={{ fontSize: '11px', color: '#666' }}>
                                ({entry.admin_id})
                              </code>
                            </div>
                          </td>
                          <td>
                            {entry.target_type} <br /> 
                            <code>{entry.target_id}</code>
                          </td>
                          <td style={{ maxWidth: 200, wordBreak: 'break-all' }}>
                            {entry.details ? JSON.stringify(entry.details) : '-'}
                          </td>
                          <td>
                            {entry.created_at ? 
                              new Date(entry.created_at).toLocaleString('de-DE', {
                                day: '2-digit',
                                month: '2-digit',
                                year: 'numeric',
                                hour: '2-digit',
                                minute: '2-digit'
                              }) : ''
                            }
                          </td>
                        </tr>
                      ))}
                  </tbody>
                </table>
                {auditLog.length === 0 && <div className="loading">Keine Audit-Log-Einträge gefunden.</div>}
              </div>
              {/* Pagination Controls */}
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 16, marginTop: 16 }}>
                <button onClick={() => setAuditLogPage(p => Math.max(1, p - 1))} disabled={auditLogPage === 1}>←</button>
                <span>Seite {auditLogPage} / {Math.max(1, Math.ceil(auditLogTotal / PAGE_SIZE))} ({auditLogTotal} Einträge)</span>
                <button onClick={() => setAuditLogPage(p => p + 1)} disabled={auditLogPage * PAGE_SIZE >= auditLogTotal}>→</button>
              </div>
            </>
          )}
          {/* Details-Modal */}
          {auditLogDetail && (
            <div className="modal-overlay" onClick={() => {
              setAuditLogDetail(null);
              updateUrlWithAuditId(null);
            }}>
              <div className="modal" onClick={e => e.stopPropagation()} style={{ maxWidth: 700, margin: '10vh auto', background: '#222', color: '#fff', borderRadius: 12, padding: 24, boxShadow: '0 8px 32px rgba(0,0,0,0.4)' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
                  <h4>Audit-Log-Details</h4>
                  <button 
                    onClick={() => {
                      setAuditLogDetail(null);
                      updateUrlWithAuditId(null);
                    }}
                    style={{ background: 'none', border: 'none', color: '#fff', fontSize: '20px', cursor: 'pointer' }}
                  >
                    ✕
                  </button>
                </div>
                <div style={{ maxHeight: '60vh', overflowY: 'auto' }}>
                  {Object.entries(auditLogDetail).map(([key, value]) => (
                    <div key={key} style={{ marginBottom: 12 }}>
                      <div style={{ fontWeight: 'bold', marginBottom: 4 }}>
                        {translateField(key)}:
                      </div>
                      <div style={{ 
                        background: '#111', 
                        padding: 12, 
                        borderRadius: 8, 
                        fontFamily: 'monospace',
                        fontSize: '14px',
                        wordBreak: 'break-all'
                      }}>
                        {key === 'admin_id' ? (
                          <div title={`${getAdminName(value)} (ID: ${value})`}>
                            {getAdminName(value)}
                            <br />
                            <span style={{ fontSize: '11px', color: '#666' }}>
                              (ID: {value})
                            </span>
                          </div>
                        ) : (
                          typeof value === 'object' ? 
                            JSON.stringify(value, null, 2) : 
                            String(value || '')
                        )}
                      </div>
                    </div>
                  ))}
                </div>
                <button 
                  onClick={() => {
                    setAuditLogDetail(null);
                    updateUrlWithAuditId(null);
                  }} 
                  style={{ 
                    marginTop: 16, 
                    padding: '8px 24px', 
                    borderRadius: 8, 
                    border: 'none', 
                    background: '#00bcd4', 
                    color: '#fff', 
                    fontWeight: 600, 
                    cursor: 'pointer' 
                  }}
                >
                  Schließen
                </button>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

export default AdminPanel; 