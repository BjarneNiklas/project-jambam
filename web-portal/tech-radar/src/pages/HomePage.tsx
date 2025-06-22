import React from 'react';
import { useTranslation } from 'react-i18next';
import './HomePage.css';

const HomePage: React.FC = () => {
  const { t } = useTranslation();

  return (
    <div className="home-page">
      <section className="hero-section">
        <div className="hero-content">
          <h1 className="hero-title">{t('home.hero.titleNew')}</h1>
          <p className="hero-subtitle">{t('home.hero.subtitleNew')}</p>
          <div className="hero-actions">
            <a 
              href="/tech-radar"
              className="hero-app-button"
            >
              {t('home.hero.primaryCta')}
            </a>
            <a href="/about" className="hero-secondary-button">
              {t('home.hero.learnMore')}
            </a>
          </div>
        </div>
      </section>
      
      <section className="features-section">
        <h2>{t('home.features.titleNew')}</h2>
        <div className="features-grid">
          <div className="feature-card">
            <h3>{t('home.features.aiPowered.title')}</h3>
            <p>{t('home.features.aiPowered.description')}</p>
          </div>
          <div className="feature-card">
            <h3>{t('home.features.communityDriven.title')}</h3>
            <p>{t('home.features.communityDriven.description')}</p>
          </div>
          <div className="feature-card">
            <h3>{t('home.features.openInteroperable.title')}</h3>
            <p>{t('home.features.openInteroperable.description')}</p>
          </div>
        </div>
      </section>

      <section className="workflow-section">
        <h2 className="workflow-title">{t('home.workflow.title')}</h2>
        <div className="workflow-grid">
          <div className="workflow-step">
            <div className="workflow-step-number">1</div>
            <h3>{t('home.workflow.step1.title')}</h3>
            <p>{t('home.workflow.step1.description')}</p>
          </div>
          <div className="workflow-step">
            <div className="workflow-step-number">2</div>
            <h3>{t('home.workflow.step2.title')}</h3>
            <p>{t('home.workflow.step2.description')}</p>
          </div>
          <div className="workflow-step">
            <div className="workflow-step-number">3</div>
            <h3>{t('home.workflow.step3.title')}</h3>
            <p>{t('home.workflow.step3.description')}</p>
          </div>
        </div>
      </section>

      <section className="closing-cta-section">
        <div className="closing-cta-content">
          <h2>{t('home.cta.title')}</h2>
          <p>{t('home.cta.subtitle')}</p>
          <a href="/register" className="hero-app-button"> {/* Reusing hero-app-button style for consistency */}
            {t('home.cta.button')}
          </a>
        </div>
      </section>
    </div>
  );
};

export default HomePage;