import React from 'react';
import { useTranslation } from 'react-i18next';
import './HomePage.css';

const HomePage: React.FC = () => {
  const { t } = useTranslation();

  return (
    <div className="home-page">
      <section className="hero-section">
        <div className="hero-content">
          <h1 className="hero-title">{t('home.hero.title')}</h1>
          <p className="hero-subtitle">{t('home.hero.subtitle')}</p>
          <div className="hero-actions">
            <a 
              href="https://www.auravention.com" 
              target="_blank" 
              rel="noopener noreferrer"
              className="hero-app-button"
            >
              📱 {t('home.hero.appButton')}
            </a>
            <a href="/about" className="hero-secondary-button">
              {t('home.hero.learnMore')}
            </a>
          </div>
        </div>
      </section>
      
      <section className="features-section">
        <h2>{t('home.features.title')}</h2>
        <div className="features-grid">
          <div className="feature-card">
            <h3>{t('home.features.creativity.title')}</h3>
            <p>{t('home.features.creativity.description')}</p>
          </div>
          <div className="feature-card">
            <h3>{t('home.features.community.title')}</h3>
            <p>{t('home.features.community.description')}</p>
          </div>
          <div className="feature-card">
            <h3>{t('home.features.innovation.title')}</h3>
            <p>{t('home.features.innovation.description')}</p>
          </div>
        </div>
      </section>
    </div>
  );
};

export default HomePage; 