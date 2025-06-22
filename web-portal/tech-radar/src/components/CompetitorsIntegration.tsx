import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';

// data/competitorsData.ts (oder ähnlich) - Dies sollte in eine eigene Datei ausgelagert werden
export interface Competitor {
  id: string;
  nameKey: string;
  categoryKey: string;
  strengthKeys: string[];
  weaknessKeys: string[];
  partnershipPotential: 'high' | 'medium' | 'low';
  integrationAreaKeys: string[];
  logo?: string; // Emoji oder SVG-Pfad
  website?: string; // URL zur Webseite des Wettbewerbers
}

export interface Partnership {
  id: string;
  nameKey: string;
  typeKey: string; // 'technology', 'content', 'distribution', 'infrastructure'
  descriptionKey: string;
  benefitKeys: string[];
  requirementKeys: string[];
  status: 'exploring' | 'in-progress' | 'active' | 'completed' | 'on-hold'; // Erweiterte Statusoptionen
  partnerLogo?: string; // Emoji oder SVG-Pfad
  relatedCompetitorId?: string; // Um Partnerschaft mit Wettbewerber zu verknüpfen
}

// Beispielhafte Daten (sollten in einer separaten Datei oder CMS sein)
const competitorsData: Competitor[] = [
  {
    id: 'unity',
    nameKey: 'competitors.list.unity.name',
    categoryKey: 'competitors.categories.gameEngines',
    strengthKeys: ['competitors.list.unity.strengths.marketLeader', 'competitors.list.unity.strengths.largeCommunity', 'competitors.list.unity.strengths.comprehensiveTools'],
    weaknessKeys: ['competitors.list.unity.weaknesses.performanceIssues', 'competitors.list.unity.weaknesses.cost', 'competitors.list.unity.weaknesses.complexity'],
    partnershipPotential: 'high',
    integrationAreaKeys: ['competitors.list.unity.integration.assetStore', 'competitors.list.unity.integration.pluginDev'],
    logo: '🎮',
    website: 'https://unity.com/'
  },
  {
    id: 'unreal',
    nameKey: 'competitors.list.unreal.name',
    categoryKey: 'competitors.categories.gameEngines',
    strengthKeys: ['competitors.list.unreal.strengths.graphics', 'competitors.list.unreal.strengths.openSource', 'competitors.list.unreal.strengths.ecosystem'],
    weaknessKeys: ['competitors.list.unreal.weaknesses.learningCurve', 'competitors.list.unreal.weaknesses.complexity', 'competitors.list.unreal.weaknesses.overhead'],
    partnershipPotential: 'medium',
    integrationAreaKeys: ['competitors.list.unreal.integration.metahuman', 'competitors.list.unreal.integration.marketplace'],
    logo: '🚀',
    website: 'https://www.unrealengine.com/'
  },
  // ... Weitere Wettbewerber hier einfügen (Roblox, Minecraft, Blender, Autodesk, GitHub, Discord, Twitch, Steam)
  // Beispiel für Blender
  {
    id: 'blender',
    nameKey: 'competitors.list.blender.name',
    categoryKey: 'competitors.categories.tdTools',
    strengthKeys: ['competitors.list.blender.strengths.openSource', 'competitors.list.blender.strengths.free', 'competitors.list.blender.strengths.activeCommunity'],
    weaknessKeys: ['competitors.list.blender.weaknesses.learningCurve', 'competitors.list.blender.weaknesses.limitedSupport'],
    partnershipPotential: 'high',
    integrationAreaKeys: ['competitors.list.blender.integration.pluginDev', 'competitors.list.blender.integration.assetPipeline'],
    logo: '🎨',
    website: 'https://www.blender.org/'
  },
];

