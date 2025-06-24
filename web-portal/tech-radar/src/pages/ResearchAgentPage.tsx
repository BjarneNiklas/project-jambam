import React, { useState } from 'react';
import './ResearchAgentPage.css';

interface ResearchSource {
  id: string;
  name: string;
  category: 'scientific' | 'practical' | 'ai' | 'community';
  ethicalConcerns: string[];
  isEnabled: boolean;
  description: string;
  priority: number;
}

interface BusinessValue {
  title: string;
  description: string;
  metrics: string[];
  icon: string;
}

const ResearchAgentPage: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'overview' | 'business-value' | 'ethical-controls' | 'sources'>('overview');

  const businessValues: BusinessValue[] = [
    {
      title: 'Development Speed',
      description: 'Beschleunigte Forschung und Entwicklung durch automatisierte Quellen-Suche',
      metrics: [
        'Faster Research durch 18 automatisierte APIs',
        'Better Decisions durch wissenschaftliche Validierung',
        'Reduced Risk durch Market Research',
        'Innovation Boost durch Cross-Domain Insights'
      ],
      icon: '⚡'
    },
    {
      title: 'Quality Improvement',
      description: 'Wissenschaftlich fundierte Entwicklung statt Intuition',
      metrics: [
        'Evidence-based Design durch Peer-reviewed Papers',
        'Technical Excellence durch Research Standards',
        'Community Validation für User Acceptance',
        'Best Practices aus Industry Research'
      ],
      icon: '🎯'
    },
    {
      title: 'Market Success',
      description: 'Data-driven Entscheidungen für bessere Marktpositionierung',
      metrics: [
        'Trend Awareness für bessere Timing',
        'User Understanding für bessere UX',
        'Competitive Advantage durch Innovation',
        'Risk Mitigation durch Research Validation'
      ],
      icon: '📈'
    },
    {
      title: 'Ethical Development',
      description: 'Verantwortungsvolle KI-Entwicklung mit ethischen Kontrollen',
      metrics: [
        'Addiction Research für bewusste Game Design',
        'Community Manipulation vermeiden',
        'AI Bias erkennen und vermeiden',
        'Commercialization kontrollieren'
      ],
      icon: '🛡️'
    }
  ];

  const researchSources: ResearchSource[] = [
    // Scientific APIs (12)
    { id: 'arxiv', name: 'ArXiv', category: 'scientific', ethicalConcerns: [], isEnabled: true, description: 'Preprints für Game AI, Computer Graphics, HCI', priority: 1 },
    { id: 'pubmed', name: 'PubMed', category: 'scientific', ethicalConcerns: ['Addiction Research'], isEnabled: true, description: 'Medizinische Forschung für Gaming Psychology', priority: 2 },
    { id: 'doj', name: 'DOAJ', category: 'scientific', ethicalConcerns: [], isEnabled: true, description: 'Open Access Journals für Game Studies', priority: 3 },
    { id: 'crossref', name: 'Crossref', category: 'scientific', ethicalConcerns: [], isEnabled: true, description: 'DOI-Metadaten für alle wissenschaftlichen Papers', priority: 1 },
    { id: 'semanticScholar', name: 'Semantic Scholar', category: 'scientific', ethicalConcerns: [], isEnabled: true, description: 'AI-powered wissenschaftliche Suche', priority: 1 },
    { id: 'ieee', name: 'IEEE', category: 'scientific', ethicalConcerns: [], isEnabled: true, description: 'Game Engineering, VR/AR, Computer Graphics', priority: 2 },
    { id: 'acm', name: 'ACM', category: 'scientific', ethicalConcerns: [], isEnabled: true, description: 'CHI, SIGGRAPH, Game Design Patterns', priority: 2 },
    { id: 'openAlex', name: 'OpenAlex', category: 'scientific', ethicalConcerns: [], isEnabled: true, description: 'Umfassender wissenschaftlicher Katalog', priority: 1 },
    { id: 'dblp', name: 'DBLP', category: 'scientific', ethicalConcerns: [], isEnabled: true, description: 'Computer Science Bibliography', priority: 3 },
    { id: 'core', name: 'CORE', category: 'scientific', ethicalConcerns: [], isEnabled: true, description: 'Open Access Aggregator', priority: 3 },
    { id: 'springer', name: 'Springer', category: 'scientific', ethicalConcerns: ['Addiction Research'], isEnabled: true, description: 'Interdisziplinäre Forschung', priority: 3 },
    { id: 'elsevier', name: 'Elsevier', category: 'scientific', ethicalConcerns: ['Addiction Research'], isEnabled: true, description: 'Computer Science, Psychology, Media Studies', priority: 3 },

    // Practical APIs (6)
    { id: 'steam', name: 'Steam', category: 'practical', ethicalConcerns: ['Addiction Research', 'Market Manipulation'], isEnabled: true, description: 'Game Platform Data für Market Trends', priority: 1 },
    { id: 'twitch', name: 'Twitch', category: 'practical', ethicalConcerns: ['Addiction Research', 'Community Manipulation'], isEnabled: true, description: 'Streaming Platform Data für Popularität', priority: 1 },
    { id: 'reddit', name: 'Reddit', category: 'practical', ethicalConcerns: ['Community Manipulation', 'Echo Chambers'], isEnabled: true, description: 'Community Discussions für Developer Insights', priority: 2 },
    { id: 'youtube', name: 'YouTube', category: 'practical', ethicalConcerns: ['Addiction Research', 'Algorithm Manipulation'], isEnabled: true, description: 'Video Content für Tutorials und Reviews', priority: 2 },
    { id: 'itchio', name: 'Itch.io', category: 'practical', ethicalConcerns: [], isEnabled: true, description: 'Indie Game Platform für experimentelle Designs', priority: 2 },
    { id: 'blogs', name: 'Blogs', category: 'practical', ethicalConcerns: [], isEnabled: true, description: 'Industry Articles für Post-mortems und Tutorials', priority: 3 },

    // AI/ML APIs (8) - Standardmäßig deaktiviert
    { id: 'huggingFace', name: 'Hugging Face', category: 'ai', ethicalConcerns: ['AI Bias', 'Model Misuse'], isEnabled: false, description: 'Model Hub & Datasets für AI/ML Research', priority: 1 },
    { id: 'openAI', name: 'OpenAI', category: 'ai', ethicalConcerns: ['AI Bias', 'Commercialization'], isEnabled: false, description: 'GPT & AI Research für State-of-the-art Models', priority: 1 },
    { id: 'papersWithCode', name: 'Papers with Code', category: 'ai', ethicalConcerns: [], isEnabled: false, description: 'State-of-the-art ML Research mit Code', priority: 1 },
    { id: 'modelScope', name: 'ModelScope', category: 'ai', ethicalConcerns: ['AI Bias', 'Data Privacy'], isEnabled: false, description: 'Alibaba\'s Model Repository', priority: 2 },
    { id: 'replicate', name: 'Replicate', category: 'ai', ethicalConcerns: ['Commercialization', 'Model Misuse'], isEnabled: false, description: 'Cloud ML Model Hosting', priority: 2 },
    { id: 'aiHub', name: 'AI Hub', category: 'ai', ethicalConcerns: ['AI Bias', 'Commercialization'], isEnabled: false, description: 'Google\'s AI Research Hub', priority: 2 },
    { id: 'microsoftResearch', name: 'MS Research', category: 'ai', ethicalConcerns: ['Commercialization'], isEnabled: false, description: 'Microsoft Research Papers', priority: 2 },

    // Community APIs (4) - Standardmäßig deaktiviert
    { id: 'twitterAI', name: 'Twitter AI', category: 'community', ethicalConcerns: ['Echo Chambers', 'Misinformation', 'Addiction Research'], isEnabled: false, description: 'Real-time AI Research Updates', priority: 3 },
    { id: 'discordAI', name: 'Discord AI', category: 'community', ethicalConcerns: ['Echo Chambers', 'Community Manipulation'], isEnabled: false, description: 'AI Research Discord Servers', priority: 3 },
    { id: 'githubAI', name: 'GitHub AI', category: 'community', ethicalConcerns: [], isEnabled: false, description: 'AI/ML GitHub Repositories', priority: 2 },
    { id: 'stackOverflowAI', name: 'Stack Overflow AI', category: 'community', ethicalConcerns: [], isEnabled: false, description: 'AI/ML Development Questions', priority: 2 },
  ];

  const stats = {
    totalSources: researchSources.length,
    activeSources: researchSources.filter(s => s.isEnabled).length,
    scientificSources: researchSources.filter(s => s.isEnabled && s.category === 'scientific').length,
    practicalSources: researchSources.filter(s => s.isEnabled && s.category === 'practical').length,
    aiSources: researchSources.filter(s => s.isEnabled && s.category === 'ai').length,
    communitySources: researchSources.filter(s => s.isEnabled && s.category === 'community').length,
  };

  return (
    <div className="research-agent-page">
      <div className="hero-section">
        <h1>Research Agent</h1>
        <p className="hero-subtitle">
          KI-generierte Videospielentwicklung mit wissenschaftlich fundierter Forschung
        </p>
        <div className="stats-grid">
          <div className="stat-card">
            <div className="stat-number">{stats.totalSources}</div>
            <div className="stat-label">Total Sources</div>
          </div>
          <div className="stat-card">
            <div className="stat-number">{stats.activeSources}</div>
            <div className="stat-label">Active Sources</div>
          </div>
          <div className="stat-card">
            <div className="stat-number">{Math.round((stats.activeSources / stats.totalSources) * 100)}%</div>
            <div className="stat-label">Activation Rate</div>
          </div>
        </div>
      </div>

      <div className="tabs-container">
        <div className="tabs">
          <button 
            className={`tab ${activeTab === 'overview' ? 'active' : ''}`}
            onClick={() => setActiveTab('overview')}
          >
            Overview
          </button>
          <button 
            className={`tab ${activeTab === 'business-value' ? 'active' : ''}`}
            onClick={() => setActiveTab('business-value')}
          >
            Business Value
          </button>
          <button 
            className={`tab ${activeTab === 'ethical-controls' ? 'active' : ''}`}
            onClick={() => setActiveTab('ethical-controls')}
          >
            Ethical Controls
          </button>
          <button 
            className={`tab ${activeTab === 'sources' ? 'active' : ''}`}
            onClick={() => setActiveTab('sources')}
          >
            Research Sources
          </button>
        </div>

        <div className="tab-content">
          {activeTab === 'overview' && (
            <div className="overview-content">
              <h2>Research Agent Overview</h2>
              <p>
                Der Research Agent ist ein fundamentales Tool für KI-generierte Videospielentwicklung, 
                das 18 verschiedene Quellen durchsucht und wissenschaftlich fundierte Daten sammelt.
              </p>
              
              <div className="features-grid">
                <div className="feature-card">
                  <h3>🔬 Wissenschaftliche APIs (12)</h3>
                  <p>ArXiv, PubMed, IEEE, ACM, Semantic Scholar und mehr für peer-reviewed Research</p>
                </div>
                <div className="feature-card">
                  <h3>🎮 Praktische APIs (6)</h3>
                  <p>Steam, Twitch, Reddit, YouTube für Industry Insights und Community Feedback</p>
                </div>
                <div className="feature-card">
                  <h3>🤖 AI/ML APIs (8)</h3>
                  <p>Hugging Face, OpenAI, Papers with Code für State-of-the-art KI-Forschung</p>
                </div>
                <div className="feature-card">
                  <h3>👥 Community APIs (4)</h3>
                  <p>GitHub, Stack Overflow, Twitter, Discord für Real-time Updates</p>
                </div>
              </div>

              <div className="coverage-section">
                <h3>Technologie Coverage</h3>
                <div className="coverage-grid">
                  <div className="coverage-item">
                    <span className="coverage-name">Incremental ProcGen</span>
                    <span className="coverage-percentage">85% → 95%</span>
                  </div>
                  <div className="coverage-item">
                    <span className="coverage-name">OpenUSD</span>
                    <span className="coverage-percentage">80% → 90%</span>
                  </div>
                  <div className="coverage-item">
                    <span className="coverage-name">BrickGPT</span>
                    <span className="coverage-percentage">40% → 85%</span>
                  </div>
                  <div className="coverage-item">
                    <span className="coverage-name">Hugging Face Models</span>
                    <span className="coverage-percentage">20% → 90%</span>
                  </div>
                </div>
              </div>
            </div>
          )}

          {activeTab === 'business-value' && (
            <div className="business-value-content">
              <h2>Business Value</h2>
              <p>
                Der Research Agent bietet messbare Business Value für KI-generierte Videospielentwicklung:
              </p>

              <div className="business-values-grid">
                {businessValues.map((value, index) => (
                  <div key={index} className="business-value-card">
                    <div className="business-value-header">
                      <span className="business-value-icon">{value.icon}</span>
                      <h3>{value.title}</h3>
                    </div>
                    <p className="business-value-description">{value.description}</p>
                    <ul className="business-value-metrics">
                      {value.metrics.map((metric, metricIndex) => (
                        <li key={metricIndex}>{metric}</li>
                      ))}
                    </ul>
                  </div>
                ))}
              </div>

              <div className="roi-section">
                <h3>ROI & Business Impact</h3>
                <div className="roi-grid">
                  <div className="roi-card">
                    <h4>Development Speed</h4>
                    <ul>
                      <li>Faster Research durch automatisierte Suche</li>
                      <li>Better Decisions durch wissenschaftliche Validierung</li>
                      <li>Reduced Risk durch Market Research</li>
                      <li>Innovation Boost durch Cross-Domain Insights</li>
                    </ul>
                  </div>
                  <div className="roi-card">
                    <h4>Quality Improvement</h4>
                    <ul>
                      <li>Evidence-based Design statt Intuition</li>
                      <li>Peer-reviewed Methods für Best Practices</li>
                      <li>Community Validation für User Acceptance</li>
                      <li>Technical Excellence durch Research Standards</li>
                    </ul>
                  </div>
                  <div className="roi-card">
                    <h4>Market Success</h4>
                    <ul>
                      <li>Trend Awareness für bessere Timing</li>
                      <li>User Understanding für bessere UX</li>
                      <li>Competitive Advantage durch Innovation</li>
                      <li>Risk Mitigation durch Research Validation</li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          )}

          {activeTab === 'ethical-controls' && (
            <div className="ethical-controls-content">
              <h2>Ethical Controls</h2>
              <p>
                Umfassende ethische Kontrolle für verantwortungsvolle KI-Entwicklung:
              </p>

              <div className="ethical-concerns-grid">
                <div className="ethical-concern-card">
                  <h3>🛡️ Addiction Research</h3>
                  <p>Bewusste Game Design Entscheidungen durch Gaming Psychology Research</p>
                  <div className="concern-status active">Standardmäßig aktiviert</div>
                </div>
                <div className="ethical-concern-card">
                  <h3>🚫 Community Manipulation</h3>
                  <p>Vermeidung von Community Manipulation und Echo Chambers</p>
                  <div className="concern-status inactive">Standardmäßig deaktiviert</div>
                </div>
                <div className="ethical-concern-card">
                  <h3>⚖️ AI Bias</h3>
                  <p>Erkennung und Vermeidung von AI Bias und Diskriminierung</p>
                  <div className="concern-status inactive">Standardmäßig deaktiviert</div>
                </div>
                <div className="ethical-concern-card">
                  <h3>💰 Commercialization</h3>
                  <p>Kontrolle über Kommerzialisierung von Forschung</p>
                  <div className="concern-status inactive">Standardmäßig deaktiviert</div>
                </div>
              </div>

              <div className="user-preferences-section">
                <h3>User Preferences</h3>
                <div className="preferences-grid">
                  <div className="preference-item">
                    <label>
                      <input type="checkbox" defaultChecked />
                      Addiction Research (für bewusste Entwicklung)
                    </label>
                  </div>
                  <div className="preference-item">
                    <label>
                      <input type="checkbox" />
                      Community Manipulation (gegen Manipulation)
                    </label>
                  </div>
                  <div className="preference-item">
                    <label>
                      <input type="checkbox" />
                      AI Bias (gegen Bias)
                    </label>
                  </div>
                  <div className="preference-item">
                    <label>
                      <input type="checkbox" />
                      Commercialization (gegen Kommerzialisierung)
                    </label>
                  </div>
                  <div className="preference-item">
                    <label>
                      <input type="checkbox" />
                      Echo Chambers (gegen Filter Bubbles)
                    </label>
                  </div>
                </div>
              </div>
            </div>
          )}

          {activeTab === 'sources' && (
            <div className="sources-content">
              <h2>Research Sources</h2>
              <p>
                Konfigurierbare APIs mit ethischen Kontrollen:
              </p>

              <div className="sources-categories">
                {['scientific', 'practical', 'ai', 'community'].map(category => (
                  <div key={category} className="source-category">
                    <h3 className={`category-title ${category}`}>
                      {category === 'scientific' && '🔬 Wissenschaftliche APIs (12)'}
                      {category === 'practical' && '🎮 Praktische APIs (6)'}
                      {category === 'ai' && '🤖 AI/ML APIs (8)'}
                      {category === 'community' && '👥 Community APIs (4)'}
                    </h3>
                    <div className="sources-list">
                      {researchSources
                        .filter(source => source.category === category)
                        .map(source => (
                          <div key={source.id} className={`source-item ${source.isEnabled ? 'enabled' : 'disabled'}`}>
                            <div className="source-header">
                              <span className="source-name">{source.name}</span>
                              <span className={`source-status ${source.isEnabled ? 'enabled' : 'disabled'}`}>
                                {source.isEnabled ? '✅' : '❌'}
                              </span>
                            </div>
                            <p className="source-description">{source.description}</p>
                            {source.ethicalConcerns.length > 0 && (
                              <div className="ethical-concerns">
                                <span className="concerns-label">Ethical Concerns:</span>
                                {source.ethicalConcerns.map(concern => (
                                  <span key={concern} className="concern-tag">{concern}</span>
                                ))}
                              </div>
                            )}
                          </div>
                        ))}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default ResearchAgentPage;
