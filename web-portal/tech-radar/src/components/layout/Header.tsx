import React, { useState } from 'react';
import { Link, NavLink } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { useAuth } from '../../auth/AuthContext';
import LogoHexSpark from '../LogoHexSpark'; // Assuming LogoHexSpark is your logo component
import './Header.css';
import { FaBars, FaTimes } from 'react-icons/fa'; // Icons for mobile menu

const Header: React.FC = () => {
  const { t } = useTranslation();
  const { isAuthenticated, profile, logout } = useAuth();
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  const isAdmin = profile && ['admin', 'moderator', 'superadmin'].includes(profile.role);

  const toggleMobileMenu = () => {
    setIsMobileMenuOpen(!isMobileMenuOpen);
  };

  const adminRoleDisplay = () => {
    if (!profile) return null;
    switch (profile.role) {
      case 'superadmin':
        return '👑 Superadmin';
      case 'admin':
        return '🔧 Admin';
      case 'moderator':
        return '🛡️ Moderator';
      default:
        return null;
    }
  };

  return (
    <header className="site-header">
      <div className="header-container">
        <div className="header-content">
          <Link to="/" className="logo-link">
            <LogoHexSpark />
            <span className="site-title">JamBam</span>
          </Link>

          <nav className={`main-nav ${isMobileMenuOpen ? 'open' : ''}`}>
            <ul>
              <li><NavLink to="/" end className={({ isActive }) => isActive ? "active-link" : ""} onClick={() => setIsMobileMenuOpen(false)}>{t('nav.home', 'Home')}</NavLink></li>
              <li><NavLink to="/feed" className={({ isActive }) => isActive ? "active-link" : ""} onClick={() => setIsMobileMenuOpen(false)}>{t('nav.feed', 'Feed')}</NavLink></li>
              <li><NavLink to="/tech-radar" className={({ isActive }) => isActive ? "active-link" : ""} onClick={() => setIsMobileMenuOpen(false)}>{t('nav.techRadar', 'Technologie-Radar')}</NavLink></li>
              <li><NavLink to="/about" className={({ isActive }) => isActive ? "active-link" : ""} onClick={() => setIsMobileMenuOpen(false)}>{t('nav.about', 'Über Uns')}</NavLink></li>
              <li><NavLink to="/roadmap" className={({ isActive }) => isActive ? "active-link" : ""} onClick={() => setIsMobileMenuOpen(false)}>{t('nav.roadmap', 'Roadmap')}</NavLink></li>
              {/* Links for new pages, can be conditionally shown or grouped */}
              <li><NavLink to="/team" className={({ isActive }) => isActive ? "active-link" : ""} onClick={() => setIsMobileMenuOpen(false)}>{t('nav.team', 'Team')}</NavLink></li>
              <li><NavLink to="/vision-mission" className={({ isActive }) => isActive ? "active-link" : ""} onClick={() => setIsMobileMenuOpen(false)}>{t('nav.visionMission', 'Vision & Mission')}</NavLink></li>
              <li><NavLink to="/funding-worthiness" className={({ isActive }) => isActive ? "active-link" : ""} onClick={() => setIsMobileMenuOpen(false)}>{t('nav.funding', 'Funding')}</NavLink></li>
              {isAuthenticated && isAdmin && (
                <li className="admin-menu-item">
                  <NavLink
                    to="/admin"
                    className={({ isActive }) => `admin-link ${profile?.role} ${isActive ? "active-link" : ""}`}
                    onClick={() => setIsMobileMenuOpen(false)}
                  >
                    {adminRoleDisplay()}
                  </NavLink>
                </li>
              )}
            </ul>
          </nav>

          <div className="header-actions">
            <a
              href="https://www.auravention.com" // Replace with actual app link
              target="_blank"
              rel="noopener noreferrer"
              className="header-app-button cta-button"
              title={t('header.downloadApp') || ''}
            >
              📱 {t('header.getApp', 'Get App')}
            </a>
            {/* Login, Profile, and Logout buttons removed as per request */}
            <Link to="/settings" className="settings-button" title={t('nav.settings') || ''} onClick={() => setIsMobileMenuOpen(false)}>
              ⚙️
            </Link>
            <button className="mobile-menu-toggle" onClick={toggleMobileMenu} aria-label="Toggle menu">
              {isMobileMenuOpen ? <FaTimes /> : <FaBars />}
            </button>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;