const partnershipsData: Partnership[] = [
  {
    id: 'unityAssetStore',
    nameKey: 'partnerships.list.unityAssetStore.name',
    typeKey: 'partnerships.types.technology',
    descriptionKey: 'partnerships.list.unityAssetStore.description',
    benefitKeys: ['partnerships.list.unityAssetStore.benefits.accessToDevelopers', 'partnerships.list.unityAssetStore.benefits.monetization', 'partnerships.list.unityAssetStore.benefits.brandAwareness'],
    requirementKeys: ['partnerships.list.unityAssetStore.requirements.qualityStandards', 'partnerships.list.unityAssetStore.requirements.pluginDevelopment', 'partnerships.list.unityAssetStore.requirements.supportInfrastructure'],
    status: 'exploring',
    relatedCompetitorId: 'unity'
  },
  {
    id: 'blenderPlugin',
    nameKey: 'partnerships.list.blenderPlugin.name',
    typeKey: 'partnerships.types.technology',
    descriptionKey: 'partnerships.list.blenderPlugin.description',
    benefitKeys: ['partnerships.list.blenderPlugin.benefits.openSourceCommunity', 'partnerships.list.blenderPlugin.benefits.freeDistribution', 'partnerships.list.blenderPlugin.benefits.technicalExpertise'],
    requirementKeys: ['partnerships.list.blenderPlugin.requirements.blenderApi', 'partnerships.list.blenderPlugin.requirements.pluginDevelopment', 'partnerships.list.blenderPlugin.requirements.communitySupport'],
    status: 'in-progress',
    relatedCompetitorId: 'blender'
  },
  // ... Weitere Partnerschaften
];
// Ende von data/competitorsData.ts


