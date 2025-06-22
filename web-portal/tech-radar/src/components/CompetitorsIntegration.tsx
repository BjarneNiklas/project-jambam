import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';

interface Competitor {
  name: string;
  category: string;
  strengths: string[];
  weaknesses: string[];
  partnershipPotential: 'high' | 'medium' | 'low';
  integrationAreas: string[];
  logo?: string;
}

interface Partnership {
  name: string;
  type: 'technology' | 'content' | 'distribution' | 'infrastructure';
  description: string;
  benefits: string[];
  requirements: string[];
  status: 'exploring' | 'in-talks' | 'active' | 'completed';
}

const CompetitorsIntegration: React.FC = () => {
  const { t } = useTranslation();
  const [activeTab, setActiveTab] = useState<'competitors' | 'partnerships'>('competitors');
  const [selectedCategory, setSelectedCategory] = useState<string>('all');

  const competitors: Competitor[] = [
    {
      name: 'Unity Technologies',
      category: 'Game Engines',
      strengths: ['Marktführer', 'Große Community', 'Umfassende Tools', 'Cross-Platform'],
      weaknesses: ['Performance-Probleme', 'Hohe Kosten', 'Komplexität', 'Proprietär'],
      partnershipPotential: 'high',
      integrationAreas: ['Asset Store Integration', 'Plugin-Entwicklung', 'Educational Content'],
      logo: '🎮'
    },
    {
      name: 'Unreal Engine (Epic)',
      category: 'Game Engines',
      strengths: ['Hochwertige Grafik', 'Open Source', 'Fortnite Ecosystem', 'MetaHuman'],
      weaknesses: ['Steile Lernkurve', 'Überkomplexität', 'Performance-Overhead'],
      partnershipPotential: 'medium',
      integrationAreas: ['MetaHuman Integration', 'Marketplace Partnership', 'Educational Programs'],
      logo: '🚀'
    },
    {
      name: 'Roblox',
      category: 'Platforms',
      strengths: ['Massive User Base', 'Monetization', 'Creator Economy', 'Social Features'],
      weaknesses: ['Qualitätsprobleme', 'Sicherheitsbedenken', 'Begrenzte Kreativität'],
      partnershipPotential: 'high',
      integrationAreas: ['Creator Tools', 'Educational Platform', 'Asset Marketplace'],
      logo: '🎪'
    },
    {
      name: 'Minecraft (Microsoft)',
      category: 'Platforms',
      strengths: ['Kultstatus', 'Educational Value', 'Modding Community', 'Cross-Platform'],
      weaknesses: ['Begrenzte Grafik', 'Performance Issues', 'Microsoft-Abhängigkeit'],
      partnershipPotential: 'medium',
      integrationAreas: ['Educational Content', 'Modding Tools', 'Server Integration'],
      logo: '⛏️'
    },
    {
      name: 'Blender Foundation',
      category: '3D Tools',
      strengths: ['Open Source', 'Kostenlos', 'Aktive Community', 'Umfassend'],
      weaknesses: ['Steile Lernkurve', 'Begrenzte Support', 'Performance'],
      partnershipPotential: 'high',
      integrationAreas: ['Plugin Development', 'Asset Pipeline', 'Educational Content'],
      logo: '🎨'
    },
    {
      name: 'Autodesk',
      category: '3D Tools',
      strengths: ['Industriestandard', 'Professionelle Tools', 'Umfassender Support'],
      weaknesses: ['Sehr teuer', 'Komplex', 'Proprietär', 'Cloud-Abhängigkeit'],
      partnershipPotential: 'low',
      integrationAreas: ['Educational Licensing', 'Student Programs', 'Plugin Development'],
      logo: '🏗️'
    },
    {
      name: 'GitHub (Microsoft)',
      category: 'Development',
      strengths: ['Marktführer', 'Git Integration', 'CI/CD', 'Community'],
      weaknesses: ['Microsoft-Abhängigkeit', 'Kosten', 'Begrenzte Privatsphäre'],
      partnershipPotential: 'medium',
      integrationAreas: ['Open Source Projects', 'Educational Programs', 'CI/CD Integration'],
      logo: '🐙'
    },
    {
      name: 'Discord',
      category: 'Community',
      strengths: ['Massive User Base', 'Voice/Video', 'Bot Ecosystem', 'Gaming Focus'],
      weaknesses: ['Begrenzte Monetization', 'Sicherheitsprobleme', 'Proprietär'],
      partnershipPotential: 'high',
      integrationAreas: ['Bot Development', 'Community Integration', 'Educational Servers'],
      logo: '💬'
    },
    {
      name: 'Twitch (Amazon)',
      category: 'Content',
      strengths: ['Live Streaming Leader', 'Monetization', 'Gaming Community'],
      weaknesses: ['Amazon-Abhängigkeit', 'Begrenzte Interaktivität', 'Content Moderation'],
      partnershipPotential: 'medium',
      integrationAreas: ['Streaming Integration', 'Educational Content', 'Community Features'],
      logo: '📺'
    },
    {
      name: 'Steam (Valve)',
      category: 'Distribution',
      strengths: ['Marktführer', 'Umfassende Features', 'Community Tools'],
      weaknesses: ['Valve-Abhängigkeit', 'Begrenzte Kontrolle', 'Proprietär'],
      partnershipPotential: 'medium',
      integrationAreas: ['Game Distribution', 'Community Features', 'Educational Games'],
      logo: '🎮'
    }
  ];

  const partnerships: Partnership[] = [
    {
      name: 'Unity Asset Store Integration',
      type: 'technology',
      description: 'Integration unserer AI-generierten Assets in den Unity Asset Store',
      benefits: ['Direkter Zugang zu Unity-Entwicklern', 'Monetization-Möglichkeiten', 'Markenbekanntheit'],
      requirements: ['Asset-Qualitätsstandards', 'Unity-Plugin-Entwicklung', 'Support-Infrastruktur'],
      status: 'exploring'
    },
    {
      name: 'Blender Plugin Ecosystem',
      type: 'technology',
      description: 'Entwicklung von Plugins für Blender zur AI-gestützten 3D-Modellierung',
      benefits: ['Open Source Community', 'Kostenlose Distribution', 'Technische Expertise'],
      requirements: ['Blender Python API', 'Plugin-Entwicklung', 'Community Support'],
      status: 'in-talks'
    },
    {
      name: 'Educational Institution Partnerships',
      type: 'content',
      description: 'Partnerschaften mit Universitäten und Schulen für Game Development Kurse',
      benefits: ['Talent-Pipeline', 'Markenbekanntheit', 'Forschungsmöglichkeiten'],
      requirements: ['Curriculum-Entwicklung', 'Lizenzierung', 'Support-Team'],
      status: 'exploring'
    },
    {
      name: 'Discord Bot Integration',
      type: 'technology',
      description: 'Entwicklung von Discord Bots für Community-Management und Gamification',
      benefits: ['Direkter Community-Zugang', 'User Engagement', 'Monetization'],
      requirements: ['Discord API', 'Bot-Entwicklung', 'Community Management'],
      status: 'active'
    },
    {
      name: 'Open Source Game Engine Collaboration',
      type: 'technology',
      description: 'Kollaboration mit Open Source Game Engines wie Godot oder Bevy',
      benefits: ['Community Building', 'Technische Expertise', 'Innovation'],
      requirements: ['Engine-Entwicklung', 'Documentation', 'Community Support'],
      status: 'exploring'
    },
    {
      name: 'Content Creator Network',
      type: 'content',
      description: 'Partnerschaft mit Content Creators für Tutorials und Showcases',
      benefits: ['Marketing', 'User Acquisition', 'Community Building'],
      requirements: ['Creator Agreements', 'Content Guidelines', 'Monetization Model'],
      status: 'in-talks'
    },
    {
      name: 'Cloud Infrastructure Partnerships',
      type: 'infrastructure',
      description: 'Partnerschaften mit Cloud-Providern für skalierbare Infrastruktur',
      benefits: ['Kosteneinsparungen', 'Skalierbarkeit', 'Technische Expertise'],
      requirements: ['Infrastructure Planning', 'Cost Analysis', 'Technical Integration'],
      status: 'exploring'
    },
    {
      name: 'Indie Game Developer Support',
      type: 'distribution',
      description: 'Support-Programm für Indie-Entwickler mit unserem Tech Stack',
      benefits: ['Ecosystem Building', 'Innovation', 'Community Growth'],
      requirements: ['Support-Programm', 'Documentation', 'Community Management'],
      status: 'active'
    }
  ];

  const categories = ['all', ...Array.from(new Set(competitors.map(c => c.category)))];

  const getPartnershipStatusColor = (status: string) => {
    switch (status) {
      case 'exploring': return '#f59e0b';
      case 'in-talks': return '#3b82f6';
      case 'active': return '#10b981';
      case 'completed': return '#6b7280';
      default: return '#6b7280';
    }
  };

  const getPartnershipStatusText = (status: string) => {
    switch (status) {
      case 'exploring': return 'Erkundung';
      case 'in-talks': return 'In Gesprächen';
      case 'active': return 'Aktiv';
      case 'completed': return 'Abgeschlossen';
      default: return 'Unbekannt';
    }
  };

  const getPotentialColor = (potential: string) => {
    switch (potential) {
      case 'high': return '#10b981';
      case 'medium': return '#f59e0b';
      case 'low': return '#ef4444';
      default: return '#6b7280';
    }
  };

  const filteredCompetitors = selectedCategory === 'all' 
    ? competitors 
    : competitors.filter(c => c.category === selectedCategory);

  return (
    <div className="competitors-integration">
      <div className="page-header glass">
        <h1>{t('competitors.title')}</h1>
        <p>{t('competitors.subtitle')}</p>
      </div>

      <div className="tab-navigation">
        <button
          className={`tab-btn ${activeTab === 'competitors' ? 'active' : ''}`}
          onClick={() => setActiveTab('competitors')}
        >
          {t('competitors.tab')}
        </button>
        <button
          className={`tab-btn ${activeTab === 'partnerships' ? 'active' : ''}`}
          onClick={() => setActiveTab('partnerships')}
        >
          {t('partnerships.tab')}
        </button>
      </div>

      {activeTab === 'competitors' && (
        <div className="competitors-section">
          <div className="filter-section glass">
            <h3>{t('competitors.filterByCategory')}</h3>
            <div className="category-filters">
              {categories.map(category => (
                <button
                  key={category}
                  className={`category-btn ${selectedCategory === category ? 'active' : ''}`}
                  onClick={() => setSelectedCategory(category)}
                >
                  {category === 'all' ? t('competitors.allCategories') : category}
                </button>
              ))}
            </div>
          </div>

          <div className="competitors-grid">
            {filteredCompetitors.map((competitor, index) => (
              <div key={index} className="competitor-card glass">
                <div className="competitor-header">
                  <div className="competitor-logo">{competitor.logo}</div>
                  <div className="competitor-info">
                    <h3>{competitor.name}</h3>
                    <span className="competitor-category">{competitor.category}</span>
                  </div>
                  <div 
                    className="partnership-potential"
                    style={{ backgroundColor: getPotentialColor(competitor.partnershipPotential) }}
                  >
                    {competitor.partnershipPotential.toUpperCase()}
                  </div>
                </div>

                <div className="competitor-analysis">
                  <div className="analysis-section">
                    <h4>{t('competitors.strengths')}</h4>
                    <ul>
                      {competitor.strengths.map((strength, idx) => (
                        <li key={idx} className="strength-item">✅ {strength}</li>
                      ))}
                    </ul>
                  </div>

                  <div className="analysis-section">
                    <h4>{t('competitors.weaknesses')}</h4>
                    <ul>
                      {competitor.weaknesses.map((weakness, idx) => (
                        <li key={idx} className="weakness-item">❌ {weakness}</li>
                      ))}
                    </ul>
                  </div>

                  <div className="analysis-section">
                    <h4>{t('competitors.integrationAreas')}</h4>
                    <div className="integration-tags">
                      {competitor.integrationAreas.map((area, idx) => (
                        <span key={idx} className="integration-tag">{area}</span>
                      ))}
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {activeTab === 'partnerships' && (
        <div className="partnerships-section">
          <div className="partnerships-overview glass">
            <h3>{t('partnerships.overview')}</h3>
            <div className="partnership-stats">
              <div className="stat-card">
                <span className="stat-number">{partnerships.length}</span>
                <span className="stat-label">{t('partnerships.total')}</span>
              </div>
              <div className="stat-card">
                <span className="stat-number">{partnerships.filter(p => p.status === 'active').length}</span>
                <span className="stat-label">{t('partnerships.active')}</span>
              </div>
              <div className="stat-card">
                <span className="stat-number">{partnerships.filter(p => p.status === 'in-talks').length}</span>
                <span className="stat-label">{t('partnerships.inTalks')}</span>
              </div>
            </div>
          </div>

          <div className="partnerships-grid">
            {partnerships.map((partnership, index) => (
              <div key={index} className="partnership-card glass">
                <div className="partnership-header">
                  <h3>{partnership.name}</h3>
                  <div className="partnership-meta">
                    <span className="partnership-type">{partnership.type}</span>
                    <span 
                      className="partnership-status"
                      style={{ backgroundColor: getPartnershipStatusColor(partnership.status) }}
                    >
                      {getPartnershipStatusText(partnership.status)}
                    </span>
                  </div>
                </div>

                <p className="partnership-description">{partnership.description}</p>

                <div className="partnership-details">
                  <div className="detail-section">
                    <h4>{t('partnerships.benefits')}</h4>
                    <ul>
                      {partnership.benefits.map((benefit, idx) => (
                        <li key={idx}>🎯 {benefit}</li>
                      ))}
                    </ul>
                  </div>

                  <div className="detail-section">
                    <h4>{t('partnerships.requirements')}</h4>
                    <ul>
                      {partnership.requirements.map((requirement, idx) => (
                        <li key={idx}>📋 {requirement}</li>
                      ))}
                    </ul>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default CompetitorsIntegration; 