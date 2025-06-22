import React from 'react';
import { useTranslation } from 'react-i18next';
import './ProjectShowcase.css';

const ProjectShowcase: React.FC = () => {
  const { t } = useTranslation();

  const coreFeatures = [
    {
      id: 'gamejam',
      icon: '🎮',
      title: t('project.features.gamejam.title'),
      subtitle: t('project.features.gamejam.subtitle'),
      description: t('project.features.gamejam.description'),
      benefits: [
        t('project.features.gamejam.benefits.rapid'),
        t('project.features.gamejam.benefits.ai'),
        t('project.features.gamejam.benefits.collaboration'),
        t('project.features.gamejam.benefits.events')
      ],
      color: 'linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%)'
    },
    {
      id: 'marketplace',
      icon: '🛒',
      title: t('project.features.marketplace.title'),
      subtitle: t('project.features.marketplace.subtitle'),
      description: t('project.features.marketplace.description'),
      benefits: [
        t('project.features.marketplace.benefits.sharing'),
        t('project.features.marketplace.benefits.monetization'),
        t('project.features.marketplace.benefits.quality'),
        t('project.features.marketplace.benefits.community')
      ],
      color: 'linear-gradient(135deg, #10b981 0%, #059669 100%)'
    },
    {
      id: 'universal',
      icon: '🔗',
      title: t('project.features.universal.title'),
      subtitle: t('project.features.universal.subtitle'),
      description: t('project.features.universal.description'),
      benefits: [
        t('project.features.universal.benefits.freedom'),
        t('project.features.universal.benefits.crossplatform'),
        t('project.features.universal.benefits.assets'),
        t('project.features.universal.benefits.build')
      ],
      color: 'linear-gradient(135deg, #f59e0b 0%, #d97706 100%)'
    },
    {
      id: 'educational',
      icon: '🎓',
      title: t('project.features.educational.title'),
      subtitle: t('project.features.educational.subtitle'),
      description: t('project.features.educational.description'),
      benefits: [
        t('project.features.educational.benefits.learning'),
        t('project.features.educational.benefits.multilingual'),
        t('project.features.educational.benefits.practical'),
        t('project.features.educational.benefits.community')
      ],
      color: 'linear-gradient(135deg, #ec4899 0%, #be185d 100%)'
    }
  ];

  return (
    <div className="project-showcase">
      <div className="showcase-header">
        <h1>{t('project.title')}</h1>
        <p className="showcase-subtitle">{t('project.subtitle')}</p>
        <div className="vision-statement">
          <blockquote>
            {t('project.vision')}
          </blockquote>
        </div>
      </div>

      <div className="core-features">
        <h2>{t('project.coreFeatures.title')}</h2>
        <p className="core-features-intro">{t('project.coreFeatures.intro')}</p>
        
        <div className="features-grid">
          {coreFeatures.map((feature, index) => (
            <div 
              key={feature.id} 
              className="feature-card"
              style={{ '--feature-color': feature.color } as React.CSSProperties}
            >
              <div className="feature-header">
                <div className="feature-icon" style={{ background: feature.color }}>
                  <span>{feature.icon}</span>
                </div>
                <div className="feature-title-section">
                  <h3>{feature.title}</h3>
                  <p className="feature-subtitle">{feature.subtitle}</p>
                </div>
              </div>
              
              <div className="feature-content">
                <p className="feature-description">{feature.description}</p>
                
                <div className="feature-benefits">
                  <h4>{t('project.benefits.title')}</h4>
                  <ul>
                    {feature.benefits.map((benefit, idx) => (
                      <li key={idx}>
                        <span className="benefit-icon">✓</span>
                        {benefit}
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
              
              <div className="feature-footer">
                <div className="feature-status">
                  <span className="status-badge">
                    {t('project.status.inDevelopment')}
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="project-highlights">
        <h2>{t('project.highlights.title')}</h2>
        
        <div className="highlights-grid">
          <div className="highlight-card">
            <div className="highlight-icon">🚀</div>
            <h3>{t('project.highlights.innovation.title')}</h3>
            <p>{t('project.highlights.innovation.description')}</p>
          </div>
          
          <div className="highlight-card">
            <div className="highlight-icon">🌍</div>
            <h3>{t('project.highlights.european.title')}</h3>
            <p>{t('project.highlights.european.description')}</p>
          </div>
          
          <div className="highlight-card">
            <div className="highlight-icon">🤖</div>
            <h3>{t('project.highlights.ai.title')}</h3>
            <p>{t('project.highlights.ai.description')}</p>
          </div>
          
          <div className="highlight-card">
            <div className="highlight-icon">🔒</div>
            <h3>{t('project.highlights.security.title')}</h3>
            <p>{t('project.highlights.security.description')}</p>
          </div>
        </div>
      </div>

      <div className="project-roadmap">
        <h2>{t('project.roadmap.title')}</h2>
        <p>{t('project.roadmap.intro')}</p>
        
        <div className="roadmap-timeline">
          <div className="timeline-item">
            <div className="timeline-phase">Phase 1</div>
            <div className="timeline-content">
              <h4>{t('project.roadmap.phase1.title')}</h4>
              <p>{t('project.roadmap.phase1.description')}</p>
            </div>
          </div>
          
          <div className="timeline-item">
            <div className="timeline-phase">Phase 2</div>
            <div className="timeline-content">
              <h4>{t('project.roadmap.phase2.title')}</h4>
              <p>{t('project.roadmap.phase2.description')}</p>
            </div>
          </div>
          
          <div className="timeline-item">
            <div className="timeline-phase">Phase 3</div>
            <div className="timeline-content">
              <h4>{t('project.roadmap.phase3.title')}</h4>
              <p>{t('project.roadmap.phase3.description')}</p>
            </div>
          </div>
          
          <div className="timeline-item">
            <div className="timeline-phase">Phase 4</div>
            <div className="timeline-content">
              <h4>{t('project.roadmap.phase4.title')}</h4>
              <p>{t('project.roadmap.phase4.description')}</p>
            </div>
          </div>
          
          <div className="timeline-item">
            <div className="timeline-phase">Phase 5</div>
            <div className="timeline-content">
              <h4>{t('project.roadmap.phase5.title')}</h4>
              <p>{t('project.roadmap.phase5.description')}</p>
            </div>
          </div>
        </div>
      </div>

      <div className="project-cta">
        <h2>{t('project.cta.title')}</h2>
        <p>{t('project.cta.description')}</p>
        <div className="cta-buttons">
          <button className="cta-primary">
            {t('project.cta.joinCommunity')}
          </button>
          <button className="cta-secondary">
            {t('project.cta.learnMore')}
          </button>
        </div>
      </div>
    </div>
  );
};

export default ProjectShowcase; 