const CompetitorsIntegration: React.FC = () => {
  const { t } = useTranslation();
  const [activeTab, setActiveTab] = useState<'competitors' | 'partnerships'>('competitors');
  const [selectedCategoryKey, setSelectedCategoryKey] = useState<string>('all');

  // Holen der einzigartigen Kategorien aus den Wettbewerberdaten
  const competitorCategories = ['all', ...Array.from(new Set(competitorsData.map(c => c.categoryKey)))];

  const getPartnershipStatusColor = (status: Partnership['status']) => {
    switch (status) {
      case 'exploring': return '#f59e0b';
      case 'in-progress': return '#3b82f6'; // Same as in-talks for now
      case 'active': return '#10b981';
      case 'completed': return '#6b7280';
      case 'on-hold': return '#facc15'; // Yellow for on-hold
      default: return '#6b7280';
    }
  };

  const getPartnershipPotentialColor = (potential: Competitor['partnershipPotential']) => {
    switch (potential) {
      case 'high': return '#10b981'; // Green
      case 'medium': return '#f59e0b'; // Orange
      case 'low': return '#ef4444'; // Red
      default: return '#6b7280'; // Grey
    }
  };

  const filteredCompetitors = selectedCategoryKey === 'all'
    ? competitorsData
    : competitorsData.filter(c => c.categoryKey === selectedCategoryKey);

  return (
    <div className="competitors-integration">
      <div className="page-header glass">
        <h1>{t('competitors.mainTitle')}</h1>
        <p>{t('competitors.mainSubtitle')}</p>
      </div>

      <div className="tab-navigation">
        <button
          className={`tab-btn ${activeTab === 'competitors' ? 'active' : ''}`}
          onClick={() => setActiveTab('competitors')}
        >
          {t('competitors.tabs.competitors')}
        </button>
        <button
          className={`tab-btn ${activeTab === 'partnerships' ? 'active' : ''}`}
          onClick={() => setActiveTab('partnerships')}
        >
          {t('competitors.tabs.partnerships')}
        </button>
      </div>

      {activeTab === 'competitors' && (
        <div className="competitors-section">
          <div className="filter-section glass">
            <h3>{t('competitors.filters.title')}</h3>
            <div className="category-filters">
              {competitorCategories.map(categoryKey => (
                <button
                  key={categoryKey}
                  className={`category-btn ${selectedCategoryKey === categoryKey ? 'active' : ''}`}
                  onClick={() => setSelectedCategoryKey(categoryKey)}
                >
                  {categoryKey === 'all' ? t('competitors.filters.allCategories') : t(categoryKey)}
                </button>
              ))}
            </div>
          </div>

          <div className="competitors-grid">
            {filteredCompetitors.map((competitor) => (
              <div key={competitor.id} className="competitor-card glass">
                <div className="competitor-header">
                  <div className="competitor-logo">{competitor.logo || '🏢'}</div>
                  <div className="competitor-info">
                    <h3>
                        {t(competitor.nameKey)}
                        {competitor.website && (
                           <a href={competitor.website} target="_blank" rel="noopener noreferrer" style={{marginLeft: '8px', fontSize: '0.8em'}}>🔗</a>
                        )}
                    </h3>
                    <span className="competitor-category">{t(competitor.categoryKey)}</span>
                  </div>
                  <div
                    className="partnership-potential"
                    style={{ backgroundColor: getPartnershipPotentialColor(competitor.partnershipPotential) }}
                    title={t(`competitors.potential.${competitor.partnershipPotential}`)}
                  >
                    {t(`competitors.potentialAbbreviation.${competitor.partnershipPotential}`)}
                  </div>
                </div>

                <div className="competitor-analysis">
                  <div className="analysis-section">
                    <h4>{t('competitors.analysis.strengths')}</h4>
                    <ul>
                      {competitor.strengthKeys.map((key, idx) => (
                        <li key={idx} className="strength-item">✅ {t(key)}</li>
                      ))}
                    </ul>
                  </div>

                  <div className="analysis-section">
                    <h4>{t('competitors.analysis.weaknesses')}</h4>
                    <ul>
                      {competitor.weaknessKeys.map((key, idx) => (
                        <li key={idx} className="weakness-item">❌ {t(key)}</li>
                      ))}
                    </ul>
                  </div>

                  <div className="analysis-section">
                    <h4>{t('competitors.analysis.integrationAreas')}</h4>
                    <div className="integration-tags">
                      {competitor.integrationAreaKeys.map((key, idx) => (
                        <span key={idx} className="integration-tag">{t(key)}</span>
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
            <h3>{t('partnerships.overview.title')}</h3>
            <div className="partnership-stats">
              <div className="stat-card">
                <span className="stat-number">{partnershipsData.length}</span>
                <span className="stat-label">{t('partnerships.overview.total')}</span>
              </div>
              <div className="stat-card">
                <span className="stat-number">{partnershipsData.filter(p => p.status === 'active').length}</span>
                <span className="stat-label">{t('partnerships.overview.active')}</span>
              </div>
              <div className="stat-card">
                <span className="stat-number">{partnershipsData.filter(p => p.status === 'in-progress').length}</span>
                <span className="stat-label">{t('partnerships.overview.inProgress')}</span>
              </div>
               <div className="stat-card">
                <span className="stat-number">{partnershipsData.filter(p => p.status === 'exploring').length}</span>
                <span className="stat-label">{t('partnerships.overview.exploring')}</span>
              </div>
            </div>
          </div>

          <div className="partnerships-grid">
            {partnershipsData.map((partnership) => (
              <div key={partnership.id} className="partnership-card glass">
                <div className="partnership-header">
                  <h3>{t(partnership.nameKey)}</h3>
                  <div className="partnership-meta">
                    <span className="partnership-type">{t(partnership.typeKey)}</span>
                    <span
                      className="partnership-status"
                      style={{ backgroundColor: getPartnershipStatusColor(partnership.status) }}
                    >
                      {t(`partnerships.status.${partnership.status}`)}
                    </span>
                  </div>
                </div>

                <p className="partnership-description">{t(partnership.descriptionKey)}</p>

                <div className="partnership-details">
                  <div className="detail-section">
                    <h4>{t('partnerships.details.benefits')}</h4>
                    <ul>
                      {partnership.benefitKeys.map((key, idx) => (
                        <li key={idx}>🎯 {t(key)}</li>
                      ))}
                    </ul>
                  </div>

                  <div className="detail-section">
                    <h4>{t('partnerships.details.requirements')}</h4>
                    <ul>
                      {partnership.requirementKeys.map((key, idx) => (
                        <li key={idx}>📋 {t(key)}</li>
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