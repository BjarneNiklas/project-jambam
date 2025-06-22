import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useTheme } from '../contexts/ThemeContext';
import { useDarkMode } from '../contexts/DarkModeContext';
import { useAuth } from '../auth/AuthContext';
import { supabase } from '../lib/supabase';
import ThemeSelector from '../components/ThemeSelector';
import LanguageSwitcher from '../components/LanguageSwitcher';
import './SettingsPage.css';

type Theme = 'bubbles' | 'balloons' | 'butterflies' | 'stars' | 'fireflies';

const SettingsPage: React.FC = () => {
  const { t } = useTranslation();
  const { currentTheme, changeTheme, animationsEnabled, toggleAnimations } = useTheme();
  const { isDarkMode, toggleDarkMode } = useDarkMode();
  const { isAuthenticated, user } = useAuth();
  
  // Invitation code state
  const [inviteCode, setInviteCode] = useState('');
  const [inviteError, setInviteError] = useState('');
  const [inviteSuccess, setInviteSuccess] = useState('');
  const [isInviteLoading, setIsInviteLoading] = useState(false);
  const [hasValidInvite, setHasValidInvite] = useState(false);

  // Check if user already has a valid invitation
  React.useEffect(() => {
    const checkInvitationStatus = async () => {
      if (isAuthenticated && user) {
        try {
          const { data, error } = await supabase
            .from('invite_codes')
            .select('*')
            .eq('used_by', user.id)
            .eq('is_used', true)
            .single();
          
          if (data && !error) {
            setHasValidInvite(true);
          }
        } catch (error) {
          console.log('No invitation found for user');
        }
      }
    };

    checkInvitationStatus();
  }, [isAuthenticated, user]);

  const handleInviteSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsInviteLoading(true);
    setInviteError('');
    setInviteSuccess('');

    try {
      // Check if invite code is valid and unused
      const { data, error } = await supabase
        .from('invite_codes')
        .select('*')
        .eq('code', inviteCode)
        .eq('is_used', false)
        .single();

      if (error || !data) {
        setInviteError('Ungültiger oder bereits verwendeter Einladungscode');
        return;
      }

      // Mark invite code as used by current user
      const { error: updateError } = await supabase
        .from('invite_codes')
        .update({
          is_used: true,
          used_by: user?.id,
          used_at: new Date().toISOString(),
        })
        .eq('code', inviteCode);

      if (updateError) {
        setInviteError('Fehler beim Aktivieren des Einladungscodes');
        return;
      }

      setInviteSuccess('Einladungscode erfolgreich aktiviert!');
      setHasValidInvite(true);
      setInviteCode('');
      
    } catch (error) {
      setInviteError('Netzwerkfehler beim Überprüfen des Codes');
    } finally {
      setIsInviteLoading(false);
    }
  };

  return (
    <div className="settings-page">
      <div className="settings-container">
        <div className="settings-header">
          <h1>{t('settings.title')}</h1>
          <p>{t('settings.subtitle')}</p>
        </div>

        {/* Public Settings - Available for everyone */}
        <div className="settings-section">
          <div className="settings-card public-settings">
            <h3>{t('settings.appearance.title', 'Darstellung')}</h3>
            <p>{t('settings.appearance.description', 'Passe das Aussehen der Webseite an.')}</p>
            
            <div className="setting-item">
              <label>{t('settings.language', 'Sprache')}</label>
              <LanguageSwitcher />
            </div>

            <div className="setting-item">
              <label htmlFor="dark-mode">{t('settings.darkMode', 'Dunkelmodus')}</label>
              <input 
                type="checkbox" 
                id="dark-mode" 
                className="setting-checkbox"
                checked={isDarkMode}
                onChange={toggleDarkMode}
              />
            </div>
            
            <div className="setting-item">
              <label htmlFor="animations-enabled">{t('settings.enableAnimations', 'Animationen aktivieren')}</label>
              <input
                type="checkbox"
                id="animations-enabled"
                className="setting-checkbox"
                checked={animationsEnabled}
                onChange={toggleAnimations}
              />
            </div>

            <div className="setting-item">
              <label>{t('settings.appDownload')}</label>
              <a 
                href="https://www.auravention.com" 
                target="_blank" 
                rel="noopener noreferrer"
                className="app-download-button"
              >
                📱 {t('settings.downloadApp')}
              </a>
            </div>
          </div>
        </div>

        <div className="settings-section">
          <ThemeSelector />
        </div>

        {/* Private Settings - Only for logged-in users */}
        {isAuthenticated ? (
          <>
            {/* Invitation Code Section */}
            <div className="settings-section">
              <div className="settings-card private-settings">
                <h3>Einladungscode</h3>
                <p>Falls du deinen Einladungscode bei der Registrierung übersprungen hast, kannst du ihn hier nachträglich eingeben.</p>
                
                {hasValidInvite ? (
                  <div className="invite-status valid">
                    <span className="status-icon">✅</span>
                    <span>Du hast bereits einen gültigen Einladungscode aktiviert.</span>
                  </div>
                ) : (
                  <form onSubmit={handleInviteSubmit} className="invite-form">
                    <div className="setting-item">
                      <label htmlFor="invite-code">Einladungscode</label>
                      <input
                        type="text"
                        id="invite-code"
                        value={inviteCode}
                        onChange={(e) => setInviteCode(e.target.value)}
                        placeholder="Gib deinen Einladungscode ein"
                        disabled={isInviteLoading}
                        className={inviteError ? 'error' : ''}
                      />
                    </div>

                    {inviteError && (
                      <div className="error-message">
                        <span className="error-icon">⚠️</span>
                        {inviteError}
                      </div>
                    )}

                    {inviteSuccess && (
                      <div className="success-message">
                        <span className="success-icon">✅</span>
                        {inviteSuccess}
                      </div>
                    )}

                    <button
                      type="submit"
                      disabled={!inviteCode || isInviteLoading}
                      className={`btn btn-primary ${isInviteLoading ? 'loading' : ''}`}
                    >
                      {isInviteLoading ? 'Überprüfe...' : 'Einladungscode aktivieren'}
                    </button>
                  </form>
                )}
              </div>
            </div>

            <div className="settings-section">
              <div className="settings-card private-settings">
                <h3>{t('settings.notifications.title')}</h3>
                <p>{t('settings.notifications.description')}</p>
                
                <div className="setting-item">
                  <label htmlFor="email-notifications">{t('settings.emailNotifications')}</label>
                  <input 
                    type="checkbox" 
                    id="email-notifications" 
                    className="setting-checkbox"
                    defaultChecked
                  />
                </div>

                <div className="setting-item">
                  <label htmlFor="push-notifications">{t('settings.pushNotifications')}</label>
                  <input 
                    type="checkbox" 
                    id="push-notifications" 
                    className="setting-checkbox"
                    defaultChecked
                  />
                </div>
              </div>
            </div>

            <div className="settings-section">
              <div className="settings-card private-settings">
                <h3>{t('settings.privacy.title')}</h3>
                <p>{t('settings.privacy.description')}</p>
                
                <div className="setting-item">
                  <label htmlFor="data-collection">{t('settings.dataCollection')}</label>
                  <input 
                    type="checkbox" 
                    id="data-collection" 
                    className="setting-checkbox"
                    defaultChecked
                  />
                </div>

                <div className="setting-item">
                  <label htmlFor="analytics">{t('settings.analytics')}</label>
                  <input 
                    type="checkbox" 
                    id="analytics" 
                    className="setting-checkbox"
                    defaultChecked
                  />
                </div>
              </div>
            </div>
          </>
        ) : (
          <div className="settings-section">
            <div className="settings-card login-prompt">
              <h3>{t('settings.loginRequired.title')}</h3>
              <p>{t('settings.loginRequired.description')}</p>
              <div className="login-actions">
                <button className="btn btn-primary">{t('auth.login.submit')}</button>
                <button className="btn btn-secondary">{t('auth.register.submit')}</button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default SettingsPage; 