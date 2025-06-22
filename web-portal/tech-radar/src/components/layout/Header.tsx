import React from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { useAuth } from '../../auth/AuthContext';
import LogoHexSpark from '../LogoHexSpark';
import './Header.css';

const Header: React.FC = () => {
  const { t } = useTranslation();
  const { isAuthenticated, profile } = useAuth();

  const isAdmin = profile && ['admin', 'moderator', 'superadmin'].includes(profile.role);

  return (
    <header className="site-header">
      <div className="header-container">
        <div className="header-content">
          <div className="logo-link">
            <LogoHexSpark />
            <span className="site-title">JamBam</span>
          </div>
          <nav className="main-nav">
            <ul>
              <li><Link to="/">{t('nav.home') || 'Home'}</Link></li>
              <li><Link to="/feed">{t('nav.feed') || 'Feed'}</Link></li>
              <li><Link to="/tech-radar">{t('nav.techRadar') || 'Tech Radar'}</Link></li>
              <li><Link to="/about">{t('nav.about') || 'About'}</Link></li>
              <li><Link to="/contact">{t('nav.contact') || 'Kontakt'}</Link></li>
              {isAuthenticated && isAdmin && (
                <li>
                  <Link to="/admin" className={`admin-link ${profile?.role === 'superadmin' ? 'superadmin' : ''}`}>
                    {profile?.role === 'superadmin' ? '👑 Superadmin' : 
                     profile?.role === 'admin' ? '🔧 Admin' : '🛡️ Moderator'}
                  </Link>
                </li>
              )}
            </ul>
          </nav>
          <div className="header-actions">
            <a 
              href="https://www.auravention.com" 
              target="_blank" 
              rel="noopener noreferrer"
              className="header-app-button"
              title="App herunterladen"
            >
              📱 App
            </a>
            <Link to="/settings" className="settings-button" title={t('nav.settings') || 'Settings'}>
              ⚙️
            </Link>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header; 