import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import './AboutPage.css';
import ValueCard from '../components/ValueCard';
import TeamMemberCard from '../components/TeamMemberCard';
import ProductsShowcase from '../components/ProductsShowcase';
import CompetitorsIntegration from '../components/CompetitorsIntegration';

// In a real app, this would come from a CMS or API
const valuesData = [
  { id: 'innovation', icon: '🚀', titleKey: 'about.values.innovation.title', descriptionKey: 'about.values.innovation.description' },
  { id: 'community', icon: '🤝', titleKey: 'about.values.community.title', descriptionKey: 'about.values.community.description' },
  { id: 'quality', icon: '⭐', titleKey: 'about.values.quality.title', descriptionKey: 'about.values.quality.description' },
  { id: 'collaboration', icon: '👥', titleKey: 'about.values.collaboration.title', descriptionKey: 'about.values.collaboration.description' },
  { id: 'openness', icon: '🌐', titleKey: 'about.values.openness.title', descriptionKey: 'about.values.openness.description' },
  { id: 'sustainability', icon: '🌱', titleKey: 'about.values.sustainability.title', descriptionKey: 'about.values.sustainability.description' },
];

const teamData = [
  {
    id: 'bjarne',
    nameKey: 'team.bjarne.name',
    roleKey: 'about.team.roles.founder_visionary',
    avatarUrl: 'https://via.placeholder.com/150/007BFF/FFFFFF/?text=BL',
    portfolioUrl: 'https://www.luv-y.com',
    bioKey: 'about.team.bjarne.bio'
  },
  {
    id: 'jane_doe',
    nameKey: 'team.jane_doe.name',
    roleKey: 'about.team.roles.lead_developer',
    avatarUrl: 'https://via.placeholder.com/150/28A745/FFFFFF/?text=JD',
    portfolioUrl: '#',
    bioKey: 'about.team.jane_doe.bio'
  },
  {
    id: 'john_smith',
    nameKey: 'team.john_smith.name',
    roleKey: 'about.team.roles.community_manager',
    avatarUrl: 'https://via.placeholder.com/150/FFC107/000000/?text=JS',
    portfolioUrl: '#',
    bioKey: 'about.team.john_smith.bio'
  },
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
                  title={t(value.titleKey)}
                  description={t(value.descriptionKey)}
                />
              ))}
            </div>
          </section>

          <section className="about-section" id="team">
            <h2>{t('about.team.title')}</h2>
            <p>{t('about.team.intro')}</p> {/* Changed from about.team.description to about.team.intro for more general intro */}
            <div className="team-grid">
              {teamData.map((member) => (
                <TeamMemberCard
                  key={member.id}
                  name={t(member.nameKey)}
                  role={t(member.roleKey)}
                  avatarUrl={member.avatarUrl}
                  portfolioUrl={member.portfolioUrl}
                  bio={t(member.bioKey)} // Added bio
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