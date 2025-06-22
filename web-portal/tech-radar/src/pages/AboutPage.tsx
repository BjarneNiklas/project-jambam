import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import './AboutPage.css';
import ValueCard from '../components/ValueCard';
import TeamMemberCard from '../components/TeamMemberCard';
import ProductsShowcase from '../components/ProductsShowcase';
import CompetitorsIntegration from '../components/CompetitorsIntegration';

// In a real app, this would come from a CMS or API
const valuesData = [
  { id: 'innovation', icon: '🚀' },
  { id: 'community', icon: '🤝' },
  { id: 'quality', icon: '⭐' },
  { id: 'collaboration', icon: '👥' },
];

const teamData = [
  {
    id: 'bjarne',
    nameKey: 'team.bjarne.name',
    role: 'founder_visionary',
    avatarUrl: 'https://via.placeholder.com/150/000000/FFFFFF/?text=BL',
    portfolioUrl: 'https://www.luv-y.com'
  },
  // Add more team members here
];

type ViewType = 'about' | 'products' | 'competitors';

const AboutPage: React.FC = () => {
  const { t } = useTranslation();
  const [currentView, setCurrentView] = useState<ViewType>('about');

  return (
    <div className="about-page">
      <div className="view-toggle">
        <button
          className={`toggle-btn ${currentView === 'about' ? 'active' : ''}`}
          onClick={() => setCurrentView('about')}
        >
          {t('nav.about')}
        </button>
        <button
          className={`toggle-btn ${currentView === 'products' ? 'active' : ''}`}
          onClick={() => setCurrentView('products')}
        >
          {t('viewToggle.products')}
        </button>
        <button
          className={`toggle-btn ${currentView === 'competitors' ? 'active' : ''}`}
          onClick={() => setCurrentView('competitors')}
        >
          {t('viewToggle.competitors')}
        </button>
      </div>

      {currentView === 'about' && (
        <>
          <header className="about-header">
            <h1>{t('about.title')}</h1>
            <p className="subtitle">{t('about.subtitle')}</p>
          </header>

          <section className="about-section" id="mission">
            <h2>{t('about.mission.title')}</h2>
            <p>{t('about.mission.description')}</p>
          </section>

          <section className="about-section" id="values">
            <h2>{t('about.values.title')}</h2>
            <div className="values-grid">
              {valuesData.map((value) => (
                <ValueCard
                  key={value.id}
                  icon={value.icon}
                  title={t(`about.values.${value.id}.title`)}
                  description={t(`about.values.${value.id}.description`)}
                />
              ))}
            </div>
          </section>
          
          <section className="about-section" id="team">
            <h2>{t('about.team.title')}</h2>
            <p>{t('about.team.description')}</p>
            <div className="team-grid">
              {teamData.map((member) => (
                <TeamMemberCard
                  key={member.id}
                  name={t(member.nameKey)}
                  role={t(`about.team.roles.${member.role}`)}
                  avatarUrl={member.avatarUrl}
                  portfolioUrl={member.portfolioUrl}
                />
              ))}
            </div>
          </section>
        </>
      )}

      {currentView === 'products' && <ProductsShowcase />}
      {currentView === 'competitors' && <CompetitorsIntegration />}
    </div>
  );
};

export default AboutPage; 