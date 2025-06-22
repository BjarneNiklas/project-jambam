import React from 'react';
import { useAuth } from '../auth/AuthContext';
import './ProfilePage.css';

const ProfilePage: React.FC = () => {
  const { user, profile } = useAuth();

  if (!user || !profile) {
    return (
      <div className="profile-page">
        <div className="profile-container">
          <h1>Profil</h1>
          <p>Lade Profil...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="profile-page">
      <div className="profile-container">
        <h1>Profil</h1>
        
        <div className="profile-section">
          <h2>Benutzerinformationen</h2>
          <div className="profile-info">
            <div className="info-item">
              <label>Benutzername:</label>
              <span>{profile.username}</span>
            </div>
            <div className="info-item">
              <label>E-Mail:</label>
              <span>{profile.email}</span>
            </div>
            <div className="info-item">
              <label>Rolle:</label>
              <span className={`role-badge role-${profile.role}`}>
                {profile.role}
              </span>
            </div>
            <div className="info-item">
              <label>Verifiziert:</label>
              <span>{profile.is_verified ? 'Ja' : 'Nein'}</span>
            </div>
          </div>
        </div>

        <div className="profile-section">
          <h2>Account-Details</h2>
          <div className="profile-info">
            <div className="info-item">
              <label>Erstellt am:</label>
              <span>{new Date(profile.created_at).toLocaleDateString('de-DE')}</span>
            </div>
            <div className="info-item">
              <label>Letzte Aktualisierung:</label>
              <span>{new Date(profile.updated_at).toLocaleDateString('de-DE')}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProfilePage; 