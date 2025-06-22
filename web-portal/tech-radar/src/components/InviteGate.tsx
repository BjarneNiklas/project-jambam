import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { supabase } from '../lib/supabase';
import './InviteGate.css';

interface InviteGateProps {
  onSuccess: () => void;
}

const InviteGate: React.FC<InviteGateProps> = ({ onSuccess }) => {
  const { t } = useTranslation();
  const [inviteCode, setInviteCode] = useState('');
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');

    try {
      // Prüfe Invite-Code in Supabase
      const { data, error: supaError } = await supabase
        .from('invite_codes')
        .select('*')
        .eq('code', inviteCode)
        .eq('is_used', false)
        .single();

      if (supaError || !data) {
        setError(t('inviteGate.incorrectCode') || 'Ungültiger Einladungscode');
        setIsLoading(false);
        return;
      }

      // Code ist gültig - speichere für spätere Verwendung
      sessionStorage.setItem('valid_invite_code', inviteCode);
      onSuccess();
    } catch (error) {
      console.error('Error validating invite code:', error);
      setError(t('inviteGate.networkError') || 'Netzwerkfehler');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="password-protection">
      <div className="protection-overlay">
        <div className="protection-modal">
          <div className="logo-section">
            <div className="protected-logo">
              <div className="hexagon">
                <div className="spark"></div>
              </div>
            </div>
            <h1>{t('inviteGate.title') || 'Einladung erforderlich'}</h1>
          </div>

          <form onSubmit={handleSubmit} className="password-form">
            <div className="input-group">
              <label htmlFor="inviteCode">{t('inviteGate.label') || 'Einladungscode'}</label>
              <input
                type="password"
                id="inviteCode"
                value={inviteCode}
                onChange={(e) => setInviteCode(e.target.value)}
                placeholder={t('inviteGate.placeholder') || 'Gib deinen Einladungscode ein'}
                disabled={isLoading}
                className={error ? 'error' : ''}
                autoComplete="off"
              />
            </div>

            {error && (
              <div className="error-message">
                <span className="error-icon">⚠️</span>
                {error}
              </div>
            )}

            <button
              type="submit"
              disabled={!inviteCode || isLoading}
              className={`submit-btn ${isLoading ? 'loading' : ''}`}
            >
              {isLoading ? (
                <span className="loading-spinner"></span>
              ) : (
                t('inviteGate.submit') || 'Zugriff gewähren'
              )}
            </button>
          </form>

          <div className="security-info">
            <div className="security-item">
              <span className="security-icon">🔒</span>
              {t('password.security.encrypted') || 'Ende-zu-Ende verschlüsselt'}
            </div>
            <div className="security-item">
              <span className="security-icon">🛡️</span>
              {t('password.security.protected') || 'Vor Suchmaschinen geschützt'}
            </div>
            <div className="security-item">
              <span className="security-icon">🤖</span>
              {t('password.security.noIndex') || 'Nicht von Bots indexiert'}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default InviteGate; 