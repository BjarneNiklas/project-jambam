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

const AdminPanel: React.FC = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [inviteCodes, setInviteCodes] = useState<InviteCode[]>([]);
  const [newInviteCode, setNewInviteCode] = useState('');
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<'invites' | 'users' | 'system'>('invites');
  const [currentUser, setCurrentUser] = useState<User | null>(null);

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

  useEffect(() => {
    fetchData();
    fetchCurrentUser();
  }, [fetchData, fetchCurrentUser]);

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
  };

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
          <div className="current-user-info">
            <span>Angemeldet als: </span>
            <span 
              className="role-badge"
              style={{ backgroundColor: getRoleColor(currentUser.role) }}
            >
              {currentUser.role.toUpperCase()}
            </span>
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
    </div>
  );
};

export default AdminPanel; 