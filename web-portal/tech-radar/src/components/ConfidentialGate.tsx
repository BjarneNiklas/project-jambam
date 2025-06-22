import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useAuth } from '../auth/AuthContext'; // Import useAuth
import './ConfidentialGate.css'; // Updated CSS import

interface ConfidentialGateProps {
  onSuccess: () => void;
}

type GateMode = 'sharedPassword' | 'inviteCode';

const ConfidentialGate: React.FC<ConfidentialGateProps> = ({ onSuccess }) => {
  const { t } = useTranslation();
  const { validateSharedPassword, validateInviteCodeForGate } = useAuth(); // Get functions from context

  const [mode, setMode] = useState<GateMode>('sharedPassword'); // Default to shared password
  const [sharedPassword, setSharedPassword] = useState('');
  const [inviteCode, setInviteCode] = useState('');
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError('');

    let success = false;
    if (mode === 'sharedPassword') {
      if (!sharedPassword) {
        setError(t('confidentialGate.sharedPasswordRequired') || 'Geheimes Passwort ist erforderlich.');
        setIsLoading(false);
        return;
      }
      success = await validateSharedPassword(sharedPassword);
      if (!success) {
        setError(t('confidentialGate.incorrectSharedPassword') || 'Falsches geheimes Passwort.');
      }
    } else { // inviteCode mode
      if (!inviteCode) {
        setError(t('confidentialGate.inviteCodeRequired') || 'Einladungscode ist erforderlich.');
        setIsLoading(false);
        return;
      }
      success = await validateInviteCodeForGate(inviteCode);
      if (!success) {
        setError(t('confidentialGate.incorrectInviteCode') || 'Ungültiger oder bereits benutzter Einladungscode.');
      }
    }

    if (success) {
      onSuccess();
    }
    setIsLoading(false);
  };

  return (
    <div className="password-protection confidential-gate"> {/* Added confidential-gate class */}
      <div className="protection-overlay">
        <div className="protection-modal">
          <div className="logo-section">
            <div className="protected-logo">
              <div className="hexagon">
                <div className="spark"></div>
              </div>
            </div>
            <h1>{t('confidentialGate.title') || 'Zugriffsbeschränkung'}</h1>
          </div>

          <div className="gate-mode-selector">
            <button
              onClick={() => setMode('sharedPassword')}
              className={mode === 'sharedPassword' ? 'active' : ''}
              disabled={isLoading}
              aria-pressed={mode === 'sharedPassword'}
            >
              {t('confidentialGate.useSharedPassword') || 'Geheimes Passwort'}
            </button>
            <button
              onClick={() => setMode('inviteCode')}
              className={mode === 'inviteCode' ? 'active' : ''}
              disabled={isLoading}
              aria-pressed={mode === 'inviteCode'}
            >
              {t('confidentialGate.useInviteCode') || 'Einladungscode'}
            </button>
          </div>

          <form onSubmit={handleSubmit} className="password-form">
            {mode === 'sharedPassword' && (
              <div className="input-group">
                <label htmlFor="sharedPassword">{t('confidentialGate.sharedPasswordLabel') || 'Geheimes Passwort'}</label>
                <input
                  type="password"
                  id="sharedPassword"
                  value={sharedPassword}
                  onChange={(e) => setSharedPassword(e.target.value)}
                  placeholder={t('confidentialGate.sharedPasswordPlaceholder') || 'Geheimes Passwort eingeben'}
                  disabled={isLoading}
                  className={error && mode === 'sharedPassword' ? 'error' : ''}
                  autoComplete="current-password" // Or "new-password" to avoid autofill issues
                />
              </div>
            )}

            {mode === 'inviteCode' && (
              <div className="input-group">
                <label htmlFor="inviteCode">{t('confidentialGate.inviteCodeLabel') || 'Einladungscode'}</label>
                <input
                  type="text" // Invite codes are often not treated as passwords
                  id="inviteCode"
                  value={inviteCode}
                  onChange={(e) => setInviteCode(e.target.value)}
                  placeholder={t('confidentialGate.inviteCodePlaceholder') || 'Einladungscode eingeben'}
                  disabled={isLoading}
                  className={error && mode === 'inviteCode' ? 'error' : ''}
                  autoComplete="off"
                />
              </div>
            )}

            {error && (
              <div className="error-message">
                <span className="error-icon">⚠️</span>
                {error}
              </div>
            )}

            <button
              type="submit"
              disabled={isLoading || (mode === 'sharedPassword' && !sharedPassword) || (mode === 'inviteCode' && !inviteCode)}
              className={`submit-btn ${isLoading ? 'loading' : ''}`}
            >
              {isLoading ? (
                <span className="loading-spinner"></span>
              ) : (
                t('confidentialGate.submit') || 'Zugriff gewähren'
              )}
            </button>
          </form>

          <div className="security-info">
             {/* Security info can be kept or adapted if relevant */}
            <div className="security-item">
              <span className="security-icon">🔒</span>
              {t('confidentialGate.security.info') || 'Gesicherter Zugriff'}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ConfidentialGate;