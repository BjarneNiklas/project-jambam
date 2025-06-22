import React, { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../auth/AuthContext';
import { supabase } from '../lib/supabase';
import './LoginPage.css';

interface PasswordStrength {
  score: number; // 0-4
  label: string;
  color: string;
  feedback: string[];
}

const RegisterPage: React.FC = () => {
  const { t } = useTranslation();
  const { register } = useAuth();
  const navigate = useNavigate();
  
  // Form state
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [inviteCode, setInviteCode] = useState('');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [showInviteSection, setShowInviteSection] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [passwordStrength, setPasswordStrength] = useState<PasswordStrength>({
    score: 0,
    label: '',
    color: '#e74c3c',
    feedback: []
  });

  // Password strength checker
  const checkPasswordStrength = (password: string): PasswordStrength => {
    const feedback: string[] = [];
    let score = 0;

    // Length check
    if (password.length >= 8) {
      score += 1;
    } else {
      feedback.push('Mindestens 8 Zeichen');
    }

    // Lowercase check
    if (/[a-z]/.test(password)) {
      score += 1;
    } else {
      feedback.push('Kleinbuchstaben hinzufügen');
    }

    // Uppercase check
    if (/[A-Z]/.test(password)) {
      score += 1;
    } else {
      feedback.push('Großbuchstaben hinzufügen');
    }

    // Numbers check
    if (/\d/.test(password)) {
      score += 1;
    } else {
      feedback.push('Zahlen hinzufügen');
    }

    // Special characters check
    if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) {
      score += 1;
    } else {
      feedback.push('Sonderzeichen hinzufügen');
    }

    // Determine strength level
    let label = '';
    let color = '#e74c3c'; // Red

    if (score === 0) {
      label = 'Sehr schwach';
      color = '#e74c3c';
    } else if (score === 1) {
      label = 'Schwach';
      color = '#e67e22';
    } else if (score === 2) {
      label = 'Mittel';
      color = '#f39c12';
    } else if (score === 3) {
      label = 'Gut';
      color = '#f1c40f';
    } else if (score === 4) {
      label = 'Stark';
      color = '#27ae60';
    } else if (score >= 5) {
      label = 'Sehr stark';
      color = '#2ecc71';
    }

    return { score, label, color, feedback };
  };

  // Update password strength when password changes
  useEffect(() => {
    if (password) {
      setPasswordStrength(checkPasswordStrength(password));
    } else {
      setPasswordStrength({
        score: 0,
        label: '',
        color: '#e74c3c',
        feedback: []
      });
    }
  }, [password]);

  // Handle password visibility toggle
  const handlePasswordVisibilityToggle = () => {
    setShowPassword(!showPassword);
    // Clear confirmation when showing password
    if (!showPassword) {
      setConfirmPassword('');
    }
  };

  const markInviteCodeAsUsed = async (inviteCode: string, userId: string) => {
    try {
      const { error } = await supabase
        .from('invite_codes')
        .update({
          is_used: true,
          used_by: userId,
          used_at: new Date().toISOString(),
        })
        .eq('code', inviteCode);

      if (error) {
        console.error('Error marking invite code as used:', error);
      }
    } catch (error) {
      console.error('Error marking invite code as used:', error);
    }
  };

  // Test connection function
  const testConnection = async () => {
    setError('');
    setSuccess('');
    try {
      const { data, error } = await supabase.auth.getSession();
      if (error) {
        setError('Verbindungstest fehlgeschlagen: ' + error.message);
      } else {
        setSuccess('Verbindungstest erfolgreich! Supabase ist erreichbar.');
      }
    } catch (err) {
      setError('Verbindungstest fehlgeschlagen: ' + (err instanceof Error ? err.message : 'Unbekannter Fehler'));
    }
  };

  // Test registration function
  const testRegistration = async () => {
    setError('');
    setSuccess('');
    setIsLoading(true);
    
    try {
      const testEmail = `test${Date.now()}@example.com`;
      const testPassword = 'TestPassword123!';
      
      console.log('Testing registration with:', { testEmail });
      
      const result = await register(testEmail, testPassword);
      if (result.success) {
        setSuccess('Test-Registrierung erfolgreich! Das System funktioniert.');
      } else {
        setError('Test-Registrierung fehlgeschlagen: ' + result.error);
      }
    } catch (err) {
      setError('Test-Registrierung Exception: ' + (err instanceof Error ? err.message : 'Unbekannter Fehler'));
    } finally {
      setIsLoading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    // Check password confirmation only if password is hidden
    if (!showPassword && password !== confirmPassword) {
      setError(t('register.passwordMismatch') || 'Passwörter stimmen nicht überein');
      return;
    }

    if (password.length < 8) {
      setError(t('register.passwordTooShort') || 'Passwort muss mindestens 8 Zeichen lang sein');
      return;
    }

    setIsLoading(true);
    
    try {
      const result = await register(email, password);
      if (result.success) {
        if (result.error) {
            // This is for cases like email confirmation required
            setSuccess(result.error);
        } else {
            // If invite code was provided, mark it as used
            if (inviteCode.trim()) {
              const { data: { user } } = await supabase.auth.getUser();
              if (user) {
                await markInviteCodeAsUsed(inviteCode, user.id);
              }
            }
            navigate('/tech-radar');
        }
      } else {
        // Display the specific error message from Supabase
        setError(result.error || t('register.registrationFailed') || 'Registrierung fehlgeschlagen');
      }
    } catch (error) {
      setError(t('register.networkError') || 'Netzwerkfehler');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="register-page">
      <div className="register-modal">
        <h1>{t('register.title') || 'Erstelle dein Konto'}</h1>
        <p className="subtitle">Willkommen! Erstelle dein Konto, um loszulegen.</p>
        
        {/* Optional Invitation Code Section */}
        <div className="invite-section">
          <button
            type="button"
            onClick={() => setShowInviteSection(!showInviteSection)}
            className="invite-toggle-btn"
          >
            {showInviteSection ? '🔽' : '🔼'} Einladungscode (optional)
          </button>
          
          {showInviteSection && (
            <div className="invite-input-section">
              <p className="invite-hint">
                Falls du einen Einladungscode hast, kannst du ihn hier eingeben. 
                Du kannst ihn auch später in den Einstellungen hinzufügen.
              </p>
              <div className="input-group">
                <label htmlFor="inviteCode">Einladungscode</label>
                <input
                  type="text"
                  id="inviteCode"
                  value={inviteCode}
                  onChange={(e) => setInviteCode(e.target.value)}
                  placeholder="Gib deinen Einladungscode ein (optional)"
                  disabled={isLoading}
                />
              </div>
            </div>
          )}
        </div>

        <form onSubmit={handleSubmit} className="register-form">
          {/* Connection Test Buttons */}
          <div className="connection-test">
            <button
              type="button"
              onClick={testConnection}
              className="test-connection-btn"
              disabled={isLoading}
            >
              🔗 Verbindung testen
            </button>
            <button
              type="button"
              onClick={testRegistration}
              className="test-registration-btn"
              disabled={isLoading}
            >
              🧪 Test-Registrierung
            </button>
          </div>

          <div className="input-group">
            <label htmlFor="email">{t('register.emailLabel') || 'E-Mail'}</label>
            <input
              type="email"
              id="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder={t('register.emailPlaceholder') || 'deine@email.com'}
              disabled={isLoading}
              required
            />
          </div>
          <div className="input-group">
            <label htmlFor="password">{t('register.passwordLabel') || 'Passwort'}</label>
            <div className="password-input-container">
              <input
                type={showPassword ? 'text' : 'password'}
                id="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder={t('register.passwordPlaceholder') || 'Mindestens 8 Zeichen'}
                disabled={isLoading}
                required
                minLength={8}
              />
              <button
                type="button"
                onClick={handlePasswordVisibilityToggle}
                className="password-toggle-btn"
                disabled={isLoading}
                title={showPassword ? 'Passwort verstecken' : 'Passwort anzeigen'}
              >
                {showPassword ? (
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/>
                    <line x1="1" y1="1" x2="23" y2="23"/>
                  </svg>
                ) : (
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                    <circle cx="12" cy="12" r="3"/>
                  </svg>
                )}
              </button>
            </div>
            
            {/* Password Strength Indicator */}
            {password && (
              <div className="password-strength">
                <div className="strength-bar">
                  <div 
                    className="strength-fill"
                    style={{ 
                      width: `${(passwordStrength.score / 5) * 100}%`,
                      backgroundColor: passwordStrength.color
                    }}
                  ></div>
                </div>
                <div className="strength-info">
                  <span className="strength-label" style={{ color: passwordStrength.color }}>
                    {passwordStrength.label}
                  </span>
                  {passwordStrength.feedback.length > 0 && (
                    <div className="strength-feedback">
                      {passwordStrength.feedback.map((item, index) => (
                        <div key={index} className="feedback-item">
                          <span className="feedback-icon">⚠️</span>
                          {item}
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              </div>
            )}
          </div>

          {/* Password Confirmation - only show when password is hidden */}
          {!showPassword && (
            <div className="input-group">
              <label htmlFor="confirmPassword">{t('register.confirmPasswordLabel') || 'Passwort bestätigen'}</label>
              <input
                type="password"
                id="confirmPassword"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                placeholder={t('register.confirmPasswordPlaceholder') || 'Passwort wiederholen'}
                disabled={isLoading}
                required
              />
            </div>
          )}

          {error && (
            <div className="error-message">
              <span className="error-icon">⚠️</span>
              {error}
            </div>
          )}

          {success && (
            <div className="success-message">
              <span className="success-icon">✅</span>
              {success}
            </div>
          )}

          <button
            type="submit"
            disabled={!email || !password || (!showPassword && !confirmPassword) || isLoading}
            className={`submit-btn ${isLoading ? 'loading' : ''}`}
          >
            {isLoading ? <span className="loading-spinner"></span> : t('register.submit') || 'Konto erstellen'}
          </button>
        </form>
        <div className="extra-links">
          <Link to="/login">{t('register.alreadyHaveAccount') || 'Bereits ein Konto? Anmelden'}</Link>
        </div>
      </div>
    </div>
  );
};

export default RegisterPage; 