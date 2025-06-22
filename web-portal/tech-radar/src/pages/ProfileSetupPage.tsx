import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useAuth } from '../auth/AuthContext';
import { useNavigate } from 'react-router-dom';
import { supabase } from '../lib/supabase';
import './ProfileSetupPage.css';

const ProfileSetupPage: React.FC = () => {
  const { t } = useTranslation();
  const { user, profile, refreshProfile } = useAuth();
  const navigate = useNavigate();
  
  const [username, setUsername] = useState(profile?.username || '');
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    if (!username || username.length < 3) {
      setError('Benutzername muss mindestens 3 Zeichen lang sein.');
      return;
    }

    if (!/^[a-zA-Z0-9_]+$/.test(username)) {
      setError('Benutzername darf nur Buchstaben, Zahlen und Unterstriche enthalten.');
      return;
    }

    if (!user) {
        setError('Nicht angemeldet. Bitte melde dich erneut an.');
        return;
    }

    setIsLoading(true);

    try {
        // Check if username is already taken
        const { data: existingUser, error: fetchError } = await supabase
            .from('profiles')
            .select('username')
            .eq('username', username)
            .single();

        if (fetchError && fetchError.code !== 'PGRST116') { // Ignore 'PGRST116' which is "Not Found"
            setError(`Fehler bei der Überprüfung des Benutzernamens: ${fetchError.message}`);
            setIsLoading(false);
            return;
        }

        if (existingUser) {
            setError('Dieser Benutzername ist bereits vergeben. Bitte wähle einen anderen.');
            setIsLoading(false);
            return;
        }
        
        // Update profile
      const { error: updateError } = await supabase
        .from('profiles')
        .update({ username: username, updated_at: new Date().toISOString() })
        .eq('id', user.id);

      if (updateError) {
        setError(`Fehler beim Aktualisieren des Profils: ${updateError.message}`);
      } else {
        await refreshProfile(); // Refresh the profile in AuthContext
        navigate('/tech-radar'); // Redirect to the main page
      }
    } catch (err) {
      setError('Ein unerwarteter Fehler ist aufgetreten.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="profile-setup-page">
      <div className="profile-setup-modal">
        <h1>Profil einrichten</h1>
        <p>Willkommen bei JamBam! Wähle deinen öffentlichen Benutzernamen.</p>
        
        <form onSubmit={handleSubmit} className="profile-setup-form">
          <div className="input-group">
            <label htmlFor="username">Benutzername</label>
            <input
              type="text"
              id="username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder="Dein einzigartiger Benutzername"
              disabled={isLoading}
              required
              minLength={3}
              pattern="^[a-zA-Z0-9_]+$"
              title="Nur Buchstaben, Zahlen und Unterstriche."
            />
            <p className="input-hint">Dies ist dein öffentlicher Name, der für andere sichtbar ist.</p>
          </div>

          {error && (
            <div className="error-message">
              <span className="error-icon">⚠️</span>
              {error}
            </div>
          )}

          <button
            type="submit"
            disabled={!username || isLoading}
            className={`submit-btn ${isLoading ? 'loading' : ''}`}
          >
            {isLoading ? <span className="loading-spinner"></span> : 'Profil speichern & loslegen'}
          </button>
        </form>
      </div>
    </div>
  );
};

export default ProfileSetupPage; 